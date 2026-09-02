Received: from sonic306-28.consmr.mail.ne1.yahoo.com (sonic306-28.consmr.mail.ne1.yahoo.com [66.163.189.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24961422556
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386543; cv=none; b=I//r8J5Olz9qBTA+0uYIgA+Wwm/KQ+caytthFfIkaeXGNgkIIB5KNyKY64Z/RBQ23aqUXF8ZfJ/WbP2/erQJl7KvjfWW59SxwQ2oHxlY8mxh7tjhYvrMUd8vgefUcgPs0ZW+q/5Uq7922GCNhRy/l/MAGfkjCrL0C6KrQ2MJtPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386543; c=relaxed/simple;
	bh=YePZ51dlYmZ/cucTyw+gosn8F7f35BMcwjmeoZtY7Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cw6W8cfkGULY5AQ+BTHlcdkICz9UcUlcmE27ud7DwzE+cRf3yYxnymbFVhQYhzmxQgWNT4yUZNaDzeTIah9bIBdseR1C6w6ZfQVEMsT1m817BuUcf81x+1e3ke6qK4TU/zo5sLqCx+nIQfzJoFZpZ5PfFVc6peFO56Nxldv87Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=moyRBFJn; arc=none smtp.client-ip=66.163.189.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="moyRBFJn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386526; bh=yHlrmN78oxAAQbX+BTQB5IQgb1bzCbKp9XLNwOjJhUs=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=moyRBFJnmjEOXp0cu0W0YXF51tTa/JKusHspmFEp1fCf88plxwqPUJ4YgU0txTeCf7IKmEWM5EqDiXJg0VUMVrFCpNpuDZiZqZelfEzF0RpycarI/wgiVvXYEyh4mbEB/9BjTkCFJNoJafg13BfHpA86c+sQN47Y7hhpKrVZwRFCMt9xVz9k6XpGici/umXBCkOSKOEaYADtGNrgV3f2iHg6mu+s2NeBvlTkzPgHErBEV3ndsGA2RPuAAqC0J4f10UFL7XmKq1VKAtCnWy+6r2kBKolryyogd7DC+qFwNxNCq9P3ozEZc62SYAtExq4Zwj0eK0k1XA0ZGd4HaUHw2g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386526; bh=rHAuPVQSlNPBPD1AZj8DFXMRW5csewSbXSJoRErwmEK=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=UXyDgj/fThrxCWNpEAjyGPVXEYfN2zvC6X3Zsl67TzVL/7p+BQu+V50Zo398nPPFrJ7shLasldvyHywG/yudt0s/CC7/6m3la7M6NCKEyw0OawSVHkiOZMwLW7fs2m4CAr1pw5YMaYAOVsxup8VXFQALMXPp4rq9lB2hgXFFtOgaAieJdi+dQ67ggF/da7rOJWWBmFQTusEMZZTfktOklSFrcZ8kQK0sWlyxsnxUhVEdzU8y8z2yiq51xDeKCs3ZUQAcy/4wBalceSH9JoEQsINVYug3XiRtFQfTTEQs6sC8JvQ+p02xk4WtNRFxijh454kJ0sinJwtNp0GFVbEm+A==
X-YMail-OSG: c2CNKksVM1nrISRBf2URQ6BWUvFkDkFeXETfEGOGpuAYHacV83L2Ib4DRZc7VyV
 5bA4P1tEFEy_j7_ek6i9n_zKnVTPfQO6pB.J8ksEX9xqJDBkhWs4dg_epQHazN5HhXhZIZxw8yQP
 7tyuGl1FBXfCwTaZrj2dxL5tK0i_LOuiNU_6NRXI89gSzEzsC7TnE.DbttsF0GHF5P6Jvrrn8_Om
 nIXDfW3bleFkx8SxbmfAVfyl4bFIw5tVGJILFCv2Ivu4NihPDw.QJrbjh7EoBN3dlbkzKdZI8c5t
 JaMu790XpWH73l3uvDsIy_Qe2nYxVCp68N7nrse5D3zcdQwTmgoE7OpEh9AuTlCJgu5Tyg24ThuF
 pVwCxDLYLk0vo4VYanNSndoW0y.1IEARERia8Ce9qtUOLiLG5YenGDIySt4CiFzP6o34ZPziTbrK
 5o8EUOb.3jbn6w_pDiZ0.GJioFssWqosBB0.Slehod1adqnENqhvTY3uJ.1szVxgc7ir9V2CCbmm
 kl0mdiflqFmiEVjZnVOQqUrX.OS3NHUHwqYNjgqFoiyGR06EQmKG79VayPIoBcpMLhcDL29zK21Y
 WJnm3cfEyd1I_O6uuUtqpSMYdCkSK_hiCwqDC6wf67XQSYXkaCRUX0xF0lDN8sfmqup7jsRHfFQ4
 hPDnroqIzO7tIQsrUSIBJBlx3pFiHdboEjULZKom1VJXLmrinbIZwoDDI_qaYmjekPjm_VvfW0Zm
 EevRuSS4LKOVC7OP1kRQrx_fk6IJk.ml.uvwpciRbx5szX8UHBYKFyzF8rwIe5baSjgO98tj7UxI
 3QpMdoG5pokKNdNkHzSFHm9FBFy1ioat78hc3uSJ3YEHdYnaIA8TDZa0h9Od8K3mXg8Cf5YIUhVw
 PYFwY1LYdDDL0iizAWwOjsiV.shpi8tPLe63RW8TCRgECmcI.Cry0SzacePbQUslQg2WWYRADFcY
 FB5bs0MrI1KI3Xa7AsaPuN2SJT.qckgry8H_WH.Mbx1vwC2B_o49fSC4GYlYK4GSvxC8VWJuIM5d
 _6g0Kpp7Aw60gc.kuquz0.xn.g77FgAqh8Zm5ndXm.5N6iicTkRfiISPkZ9iTt.P5_CGCAOpU_j8
 h2_psp7nj0urwZXsDQ.zqTdu2eJEKanbz9R2n7EOHqggpGQGllzAdyyiwqbSSaxQhqQ7CeYoz1Q2
 ydz4ty.DChasU2_qDw1uWGF2mvQPR13IhBy6_lQM3NkESmu2IuyFcqsOEbbw4juwwZpC5K1F2301
 hThZJx1Wj2X_NNfteBQW8zY9Q_5dw579DwE1fLIBBa782i.3yWKXo685iq9X1wXRG1PHh9JsA4lT
 zeqRWfxEjSzDhlWPjVQgqSnEGyrDlkF49roHbEjdohWIMdg8aUaGx4VNsDMpbOvqOr6JfDAPgQJg
 qafcKqJd2NuELZdR36tXcMUcX8PDrwMlMX2QPd7m9VtJYJlEiVBK8wjURUgPVurqzeRI6R8D3hOc
 3.b1vmjCgTjdizyIL1o5AKXwgJ1rwtzKIWVZNlBI.Bnr18eikPJNVwMqGAZsRMWHRcWYkNbs91ts
 kNW69_HUYod0ui7eDDdo7Jcf6FFN6bFQSF6oylzf31IfVcl69EVB6JZ7wzjS81ecYypY6oXnz6.U
 FiTZ2dkSes7fgQT_rxeVjgrPQDXrQeylqr5fazLJnKHsrtQDDuR4I3uYgoWMP1lASpqmvY4IZwyp
 7FH46lTGjIA5tUFkw6GsstMKlqLcIZMlrzdb_5lulMMeB_MIsdaG124ptIrAbwGvs3g9FcRwE4cD
 lORHwnDClZ7VHanZ2vQCWbxC6iA3Qx4iyYugFHVWJTH1AU4Gm1HWXcY7RbtXcUeTAWSorI7EIHfz
 1gWwaYAv62Ys0Waz3wIjpPNJyVAWsUXI2bwTREAy9M2Dk2X3ZFuStjGKgiYQUodJq.BREwLm8jU6
 dKqXEMy4ITVQFvjvplSYF6l_3O6vraZpdzaD8t00nJYZqiZCV79yj1qOabdfMSaVD.KFhoz8GMcX
 uB4MyGkmLzAJ9hR0mIeP_UwYLAX1QOjviE40H3aRy8UbL2sAPCUI0JwHEFKZPIYhHvGZGimDEErE
 Dd6deAGHJvYuf6ApPjb1VkLA9AQ559Z0JsCx.oNacj39Mg4Kj04j6coLn5Z8MdsOCwaHdxo24S3_
 zYifJUzJQscmHkPDIlm5rliBU7oYZWyBhX1N6cyav.PEvvnAN31wk_OGUw1j5UWjRkWgi5FLuzfc
 4rd3BJCDcCP8XvBSniiP6iWiEdPlq6qI1spsAomAAAhSlalM.ROirbuqBYtndXkioluVLvUn4ef8
 w8UfY2dDVBGViqQkpLEftI_E-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 38997c78-a1ee-469c-a996-0309c53fa4f3
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:06 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:04 +0000 (UTC)
From: Casey Schaufler <casey@schaufler-ca.com>
To: casey@schaufler-ca.com,
	paul@paul-moore.com,
	linux-security-module@vger.kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Cc: linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	jmorris@namei.org,
	serge@hallyn.com,
	keescook@chromium.org,
	john.johansen@canonical.com,
	penguin-kernel@i-love.sakura.ne.jp,
	stephen.smalley.work@gmail.com,
	selinux@vger.kernel.org
Subject: [PATCH v2 1/7] net, smack: Create a function to set secmarks
Date: Wed,  2 Sep 2026 15:01:44 -0700
Message-ID: <20260902220150.18586-2-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260902220150.18586-1-casey@schaufler-ca.com>
References: <20260902220150.18586-1-casey@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than open coding assignments to skb->secmark, use a helper function
secxa_set_secmark(). This allows for a case where assigning a secmark
is more complex than a simple assignment. The version of the function
here does the legacy simple assignment.

Change the functions that currently assign values to skb->secmark to
use this function.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/lsm_secxa.h        | 28 ++++++++++++++++++++++++++++
 net/netfilter/nft_meta.c         |  5 +++--
 net/netfilter/xt_CONNSECMARK.c   |  3 ++-
 net/netfilter/xt_SECMARK.c       |  3 ++-
 security/smack/smack_netfilter.c |  3 ++-
 5 files changed, 37 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/lsm_secxa.h

diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
new file mode 100644
index 000000000000..926257d4730c
--- /dev/null
+++ b/include/linux/lsm_secxa.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2026 Casey Schaufler <casey@schaufler-ca.com>
+ */
+
+#ifndef __LINUX_LSM_SECXA_H
+#define __LINUX_LSM_SECXA_H
+
+#ifdef CONFIG_NETWORK_SECMARK
+
+#include <linux/security.h>
+#include <linux/skbuff.h>
+
+static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
+{
+	skb->secmark = secxa;
+}
+#else /* CONFIG_NETWORK_SECMARK */
+
+struct sk_buff;
+
+static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
+{
+}
+#endif /* CONFIG_NETWORK_SECMARK */
+
+#endif  /* __LINUX_LSM_SECXA_H */
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 0a43e0787a68..bd0f7a0931f4 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -17,6 +17,7 @@
 #include <linux/random.h>
 #include <linux/smp.h>
 #include <linux/static_key.h>
+#include <linux/lsm_secxa.h>
 #include <net/dst.h>
 #include <net/ip.h>
 #include <net/sock.h>
@@ -502,7 +503,7 @@ void nft_meta_set_eval(const struct nft_expr *expr,
 		break;
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-		skb->secmark = value;
+		secxa_set_secmark(skb, value);
 		break;
 #endif
 	default:
@@ -950,7 +951,7 @@ static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs,
 	const struct nft_secmark *priv = nft_obj_data(obj);
 	struct sk_buff *skb = pkt->skb;
 
-	skb->secmark = priv->secid;
+	secxa_set_secmark(skb, priv->secid);
 }
 
 static int nft_secmark_obj_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 1494b3ee30e1..9d799d2459dc 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/lsm_secxa.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_CONNSECMARK.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -55,7 +56,7 @@ static void secmark_restore(struct sk_buff *skb)
 
 		ct = nf_ct_get(skb, &ctinfo);
 		if (ct && ct->secmark)
-			skb->secmark = ct->secmark;
+			secxa_set_secmark(skb, ct->secmark);
 	}
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 5bc5ea505eb9..ea67aa92ddc2 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
 #include <linux/security.h>
+#include <linux/lsm_secxa.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_SECMARK.h>
@@ -36,7 +37,7 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 		BUG();
 	}
 
-	skb->secmark = secmark;
+	secxa_set_secmark(skb, secmark);
 	return XT_CONTINUE;
 }
 
diff --git a/security/smack/smack_netfilter.c b/security/smack/smack_netfilter.c
index 17ba578b1308..b363c42f252e 100644
--- a/security/smack/smack_netfilter.c
+++ b/security/smack/smack_netfilter.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netdevice.h>
+#include <linux/lsm_secxa.h>
 #include <net/inet_sock.h>
 #include <net/net_namespace.h>
 #include "smack.h"
@@ -29,7 +30,7 @@ static unsigned int smack_ip_output(void *priv,
 	if (sk) {
 		ssp = smack_sock(sk);
 		skp = ssp->smk_out;
-		skb->secmark = skp->smk_secid;
+		secxa_set_secmark(skb, skp->smk_secid);
 	}
 
 	return NF_ACCEPT;
-- 
2.54.0

