Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA8A230BE9
	for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2025 20:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748550744; cv=none; b=V8E18RHmkrRU2tdv40AppNNNQIaQ8jxd+v62vvgrYYHAElThlUvPETrrGpgzUXz+Ax/fjPRjwt4X+sXQ4miYBuiX184B6mzz0n/f7lt7gx5xPclF0qIjt1izGnyE+LhSx5PpfXJAhwqX27UpxpmW/DcW9qmR9oQCgrByusdDbOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748550744; c=relaxed/simple;
	bh=5a3KW2LBqf7ELjvRnBdfAzF+GJkTNEJWAO4qotcO/WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs0oc+cLJ4Eg+gJSqsVpNapZ1d2dx1z2tc3p7tgLB7Bk2QqGlbiaTLjaNe8D/HqkNieL59NxsSbaruhl9OultVoi3vkKxHV/HVggOmCic+GJODy1+5CplcZcX1SM0igzwtzmCyrtFYT0w3KrKBrEfF3P/NyhFBR0QUeQqeMd0Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=IqUBJWk3; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IqUBJWk3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gyRc5JD5riVfk4X39qMzrWLSQQJsuRlHNONovx+nMto=; b=IqUBJWk39AVCLdGzhXN7qH9A6c
	HrPM+uPZS5NJX9LtdDi7QCUCUmAeKXTXeWG2A7ACq/J8S+BxiXIfPSUcnNL/ufnxUd/bFLqnTdQpN
	zKoJ/Pg2OQKM0T3OvoLmBa3jwp5yG+bZ1wsda2pU3VayURgDSwzfvyT74An7RgaVj2zcqbLFquIak
	QADtGygx25eXC7XAfkjpp0w211l4zWAFEDTs8X5I+cnvhGSvyzbfuBL71oQnN4frh+a/ZN/cJuoJK
	WeteFlXEwhmfaKGiCvfkPI6eqeRkVI3PuC6H+r7csyATFo6Qxp4uc2v/L86ez2PMw5yH55w/4vj8h
	VQmXT2QA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1uKjvA-003Dw5-1A;
	Thu, 29 May 2025 21:32:12 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 2/3] xt_pknock: replace obsolete `del_timer`
Date: Thu, 29 May 2025 21:31:45 +0100
Message-ID: <20250529203146.2415429-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250529203146.2415429-1-jeremy@azazel.net>
References: <20250529203146.2415429-1-jeremy@azazel.net>
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

`del_timer` was a wrapper around `timer_delete`, and it has been removed in
v6.15.  Replace it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/xt_pknock.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index 29016461db7a..fc488a46849a 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -30,6 +30,10 @@
 #include "xt_pknock.h"
 #include "compat_xtables.h"
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(6, 15, 0)
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

