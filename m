Received: from sonic306-27.consmr.mail.ne1.yahoo.com (sonic306-27.consmr.mail.ne1.yahoo.com [66.163.189.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF59E35F192
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654154; cv=none; b=s3nmE1lZe9Vbb/7eM2ujliPdEfIl4+65fzSUvQnJ08/D4JdlAzkDL8NYhmxORr2e93Y3CRlP+a/7p4DVYPm3vnalsGa01hjB2vfgRYNcYwHuFcsPi4UsxRZBMOCt4MgFWc+t3QZhjO91G9+4xtLwQpCxMqhkUKXgxc6LeT4xuGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654154; c=relaxed/simple;
	bh=EIsDw/T1e28+cOLE63avay4qSNMYbGAZOtb2QqfUXTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqq9Ym+SDhZqLp9GSncYkMiDVe/gg1VbwwCV3DIwS3EcH0DnJdCPlslaAydVBuS1XvpCV3C6m43no8Bc3QabyynQgHL5G8XHIETAGQQTRPabe7AHnOVlpBMquVna2QyOtXITBpCJjEupGi66yIeKcr80yQMHshbF6IDoj3R51pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ULCeWBNM; arc=none smtp.client-ip=66.163.189.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ULCeWBNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654151; bh=w8HPVukpPSLrmoVZPf8UU2BOkgF3+8NnKj9RcySYLaQ=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=ULCeWBNMK2gW2nELpdIBcG3Gyy+1/hGyT2H2tabY5QzK1ss7i0E/JTL86UY16X1WqDUEqZ/rufqVArqp6AKIRNc81ur9nnahpz4I4jnzy6oS/FQpg/gQvY7zwAZ8oi7OPuUG5RMa1rw0RKl+1Fqxh/vwm7Rgsi9pCjaNTy87W0nVinm72hcgTmRbhLLWjJu94AEpiLktIaY1+8sLfp8J7iUcUd5roLOj3VKXRMxGYn8eRVxLi5XYP6dDByxVEF8uBdNO05FcjtRPc1FtTcLN+PmHObTMQ8q7r8g7W+qZnp6SZ0abFwQb4pF9F0NIIa5MQ878L/R1oOH/yPxJJOfEkw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654151; bh=hW+nbGPFSyyfWCccLgi6XG7JZTa9p+76I6zOkrAN453=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=uGz07Df7tq/srOK36STwbhQ9yA7a+2FD81slAalWhoHhpMhB1F3GDDhKmc6UH6/mi0M6zi9HeBVpW0lYrgwrc+woj2Zrxt5KuWUu9ZoX2l0q9aK/yOVNQxy6TIb2OQdqLcmPg6q036bKGFKzhVUyWG2zXnmroVDPdIeY0/58XZVGgqxRvvwMS1lCtvV0o2Alm6jolSpbdpcgcu6kDVwcmQ1BG6UQCE1Zjwhv+3D9PFzUFFiOhkR5mjqOsgxudBIklr82arwBW+O2Njh/IomhMMlmMeJLWMszpK/LilSn8Sa2VS6v5/kZ6n8INRkrK0ah7EHbSkuOj68XSZBJaMaGvw==
X-YMail-OSG: XxAlhG0VM1n0h_axCYQM29b0pppQr2ScqpOinRo5fSyY1QBG52QM65snF_.cJgz
 PRBvi8cHw0BW.tQhNEa6hGmFdKEuii55j2qCkNWz3_6yqBMc9SExQkYmiqKTpmDGAqCvrDHJ2TVn
 .QLzYrV.9u0YrMi4FzRCoe0ZZutkAAVEU9s1zfloOqqdZpbWJ9U3rFvxaLJOHO_1o6Opoas1XmKr
 rSc9J7flQWHzcrBoUzMEtS9cYusxWxpoGIqqVmrdWKEMSr1pw6Y3jc7lRp8XR9DWcee89WfRTKHV
 PVrlJ_KVFw5CittDaGTsN7d3RRsbKfxKdcRiIsFpAy_k6ZJa8m94xyq85uHYp03KuCe2yS2UXPsY
 JrNlUcUranKfgXS5uFU8_hdjUjmDHXwzOiR0NBPdVFHS05i4vBKO1wAMfNMRSBFiSRaX0WWErh6v
 7zoSgwnS_Cm.6RLz0TeAK4GOMUjtPwn559A27JTs6IU19D7_1jvfuSQeeZGMsoSyrPoiuzsQXc_V
 JG1Qmv.A2.Fs8KgQm3_xV2mhYuI0YqI2WAuiIKcYujbwmPGS2Cim2Epscpeoo9Cht.xnf9AIAg7Y
 XZqiSYXPnJRqSFcxhMzIQhBe7ozPdiV3AWlLHe.XtN7ZIknbKAoVEd0BGZcB85Sl9.ZwKop_ZkCm
 wM9aOMZdeXJd6eQXHEASCpUiuTMoxVNMcj5oqCyQ84eIYTZkvcmtYpEnUP1Wn71OqFnvdFRlz6A.
 QEkqJ5vrMvVQIbqWBvaYEnrEKzkelZy69Ao7s3DYXH.lTXswXF8cyT4fo9.Ddpb4MPhjyHkH8v2D
 C3lvDakxb3K7ZcYVX.OrI6qLjA95RDIjTozha3HTXEE2cGfXwSryOy.8u3m2B5kC3SWmbLP3SfoH
 xNSsDO_Leo9wwMORdSzf_R3d1HAh9iV5vUilVXNV86s3GGrqnsrTNLPwGqzxS.qwflIoNeWIBvzN
 EzKk3cT0jzJSMRDVL4YTrHNQmIcUm0kPf4x6oSlN0DGVhO5uRETnZiJYOYI3f9YEVJNLoMNpN3V9
 tdUBRsjCG4s8aVawTJG72C1n45Xna8S9nCY788XobgbOI2BOPIrLbdjg.QnGODjuhAXBGWSJUCP2
 Fcdh_N_DSdcTr4z0FbZ7Nm3.gUt3XhfmV6ud88b8iL7sxJKX8bII5SLPcRf03CXs0qLxilsLDCQ8
 I2uTAQsCoC1DcRlNWQuWHjckLXU1PbBdMK43kW.1n.AZR7BcOGbngZqDcXBUW7.C6vJstcTNptkJ
 Ka_9Ea0_mg1wRP6MUMNMIdDw87couc.voEz87nMCFxkDFU1JR_b8JNbKnZf.ifLBQMFNEKsHV9bR
 iN6iGjg6NBhvfF5wfKIdOP_jmCpbK_DNYW8MvwL46evL2zLD.uQPLfkBkbfQYglHbMmGW36hNKs.
 UgNunm5o_ywNlOjnUAybfLg0udjGo8ygxcNqwQCq7zW8kJAi7WbO4.1CmgZ72Z52_XD8GSV1xyXz
 3Sohz6p3uVWcyiBqQUXshrqWPhtDv79XpcHio5QLWdKnXCGWPRI7W0V73c9KyRIx3NrwIueYRWbQ
 _HZ18FXAncL0sA_I_mjJW.5LOONqNYQ9rXGYg_p_jrB4mGvdSg_oR5Qx.mWXiR8ch8MXi4eaMM68
 e9XjBNEqbE4uvJRCcQdf7TDYp_UKMOXFnxpwCpLk1lfE.epm5bOWXL2lTiCzn3NsP.BOJ1h7xt7_
 LmaaYhJCrChTehfjDZVQ1XLej.HrwSd8_WMAD87x3SaK2s6qVNeYe73Xwp4bfuewtE_FaJahip8z
 1vvFCcvph2wRykMzTaBjlC7JcqqGBo2jHcutG4zvNUkTiKg5JCuQuHXLU3Fvx.uH.i3.UhymxkuP
 AzfGAQpyXsVEdrtVRotvLH8ATEpDctgPUv.HKtsOHmvASvYgxvNfthCd2yAkK4pZsWrs4nZC2KFy
 EyAGgzvT7fpwFUInhkcs0xKij9x4tiM7SCxmB0_2wXg._fcug1bX0gY.KavEvZxQ2CfpMFS4REjQ
 C4mxq5gJZ4d1VAQB7ZuTq4SY_CXVdA4VUTd2zwSSFTruTJfHrfAWgZNLjLRpb5nF9cJZTdRnlODg
 MhHVuM._d3LUpi89Tw8ZLz9ptlmytvCZ2xKFlcD..Tb0vlJ0RqB1BAZHylPzGOZhTGL6UIh2QpN3
 HK9oPzbmhCuUKMcthFVIYFQGiBgMpK670UcTUc.EhYZXgfFSont4Yb1.vgXKWYr48HkRN7UR43In
 QeBBICgxOM4K9pSvRVPRF8n03gYQvfxwpxxDPeHVHViJiCaTxDmziuQGj1rYP3JAIv64i6iAQeFQ
 2fds5sJTnG4Pgin0t7BsbHrKEMLiV
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: c6b368e2-214f-46e0-83cf-9261145f17e6
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:49:11 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:09 +0000 (UTC)
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
Subject: [PATCH 1/7] net, smack: Create a function to set secmarks
Date: Thu, 13 Aug 2026 13:48:48 -0700
Message-ID: <20260813204854.19211-2-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813204854.19211-1-casey@schaufler-ca.com>
References: <20260813204854.19211-1-casey@schaufler-ca.com>
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
 include/linux/lsm_secxa.h        | 22 ++++++++++++++++++++++
 net/netfilter/nft_meta.c         |  5 +++--
 net/netfilter/xt_CONNSECMARK.c   |  3 ++-
 net/netfilter/xt_SECMARK.c       |  3 ++-
 security/smack/smack_netfilter.c |  3 ++-
 5 files changed, 31 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/lsm_secxa.h

diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
new file mode 100644
index 000000000000..f4c732d26680
--- /dev/null
+++ b/include/linux/lsm_secxa.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2026 Casey Schaufler <casey@schaufler-ca.com>
+ */
+
+#ifndef __LINUX_LSM_SECXA_H
+#define __LINUX_LSM_SECXA_H
+
+#ifdef CONFIG_SECURITY
+
+#include <linux/security.h>
+#include <linux/skbuff.h>
+
+static inline void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
+{
+	skb->secmark = secxa;
+}
+
+#endif /* CONFIG_SECURITY */
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

