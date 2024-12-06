Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40202206AA
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Dec 2024 18:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733509953; cv=none; b=F+PViCkmDx107IkiYdtEkXaxjNDNV1wdPWg3yflXr4/I4aQMIaLX5C9QD4u2+/rvxhLnIzwNXrVJmXfb/hx9craA5vM9DjCOHyBtT/ojKFujyadgFj660sC2c+L/qLoeTqyF6DNapQcla/dlSCO/WSdy07eSsh2rzGkeZiiXxvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733509953; c=relaxed/simple;
	bh=FkJryXPGr1cB1oo0Px+WOjT7SpbW7BZaKjYgWkJmjb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FmdAYoLvNkYi0KgjSJavFYgxRBYAjHfBZYxAswXgD0/TrT22yhlTJfU+5VHw+bLUZruFGnKprzlQ5bGKLHXuY7r3LwVLi7/4rBAKhto17lTBfErXbImBHRkMuijjYEfF8Sd2A9XMJ9hphXqoiOY+zxNv6JCEr6mQ/3R6mMnQ2a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PSKtbZso; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PSKtbZso"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nxIW1bITNQhu+dvkfdSBexbjXvXPICoEx50ZX6YRzTo=; b=PSKtbZsooPNSu8eVJo76WLgT11
	E0O8pm8EAADLn1mUX6fbz7RoimMnii1dlus331Cv1gi/m1zKNyvXSKpvEDXPrPG2N+IMK90/N9TwP
	hy9L3FpWOPrXji+7vDOputoxAZe2rbSrXUE4ChVEdtUsUnv5q8HuPeozH6G51zGc+FiVyLzRMCRAN
	2m2EcoSf7WN+N926JrCQ521DVlPkVKKJKkdUgAlt5qkMkf7wGdQFAWjQc7Sk2iOG2cIWTQ264j2wU
	zPVGVAX6+k5LiZp9hkvWB2hNrc3o3tV214t2yBdybLofGKHSvBu2AMq3ErLBKxivPLFxMd4NTGRNk
	8UUvJdsQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tJd7s-0000000027O-0P0d;
	Fri, 06 Dec 2024 19:32:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: IDLETIMER: Fix for possible ABBA deadlock
Date: Fri,  6 Dec 2024 19:32:29 +0100
Message-ID: <20241206183229.2028-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 net/netfilter/xt_IDLETIMER.c | 52 +++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index f8b25b6f5da7..9869ef3c2ab3 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -409,21 +409,23 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 
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
@@ -434,25 +436,27 @@ static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
 
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
2.47.0

