Received: from sonic314-27.consmr.mail.ne1.yahoo.com (sonic314-27.consmr.mail.ne1.yahoo.com [66.163.189.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF32362137
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 22:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788217126; cv=none; b=e7i+EDnEfdQzci4rScnBb1O5AiAz1npQTd50UQY/xgyhaJNJW2nNa+POClH5yekiv1UpCh+6Yp/FxL0zCNPUfukbgezolDpp76L8bWfDxW8USrslRsa0LWA+Qf/k17mWK6LV+nRTlGIGzFVmVvOTig+fL1Jzidc88MTlzOHgyKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788217126; c=relaxed/simple;
	bh=YePZ51dlYmZ/cucTyw+gosn8F7f35BMcwjmeoZtY7Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI9tiTPZhVQTJotEhq9oF0/7C4RYyFuvKKf9e3oVlxZ+nenzaeaCTC1ArvCHBXeDT+M4g37IeIvltOTDYoh71J6HSrhVxMXa81zUsMhkTwDlXKkEsLpPjzS+02OtuIS3z1m8P2Wr6iFnkFtHeJm3bBL8aev+1mmuEVVm8VyIwKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=AEejVQvj; arc=none smtp.client-ip=66.163.189.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="AEejVQvj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788217123; bh=yHlrmN78oxAAQbX+BTQB5IQgb1bzCbKp9XLNwOjJhUs=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=AEejVQvjKgJaHrF+RGj4FuVjCiBg/IliIhNnwg4pHnxA2ewMpQwFFrp3ACK03sEC+qNQcT26xLIrtf9GxV8/iCCydvUjY61BNgy1gP3JQ6dtU5F7kN+3gfqta6zOnO8G3ptyhLF5Nt2Z9/l3ND6QfgpWmA0OyEfChqWI70UzBVUpxNhGlGsmY3ObNO/PKbzFUtP9p3xoLWzBMrLDzDxcR9tE+4cttpokI/e+K02Qrrd+ke/gmOzerGuoA1EuCQeNN//zRs4g225P4ZitRhfx7Ri1MeT7aefS4RrO1rufgDLx9Dy8rkg91hroC17mWt5TPzs2YV6QlkqePrmTeiP8iA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788217123; bh=K6VdfbDWZ3P1fKdOY00nXWvGo5KvsEqbrBQyuknioHe=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=iKuEouyP0P2Zd34KiSSBIcOEDdVRN9tSHygxcxEUm0RCVsGXnFxDlSak+WJDFalzZW8moQjtWeuB5jEzeQChS4IubhvDkj8SmDvBzWZCD5fD0471VFqZagPGrTCjdWPiUoxGhcxc/QnCouhWQnsaP1iYbWzHOwwNUMSutn4fReHyW5rSEnyaE0+JXvkM3ywfN1dQtbtRvpXJBFTmVOZa2GDppce6AG26cNZy+TNmA8sqWx8/9Jhlng4ECb6M3Mp2eVmAOnrNAXL9qBO/muQv9ryLa3TFWWuLFZN4+9ITwe+bGPcuN5w8qXEqp9R/zWatIhW5AjganACg9szaUPPAUQ==
X-YMail-OSG: wkr1C6gVM1kY1wwk9eGxXd0VD2TzsIQPmYa4pt.AdCUxBSOgguKzbdXHZ1WZ0.6
 vcph3cb1d8AKu6soB4PLnJQ4MJv3uVnYDt6Svlqy06fi3sNEJg_o8qcTWlFgM.EXp7d6ewL_0epA
 .Zw5NkQ52bIQxFEA0Vff3X471.Zd0Orr7FlXMsGtv5sITzkTJ9RwUY1614vSkpN5Mmt0fliYcSdT
 CBwJlp7okGTvZ6cDonjA7K5nBQmYVXtfEHBgjH6VhKZVgImrk5HNHn6f.o8zdm_k49XLS5hW.dT0
 xz8LNfjpccV22pG66zCnEkfM7_4gNVhTNWJKPymPAzRIFCiWIeN8jJETvgVQIfcD0WqxUcMeOzTU
 BqtlqYBT_Ck_TQkuAPzCD7SDq9khQGq0hFOZki4Q3e7tNpm8o_uvhppAoJtRd3.CeVS62CGyDV_x
 MME_ASqUIqASRlH5JShfj00TfLXCHTrqDcThZ8xsxmr7fSfki7SL3lLCb1VYEqF_8M6vWZrE0XQr
 _qYunTAYErgJ2tULZxlZWo6qKrvqqGbKyKCTuTApROKJXZK.A_U9KWjgadVwSseICj2vUHNr3jfo
 stBpXGYT83zObGC8kLgyFOmbPdRMogjqMW_AN8tCMi53otsnyU5OUeaCnYPsjnCm7xQw6dSiFWUR
 Dpa6G9O9RsU1dDo9oVmg.CXAbO8npZBXVOL6LuOOtin5d2CBoIsEih31b3ox9fEM3vU8k7RKURrl
 pwIcbMGtcvq2Zg5jWlP6AViYV6_wIforel31rJaF7HXdKiJnXaWxxmhU3CNBZvpI4g8Fd6sRpEHA
 pr1k13FD.I13AAVtahKPlqFYez0.9HViFzfr1vCzKUlDG_cjSw0g1yZuO6RrUkJMPCmYz0MvU8Zx
 YqqOKLFp1NoW5M5XzXrywWMm.TIYHF0Js_nMJIQyZThvS4RKy7yjG8uprkM1as6kqKZQRU72Q6Tf
 m_0cYaJhvGgxojlen8d_wWbjeV8E0Ltuv4Dc.KoBhmDnYm3coqpcJsKYty0qck9XCS.v_mefS7Ib
 Hp.vAY6anLZAH7HBXxzBg5uEyUlLPW607zs6dkNdEbEixEpCioLVAVNxViYQozHBUvuuzY35lqW7
 UNh68PJNyOpmyu649LQDeTu7O_xaNC694gVWzgEJRtZM3hrUWVFpMZvMEBudP1HUziJlwC6nsS8D
 AozfVbCWUsU4uzU7ggpY6iQaDo7fDe7hAOC.wqZn_UwiftQYIqy.eo0Ed8UCD3kZAq_oTRlNi2cg
 L_46Cn.6UCGGkSviokUQVyufBy0Fau5A4LStfMqx1YUuvfw4Vuts5U_wYx4f.h7dSxTk3OxiQhCs
 j3zTsqahEK_FbQ_hWAvVV7_VAs34Oe6YsxsoszEZfhQvbjRlkJPSMU7lJkm5kS430xl2HcTSg3KC
 HUdBuBY2lCjJr92trnMXeLqwq3c76zes1e8D1tueQ9vq2qMvuEBa3gpmwdtoCLwoKr9IqyLlaeKe
 hor0VWx5WcZFJ_KoCST3bpeUhMfMD.Beiamm_ssbyAjzDwkiPgvDRiJ9CPy9r4hdPUq8JhaSvwun
 wowSwpq19M6Zim8FfFsbyazRPx7DCfO.8QpZTdr.oo7wEyTGs7diW3lqWGwKsPetHTIyIRfRa1yR
 G7G6wolWbiS58o4nOgYzoXt8MmKGyunFmzBCKbK2Er5mD5d3abPaPQvrsaF5OJAjSYraUNabNiYZ
 Jd..J3vlnbx3Xl_GoqqpEh_ra_7zYVUECqVYJUZUffVFr.hs7rWOJtuIwv7TRkOAmW8B8W5CpXak
 M3WGug32LVZthTwNzIhdzBHvpAHmZ08bfMRjXgWV0O6Z7V8w.Tv2HAsKSSvae_sm6razGAbgb6we
 7plnSTP6Aad3tpBTp7RDK1nXTq9Xj_D.tNrfF2zv8.MZPwu36sQytXyv7nL3nkUAvftOGpWL7ow5
 XANumG9_9eCV76I8gEBy2YlXqiAiTHFjQRlIUbGxo5HrmePAxxIM.L.QnzW7DYr5sr4D_JgiiND_
 fmHz5pWJzbyLCRbFcaggSBShAR5.cALhakzYQ_3Pvh9pXYYalyRS2A4n5QOm2iN8x6rgo.p88Rq_
 ZIDiHEyC0VUIoO4r4CUd4ZCcb7ugPV8LM9IF85Ek9u9jLxCLGzLEqwxsp17INiwQpf7KcLxOX1Xn
 n1Z_YehxdWSV_i3pV_UAAIA01dVv_C3tdD3umrWUvgAW3E64vQDq7fYzVWkQ0DJlbId9yaCAD308
 ZINFg4L4iI1CpJNZr92bsGiRHOXbRsxpEGgnMJi8EtzAxgrtgXO9Vo7OC3eRW2pBmoIaxA4gPH3I
 _hbiVM6P.YEntmJJwTexB4CZt
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 194f1d79-40cb-4ef1-811f-9399768b077c
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Mon, 31 Aug 2026 22:58:43 +0000
Received: by hermes--production-gq1-678d9dd684-vr75x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9afda7e456c775b6473ef75f34d3e2be;
          Mon, 31 Aug 2026 22:38:01 +0000 (UTC)
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
Date: Mon, 31 Aug 2026 15:37:42 -0700
Message-ID: <20260831223748.4304-2-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831223748.4304-1-casey@schaufler-ca.com>
References: <20260831223748.4304-1-casey@schaufler-ca.com>
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

