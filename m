From: heitzenberger@astaro.com
Subject: [ULOGD RFC 03/30] Replace timer code by working version
Date: Wed, 30 Jan 2008 19:58:50 +0100
Message-ID: <20080130190126.735398130@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-67.dex002.intermedia.net ([64.78.20.25]:39625 "EHLO
	DHOST002-67.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546AbYA3TBl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:41 -0500
Content-Disposition: inline; filename=ulogd-timer-handling.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace existing timer code by simple and more importantly working
version.  Current resolution is one second, which may be easily
extended if need be.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/include/ulogd/ulogd.h
===================================================================
--- ulogd-netfilter.orig/include/ulogd/ulogd.h
+++ ulogd-netfilter/include/ulogd/ulogd.h
@@ -240,17 +240,31 @@ void ulogd_unregister_fd(struct ulogd_fd
 int ulogd_select_main();
 
 /***********************************************************************
- * timer handling
+ * timer handling (timer.c)
  ***********************************************************************/
+#define TIMER_F_USED			0x0001
+#define TIMER_F_PERIODIC		0x0002
 
 struct ulogd_timer {
 	struct llist_head list;
-	struct timeval expires;
-	void (*cb)(void *data);
-	void *data;
+	unsigned expires;			/* seconds */
+	unsigned ival;				/* seconds */
+	unsigned flags;
+	void (* cb)(struct ulogd_timer *);
+	void *data;					/* usually (ulogd_pluginstance *) */
 };
 
+extern struct timeval tv_now;
+extern struct timeval tv_now_local;
+
+#define t_now			tv_now.tv_sec
+#define t_now_local		tv_now_local.tv_sec
+
+int ulogd_timer_init(void);
+int ulogd_timer_run(void);
 int ulogd_register_timer(struct ulogd_timer *timer);
 void ulogd_unregister_timer(struct ulogd_timer *timer);
+void ulogd_timer_schedule(void);
+int ulogd_timer_handle(void);
 
 #endif /* _ULOGD_H */
Index: ulogd-netfilter/src/timer.c
===================================================================
--- ulogd-netfilter.orig/src/timer.c
+++ ulogd-netfilter/src/timer.c
@@ -18,6 +18,9 @@
  *  You should have received a copy of the GNU General Public License
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *
+ * H. Eitzenberger <holger@eitzenberger.org>  Astaro AG, 2007
  */
 
 #include <unistd.h>
@@ -25,143 +28,115 @@
 #include <string.h>
 #include <sys/time.h>
 #include <time.h>
+#include <errno.h>
 
 #include <ulogd/ulogd.h>
+#include <ulogd/common.h>
 #include <ulogd/linuxlist.h>
 
 static LLIST_HEAD(ulogd_timers);
+static struct tm tm_local;
+struct timeval tv_now, tv_now_local;
 
-static void tv_normalize(struct timeval *out)
-{
-	out->tv_sec += (out->tv_usec / 1000000);
-	out->tv_usec = (out->tv_usec % 1000000);
-}
 
-/* subtract two struct timevals */
-static int tv_sub(struct timeval *res, const struct timeval *from,
-		  const struct timeval *sub)
+int
+ulogd_register_timer(struct ulogd_timer *timer)
 {
-	/* FIXME: this stinks.  Deal with wraps, carry, ... */
-	res->tv_sec = from->tv_sec - sub->tv_sec;
-	res->tv_usec = from->tv_usec - sub->tv_usec;
+	pr_debug("%s: timer=%p\n", __func__, timer);
+
+	if (timer->flags & TIMER_F_USED) {
+		ulogd_log(ULOGD_ERROR, "timer already registered\n");
+		return -1;
+	}
+
+	if (timer->flags & TIMER_F_PERIODIC) {
+		timer->expires = t_now + timer->ival;
+	} else {
+		if (timer->expires == 0) {
+			errno = EINVAL;
+			return -1;
+		}
+	}
+
+	timer->flags |= TIMER_F_USED;
+
+	llist_add_tail(&timer->list, &ulogd_timers);
 
 	return 0;
 }
 
-static int tv_add(struct timeval *res, const struct timeval *a1,
-		  const struct timeval *a2)
+
+void
+ulogd_unregister_timer(struct ulogd_timer *timer)
 {
-	unsigned int carry;
+	pr_debug("%s: timer=%p\n", __func__, timer);
 
-	res->tv_sec = a1->tv_sec + a2->tv_sec;
-	res->tv_usec = a1->tv_usec + a2->tv_usec;
+	/* TODO check for race conditions on unregister */
 
-	tv_normalize(res);
-}
+	if ((timer->flags & TIMER_F_USED) == 0)
+		return;					/* not registered */
 
-static int tv_later(const struct timeval *expires, const struct timeval *now)
-{
-	if (expires->tv_sec < now->tv_sec)
-		return 0;
-	else if (expires->tv_sec > now->tv_sec)
-		return 1;
-	else /* if (expires->tv_sec == now->tv_sec */ {
-		if (expires->tv_usec >= now->tv_usec)
-			return 1;
-	}
+	timer->flags &= ~TIMER_F_USED;
 
-	return 0;
+	llist_del(&timer->list);
 }
 
-static int tv_smaller(const struct timeval *t1, const struct timeval *t2)
-{
-	return tv_later(t2, t1);
-}
 
-static int calc_next_expiration(void)
+int
+ulogd_timer_handle(void)
 {
-	struct ulogd_timer *cur;
-	struct timeval min, now, diff;
-	struct itimerval iti;
-	int ret;
-
-retry:
-	if (llist_empty(&ulogd_timers))
-		return 0;
-
-	llist_for_each_entry(cur, &ulogd_timers, list) {
-		if (ulogd_timers.next == &cur->list)
-			min = cur->expires;
-
-		if (tv_smaller(&cur->expires, &min))
-			min = cur->expires;
-	}
+	struct ulogd_timer *t;
 
-	if (tv_sub(&diff, &min, &now) < 0) {
-		/* FIXME: run expired timer callbacks */
-		/* we cannot run timers from here since we might be
-		 * called from register_timer() within check_n_run() */
+	t_now = time(NULL);			/* UTC */
 
-		/* FIXME: restart with next minimum timer */
-		goto retry;
-	}
+	pr_debug("%s: t_now=%ld\n", __func__, t_now);
 
-	/* re-set kernel timer */
-	memset(&iti, 0, sizeof(iti));
-	memcpy(&iti.it_value, &diff, sizeof(iti.it_value));
-	ret = setitimer(ITIMER_REAL, &iti, NULL);
-	if (ret < 0)
-		return ret;
+	/* get offset to local time every hour */
+	if ((t_now % (1 HOUR)) == 0)
+		localtime_r(&t_now, &tm_local);
 
-	return 0;
-}
+	t_now_local = t_now + tm_local.tm_gmtoff;
 
-void ulogd_timer_check_n_run(void)
-{
-	struct ulogd_timer *cur, *cur2;
-	struct timeval now;
+	llist_for_each_entry(t, &ulogd_timers, list) {
+		assert(t->flags & TIMER_F_USED);
 
-	if (gettimeofday(&now, NULL) < 0)
-		return;
+		if (t->expires <= t_now) {
+			(t->cb)(t);
 
-	llist_for_each_entry_safe(cur, cur2, &ulogd_timers, list) {
-		if (tv_later(&cur->expires, &now)) {
-			/* fist delete it from the list of timers */
-			llist_del(&cur->list);
-			/* then call.  called function can re-add it */
-			(cur->cb)(cur->data);
+			if (t->flags & TIMER_F_PERIODIC)
+				t->expires = t_now + t->ival;
+			else
+				llist_del(&t->list);
 		}
 	}
 
-	calc_next_expiration();
+	return 1;
 }
 
 
-int ulogd_register_timer(struct ulogd_timer *timer)
+int
+ulogd_timer_init(void)
 {
-	int ret;
-	struct timeval tv;
-
-	ret = gettimeofday(&tv, NULL);
-	if (ret < 0)
-		return ret;
-
-	/* convert expiration time into absoulte time */
-	timer->expires.tv_sec += tv.tv_sec;
-	timer->expires.tv_usec += tv.tv_usec;
-
-	llist_add_tail(&timer->list, &ulogd_timers);
-
-	/* re-calculate next expiration */
-	calc_next_expiration();
+	t_now = time(NULL);
+	localtime_r(&t_now, &tm_local);
 
 	return 0;
 }
 
-void ulogd_unregister_timer(struct ulogd_timer *timer)
-{
-	llist_del(&timer->list);
 
-	/* re-calculate next expiration */
-	calc_next_expiration();
+/* start periodic timer */
+int
+ulogd_timer_run(void)
+{
+	struct itimerval itv = {	/* run timer every second */
+		.it_interval = { .tv_sec = 1, },
+		.it_value = { .tv_sec = 1, },
+	};
+
+	if (setitimer(ITIMER_REAL, &itv, NULL) < 0) {
+		ulogd_log(ULOGD_ERROR, "setitimer: %s\n", strerror(errno));
+		return -1;
+	}
+
+	return 0;
 }

-- 
