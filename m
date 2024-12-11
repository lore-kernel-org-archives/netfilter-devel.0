Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D71C1C1F2F;
	Wed, 11 Dec 2024 23:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733958104; cv=none; b=OfceAzEtFijQJYu1eNC3g7/2o4pccNNyvqorJcMsr47JfYeaNkqdY46IkUeG4oiuphjCbow7tTr9P+2HWzJMRWfAP7+YYjx66QgsOpejNmWog1/iiJ77XPgIOPpM7X6xls6OjBWcCElGM/Ct47YfnC83wMllBxx81iKLShV1AKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733958104; c=relaxed/simple;
	bh=LR3mbaWIOrSc78aLlgRKjl76IaI/JO0hIskJHCX8kps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZsWVWzxs+JkqdNzv5pUpGhfsnqYO38BzTMsFOwY9Q0Wsbj+IsiciR1eZaF8wK8pSnROT5JcMC5PF7uKjiXwJAKGd8TWERsDvTxchtkajikSlV6PCY1fMZt4/5RERz9WDduCL0iyvScTcfJrgz1M37XE0572Hnq4S+R1XSsA3aWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	phil@netfilter.org
Subject: [PATCH net 2/3] netfilter: IDLETIMER: Fix for possible ABBA deadlock
Date: Thu, 12 Dec 2024 00:01:29 +0100
Message-Id: <20241211230130.176937-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241211230130.176937-1-pablo@netfilter.org>
References: <20241211230130.176937-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Deletion of the last rule referencing a given idletimer may happen at
the same time as a read of its file in sysfs:

| ======================================================
| WARNING: possible circular locking dependency detected
| 6.12.0-rc7-01692-g5e9a28f41134-dirty #594 Not tainted
| ------------------------------------------------------
| iptables/3303 is trying to acquire lock:
| ffff8881057e04b8 (kn->active#48){++++}-{0:0}, at: __kernfs_remove+0x20
|
| but task is already holding lock:
| ffffffffa0249068 (list_mutex){+.+.}-{3:3}, at: idletimer_tg_destroy_v]
|
| which lock already depends on the new lock.

A simple reproducer is:

| #!/bin/bash
|
| while true; do
|         iptables -A INPUT -i foo -j IDLETIMER --timeout 10 --label "testme"
|         iptables -D INPUT -i foo -j IDLETIMER --timeout 10 --label "testme"
| done &
| while true; do
|         cat /sys/class/xt_idletimer/timers/testme >/dev/null
| done

Avoid this by freeing list_mutex right after deleting the element from
the list, then continuing with the teardown.

Fixes: 0902b469bd25 ("netfilter: xtables: idletimer target implementation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_IDLETIMER.c | 52 +++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 85f017e37cfc..9f54819eb52c 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -407,21 +407,23 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 
 	mutex_lock(&list_mutex);
 
-	if (--info->timer->refcnt == 0) {
-		pr_debug("deleting timer %s\n", info->label);
-
-		list_del(&info->timer->entry);
-		timer_shutdown_sync(&info->timer->timer);
-		cancel_work_sync(&info->timer->work);
-		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
-		kfree(info->timer->attr.attr.name);
-		kfree(info->timer);
-	} else {
+	if (--info->timer->refcnt > 0) {
 		pr_debug("decreased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
+		mutex_unlock(&list_mutex);
+		return;
 	}
 
+	pr_debug("deleting timer %s\n", info->label);
+
+	list_del(&info->timer->entry);
 	mutex_unlock(&list_mutex);
+
+	timer_shutdown_sync(&info->timer->timer);
+	cancel_work_sync(&info->timer->work);
+	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	kfree(info->timer->attr.attr.name);
+	kfree(info->timer);
 }
 
 static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
@@ -432,25 +434,27 @@ static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
 
 	mutex_lock(&list_mutex);
 
-	if (--info->timer->refcnt == 0) {
-		pr_debug("deleting timer %s\n", info->label);
-
-		list_del(&info->timer->entry);
-		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
-			alarm_cancel(&info->timer->alarm);
-		} else {
-			timer_shutdown_sync(&info->timer->timer);
-		}
-		cancel_work_sync(&info->timer->work);
-		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
-		kfree(info->timer->attr.attr.name);
-		kfree(info->timer);
-	} else {
+	if (--info->timer->refcnt > 0) {
 		pr_debug("decreased refcnt of timer %s to %u\n",
 			 info->label, info->timer->refcnt);
+		mutex_unlock(&list_mutex);
+		return;
 	}
 
+	pr_debug("deleting timer %s\n", info->label);
+
+	list_del(&info->timer->entry);
 	mutex_unlock(&list_mutex);
+
+	if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
+		alarm_cancel(&info->timer->alarm);
+	} else {
+		timer_shutdown_sync(&info->timer->timer);
+	}
+	cancel_work_sync(&info->timer->work);
+	sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
+	kfree(info->timer->attr.attr.name);
+	kfree(info->timer);
 }
 
 
-- 
2.30.2

