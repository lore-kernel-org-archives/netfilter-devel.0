From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH/RFC 1/2] optimization updating timer in connection tracking
Date: Sun, 19 Sep 2004 23:34:14 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414DFB56.1050503@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000907080601010901090106"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000907080601010901090106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

I think that I found something interesting reading kernel/timer.c some 
weeks ago, well I would like to know about this idea. The comment above 
mod_timer speaks by itself...

 * mod_timer(timer, expires) is equivalent to:
 *
 *     del_timer(timer); timer->expires = expires; add_timer(timer);
 *
 * Note that if there are multiple unserialized concurrent users of the
 * same timer, then mod_timer() is the only safe way to modify the timeout,
 * since add_timer() cannot modify an already running timer.
 *
 * The function returns whether it has modified a pending timer or not.
 * (ie. mod_timer() of an inactive timer returns 0, mod_timer() of an
 * active timer returns 1.)

so I think that you could use mod_timer in 2.6 and remove that 
WRITE_LOCK when updating the timer, because it's there to serialize 
timer updates and now mod_timer controls this possible situation. I 
don't have a smp machine here but this week I'll look for a platform to 
test it.

If I'm missing something, please let me know.

regards,
Pablo

--------------000907080601010901090106
Content-Type: text/x-patch;
 name="conntrack-update-timer-optimize.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="conntrack-update-timer-optimize.patch"

diff -u -r1.1.1.2 ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	4 Sep 2004 17:33:46 -0000	1.1.1.2
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	18 Sep 2004 18:59:07 -0000
@@ -1162,14 +1162,13 @@
 		ct->timeout.expires = extra_jiffies;
 		ct_add_counters(ct, ctinfo, skb);
 	} else {
-		WRITE_LOCK(&ip_conntrack_lock);
-		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
-			ct->timeout.expires = jiffies + extra_jiffies;
-			add_timer(&ct->timeout);
-		}
+		/* In 2.6 you can use mod_timer to add some extra jiffies
+		 * to an active timer, see kernel/timer.c. Even better, we
+		 * don't need to lock the conntrack table because mod_timer
+		 * takes care about a possible concurrent update, this
+		 * kills a pretty bottleneck ;-) */
+		mod_timer(&ct->timeout, jiffies + extra_jiffies);
 		ct_add_counters(ct, ctinfo, skb);
-		WRITE_UNLOCK(&ip_conntrack_lock);
 	}
 }
 

--------------000907080601010901090106--
