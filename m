From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 04/11] added alarm_pending()
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.28791.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:46702 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754048AbYAVOLG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:11:06 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/alarm.h   |    2 ++
 src/alarm.c       |   10 ++++++++++
 src/cache_timer.c |    5 ++++-
 3 files changed, 16 insertions(+), 1 deletions(-)


diff --git a/include/alarm.h b/include/alarm.h
index c4ea9d7..e791057 100644
--- a/include/alarm.h
+++ b/include/alarm.h
@@ -24,6 +24,8 @@ void add_alarm(struct alarm_list *alarm, unsigned long sc, unsigned long usc);
 
 void del_alarm(struct alarm_list *alarm);
 
+int alarm_pending(struct alarm_list *alarm, struct timeval *tv);
+
 struct timeval *
 get_next_alarm_run(struct timeval *next_alarm);
 
diff --git a/src/alarm.c b/src/alarm.c
index 7352ccb..7cbae10 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -70,6 +70,16 @@ void del_alarm(struct alarm_list *alarm)
 		list_del_init(&alarm->head);
 }
 
+int alarm_pending(struct alarm_list *alarm, struct timeval *tv)
+{
+	if (list_empty(&alarm->head))
+		return 0;
+
+	if (tv != NULL)
+		*tv = alarm->tv;
+	return 1;
+}
+
 static struct timeval *
 calculate_next_run(struct timeval *cand,
 		   struct timeval *tv, 
diff --git a/src/cache_timer.c b/src/cache_timer.c
index 86bb8fc..a7afbe2 100644
--- a/src/cache_timer.c
+++ b/src/cache_timer.c
@@ -60,8 +60,11 @@ static int timer_dump(struct us_conntrack *u, void *data, char *buf, int type)
 	if (type == NFCT_O_XML)
 		return 0;
 
+	if (!alarm_pending(alarm, &tmp))
+		return 0;
+
 	gettimeofday(&tv, NULL);
-	timersub(&tv, &alarm->tv, &tmp);
+	timersub(&tv, &tmp, &tmp);
 	return sprintf(buf, " [expires in %lds]", tmp.tv_sec);
 }
 


