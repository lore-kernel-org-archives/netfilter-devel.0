Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CCE23185B
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748551709; cv=none; b=LP3+zgzA64+S+dDxStcV1JsCFyYjGTfxv1TIi+3jR8tHzKbDjLw87BkEHtsAuAAEhHsVkEeJNN6yNjfM9mEkqJaGdMMip2fB/GbVDml+GA+YTCUEB0KvwoKuEFOHipx8mJRkyvOayO7oJ7Q3I+LsvyWFXoN5lJATJOpzmhw2Hyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748551709; c=relaxed/simple;
	bh=KiW3e7+pjYyZDpoXF7PBCh88OIXY/RjoVCvbEeMn1aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOhaaiuAuKEbqsKql2NKDuFCRIbp3890Tyx0OeJwmBWsL7G/XVHVuTowSJ0Wg4GGpRtY57oFK9fhYFPmNtB9t7MPsnlHidutDk9y5mSaWxqneTtE7BB8NwYZDOQ7TuGdKO8pb6mH7NHbdaGA6rP/74f3fwVtHCm/8oq5bIeDl9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=CSdnkpai; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="CSdnkpai"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zL6O/GalTphDiElYYpK5ZOJMP/6CvdbHwyQDqQ8l8t0=; b=CSdnkpaifgfESN1XIOGURqdVke
	6CnF76VAdUI2pyAj4QOLn836963XI97w/yO4QM8hVE5+DxoT+I2XivsLSa3b/3DVCEwUxQxTQgIC0
	Ovb6r11jl90hk7Kt5fvuWxgvqFBqJx0muK8OVhsdDFSL+r2JwSEt4WDd92upgXLKH8SN0Lukc7ACo
	148oY9etwhJ86aGks3doBxNKcNhNTeF5YMel/R+3vr9AnD1R/k/pFkGMmpOXDM9KU3Iz9gBvDSPwP
	Nx3Fw5qb/Tb+L+DX+MEbDHL48AjIbQ0Rl+nYD3b8jBPcjspLpWDSEjWnstiSOHTt8AdtyQHpEc3bi
	k2EJ3eyA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKkAr-003E8C-2G;
	Thu, 29 May 2025 21:48:25 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 2/3] xt_pknock: replace obsolete `del_timer`
Date: Thu, 29 May 2025 21:48:03 +0100
Message-ID: <20250529204804.2417289-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250529204804.2417289-1-jeremy@azazel.net>
References: <20250529204804.2417289-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

`del_timer` was converted to a wrapper around `timer_delete` in v6.2, and
removed in v6.15.  Replace it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/xt_pknock.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index 29016461db7a..be435c4abde2 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -30,6 +30,10 @@
 #include "xt_pknock.h"
 #include "compat_xtables.h"
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(6, 2, 0)
+#define timer_delete(X) del_timer(X)
+#endif
+
 enum status {
 	ST_INIT = 1,
 	ST_MATCHING,
@@ -296,7 +300,7 @@ static const struct proc_ops pknock_proc_ops = {
 static void update_rule_gc_timer(struct xt_pknock_rule *rule)
 {
 	if (timer_pending(&rule->timer))
-		del_timer(&rule->timer);
+		timer_delete(&rule->timer);
 	rule->timer.expires = jiffies + msecs_to_jiffies(gc_expir_time);
 	add_timer(&rule->timer);
 }
@@ -517,7 +521,7 @@ remove_rule(struct xt_pknock_mtinfo *info)
 		remove_proc_entry(info->rule_name, pde);
 	pr_debug("(D) rule deleted: %s.\n", rule->rule_name);
 	if (timer_pending(&rule->timer))
-		del_timer(&rule->timer);
+		timer_delete(&rule->timer);
 	list_del(&rule->head);
 	kfree(rule->peer_head);
 	kfree(rule);
-- 
2.47.2

