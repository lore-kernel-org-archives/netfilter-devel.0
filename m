Received: from sonic314-27.consmr.mail.ne1.yahoo.com (sonic314-27.consmr.mail.ne1.yahoo.com [66.163.189.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448633C5826
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386546; cv=none; b=GGVwAFCMWuDPcdzWt5jMyyg8Q/1X9x7JMXuIhQrFGYzxQnW1MlGPKL6+Cf1pOt4knyh3ef5R23GAXt192IGp4wAMo/2Z2zbApyNlUlDn0lFZcVBshxlBYRwl/7gmNA/uQZStNSMkBplnraqlF1kb7gOjuztT+ijz1MHadFqzZII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386546; c=relaxed/simple;
	bh=iRmlw8w8XT9vwtW4Z0Pldyb+T99fseiS6OsFqJB479c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfHSc7KPYx3laV6qvMiElYbKTaUOlBJSp8DYqKHpfh3mGIZUKtkTtQCNIIok97Yh8++Wl+wItgsXOu7moMfQhCANnvXtB5MHbFINzpuBl7SO7za/twn4QfuiAiNnCHIYB7PF9Wpv12bFFJHGa473xCSUxemqc2ul+/CYwEa3reI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=Yt8/2IOl; arc=none smtp.client-ip=66.163.189.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Yt8/2IOl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386538; bh=wT4UgdY5MDTOeJ6Ccerwu8nAX1sfYB5g8iAb35ivj50=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Yt8/2IOlBPZsl6JHe5Qi/HKk8zckskHhjJCs7yRJM9CHeCernEbgHg6MbO+dP1hKE225c+esqOZi1GCQ6UVzrZ6V7e8k2G1WfwYAaQYQggouevJEpSKsvVWFAhZSif4d25NgrzlQGq1DSwx9FbiQ0iAYr1s+ZM8u2B9NJV53f02XjG4anxAJiaZdcqszeQCL5c+U0DPMBxtsoR4K4V1O7AIVX1c1pwfdv77d9logO5RS6a89CGmthwD9+5Jp/CDihdF4zqY1fTyfbHaMjCCDkMSBrRDhxN7TOSkFgI3abzICAjIfggmUfoEJoCk40JCb6Gy344It26MM0bNaXXowrA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386538; bh=hkYtdEBctGjrFlwt72/XiIizrJD0L4XJ/fE/LlfrQsi=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ng46LZNmvcKqJSPsHX5kBTzch5/Y+MbAFxNP3AQHE3/5v7/OeBfw4dmImw3ANDpzwVYDFbju5HMeAXRqxnApk5z1ntDqL0yzEYQefT4Zw7+90NfeEfDpq8oF6J4daGEPeVrNmqWHmWDzZx320rRTC1rWMdH4mH1mVMMrqVjuWqK41J2bS3vCO2I5oq3/DiYYnHxAGjszJOxhfg5HSUIvdzPANtipc3U7S3jkhd4j16m0OmsqdBNx5/tbDEANPx4z9Tt31Ssp6ErDmmhMn4SmL0PQliVSz5Ll1Kk2Cj4WLYeXnI7k+NArHAbum4ATL+/hflrNaVlWjdOUtPNC/dbsmA==
X-YMail-OSG: O4Nco6gVM1maT00_1wYjfmWymB30XsOrgXFgFrIuOKqc1UQ.E.hT.1qy0ZoMwTg
 h5v_QXNn_r2k6uqmtlt6s_J2wrxsFVqTT59M1aCsG7Yq6Z1VMhxEU.jMTdBhwXWKb.drpDgD37EI
 G9eKQ6A_9gybPyc.X3SnVp_c.p7scaB08NINWkzNSXusDMRX4Nh3ON7Yadd_lRxoraRfs8frDVbI
 H5svNEqTmzirAZGWiXDveWI1FqscwyueKw0XPb7a3zdtCqwaBw2VShiBFfAQSkDFFmbZXJc24IYM
 eO3WiIz3DFTpkG_sWQC_ct6Nxw.By.iITtTxk4Vg4NPYhcor_hF5oHYzq9961NurioJu135Dkbq8
 vHmomaXygjf2JCiA36u0lZ9e7xgacXovRFaM345z7g2GCL.wTZ8hxNv7cUh00hQ9863dlRSHAaju
 yWpNExFdobbn5LbJ0adi6vKyYQInqsGaB70f4XymMgrf7byZjnjl53yOCVJQJu1FCKFMA80EJxoC
 iBq_N4OM4b7BR6.4DXn7963fI0a30QZWoW0nPb1KotBn8fO2keF6EGMbtdq_UOJu4gN7GG2mNLxK
 fZqtPqlzw5CgP18GP1BxfrGyJT4MhxIWATWt85lBqXTUfm8v66Dn.ltgMIKzC_B1PO7B1qF1eLRa
 5rpZN4mIhhZaVt_mhelmX9Af4QFs9AK2ThqU.IWiOjOJ3AdFh_w8_hn0D6msGfF_udfU4T9wGYAh
 MbjTWi2oXrDXHFV9iHLsdGAiHfMTEQXN7ou3wrW3z3HVcTWyxSIGBt83_f5nq8EBSBG_lJa4PV2A
 ylqTGvhgzWB6NkTV6FWCPZmsCMYOjMth2YeQXDptKjKWPuECvdb7Y05A_4KELfbgaNTPy88INeip
 pOdCpeLeidSFKafMxBby9GRVPpUXlX3Ns_qYuxxHYjhKc3Zec4UwgNLAiuGsZFd7haM4_U7efDKK
 9O76tvyRkieJtaxz5YC9usHYpfNfJr7Oau3ABI14JRNgY5ce9xvMGx3LLmut6n3Gh..7VrdQTOzZ
 YiLoGRlNybSm0Arx86NE8Ug6VOcKUhUPcsbH.FSsVsufkI8H38j43_K2ykT6EMFyRiCQcXAaIIvJ
 tsei5rTPnL1Z.Cv7E3cVcTd54iIM7BogT8QWNE0_EkMkca1ef7BKJ3qb0gx_hK0FzRPPkg_nhxrq
 caOSpHRohq9xo9eE124JDjBGjsdmQk5IcRt9A1sKD_rZEdUg0ZShvw9r1PNizykF_mkOGwBIN_75
 9TwaFALefH17LYXaqPhmARGiSZSq1RJJaopO6TnbcWtUzoFbKwUGRjGj54TWt1pce_HgXDSrhSuT
 B30x3BS7CZWDypUdQDLrVuf0NgjJ1QNSlN28nNCyrtdSko6C79F7ikRJF3h8aP.ZNRcXmbkG38MX
 cGkguvC6Ti2PkJ3In7iWcIxhOiEAH6t5Wl7lma3ALUE6PclV5J.UYTnh_VORxs3aLugjMQ2ik6Ic
 JjmLhBGW9WhHu7PIo9zx7DdBXIHGkr8FTGrfhjVYyaLxzzwnDgbQWwInKrXjon6SDkm97.Sw5A9.
 Z1gLBzI6tLNlMebxJBMdRVH28M2ClsVw1dn.HhFA1X7cTNGxwVhOoQM4B9bimMkalb1HznTMLiT3
 Zvv6hMgYIp_oBpjG1FmyanMNN1g3WRyf3pitZeSzD_QpEUqrC1TKydtjt32MwSC2507dDDsUuetU
 l3AS1XsNgLTVuCdAEowvlLvUdChFTUX5es3AYfmstJZWFBBfUV3pH4qFNrJA69VdGxDjxPq4qj2E
 pnOA2HY8IFogf_0F.1i6PfjJI.zyOpixWueDeBJEXKiRqmzmn7WO7ERmjcMcApPMAH1zK6VIOGiO
 kayJQzlXYuVI3eUrGLbSrkKiLsYyhK8haHSCChVq5sSzI8XmVQxomeKv9skXVupyaUaQ03SJEetb
 732z7SHRCPXvOo6SCeIk.BZSyFcIjl42FdznrZXyJNhWEj.Q87h967QLIGDYnSQ2i8NPpnEZ17yW
 0f6_2y40pzpfk_6.gDIszVfFT_LmLDOCHjAl9Eo6uB40vdKvM3P673O0drjp4wZkL1DoyacjkFEq
 1iQ1oCdBE04KKpIh7xPY_WUkgrednorNYdWYgFzP.vvgcjTbBWMGm6B7BUX5moeAqQtLQ97tKScX
 gU7cHKEFQiVso6.1SR883eAC.TEgfBd.OPdUC5KGN2LfHmiyif97iGAN2upvfyGeM9tosQoIHXgd
 Ti5ktqKJUe01Ei9ZAQJ2FvF9iS6u.GEw1Q4ZiYQZNkGE7fRm.3hSxQdu49F.YfbY9L4e4mN.7I8G
 CudvsMNqN4M_31I4xu5Zy.boVkF_eJdU-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 17f4100f-a91d-48d9-a8d3-6a75cf04a491
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:18 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:13 +0000 (UTC)
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
Subject: [PATCH v2 7/7] net, lsm: Change skb secmarks to x-array indexes
Date: Wed,  2 Sep 2026 15:01:50 -0700
Message-ID: <20260902220150.18586-8-casey@schaufler-ca.com>
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

Maintain a xarray of lsm_prop structures which represent the
LSM security information passed via skb->secmark. Pass the xarray
index of the appropriate lsm_prop (the secxa) instead of an LSM
specific secid. Allow multiple LSMs to specify their components
in xarray entries, or create new entries as necessary.

Change uses of security_secctx_to_secid() to security_secctx_to_lsmprop()
in the netfilter and iptables code. Change security_secmark_relabel_packet()
to accept an lsm_prop pointer rather than a secid. Change secxa_set_secmark()
to update and create new entries as necessary.

Update the SELinux, Smack and AppArmor hooks that use secmarks to
expect a secxa xarray index instead of a secid.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/lsm_hook_defs.h    |  2 +-
 include/linux/lsm_secxa.h        |  2 +
 include/linux/security.h         |  4 +-
 net/netfilter/nfnetlink_queue.c  | 12 +++++-
 net/netfilter/nft_meta.c         | 15 ++++---
 net/netfilter/xt_SECMARK.c       | 16 +++++--
 security/apparmor/net.c          |  8 +++-
 security/lsm_secxa.c             | 20 ++++++++-
 security/security.c              |  6 +--
 security/selinux/hooks.c         | 71 +++++++++++++++++++++++++++-----
 security/smack/smack_lsm.c       | 10 ++++-
 security/smack/smack_netfilter.c | 10 +++--
 12 files changed, 141 insertions(+), 35 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 679c40a8e127..8ecf07e0e3f0 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -371,7 +371,7 @@ LSM_HOOK(void, LSM_RET_VOID, inet_csk_clone, struct sock *newsk,
 	 const struct request_sock *req)
 LSM_HOOK(void, LSM_RET_VOID, inet_conn_established, struct sock *sk,
 	 struct sk_buff *skb)
-LSM_HOOK(int, 0, secmark_relabel_packet, u32 secid)
+LSM_HOOK(int, 0, secmark_relabel_packet, struct lsm_prop *prop)
 LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_inc, void)
 LSM_HOOK(void, LSM_RET_VOID, secmark_refcount_dec, void)
 LSM_HOOK(void, LSM_RET_VOID, req_classify_flow, const struct request_sock *req,
diff --git a/include/linux/lsm_secxa.h b/include/linux/lsm_secxa.h
index 84b06c093460..5be9d64e67e4 100644
--- a/include/linux/lsm_secxa.h
+++ b/include/linux/lsm_secxa.h
@@ -7,6 +7,8 @@
 #ifndef __LINUX_LSM_SECXA_H
 #define __LINUX_LSM_SECXA_H
 
+#include <linux/types.h>
+
 #ifdef CONFIG_SECURITY
 
 struct lsm_prop;
diff --git a/include/linux/security.h b/include/linux/security.h
index 19adc19eb9af..ffbd1708065f 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1715,7 +1715,7 @@ void security_inet_csk_clone(struct sock *newsk,
 			const struct request_sock *req);
 void security_inet_conn_established(struct sock *sk,
 			struct sk_buff *skb);
-int security_secmark_relabel_packet(u32 secid);
+int security_secmark_relabel_packet(struct lsm_prop *prop);
 void security_secmark_refcount_inc(void);
 void security_secmark_refcount_dec(void);
 int security_tun_dev_alloc_security(void **security);
@@ -1898,7 +1898,7 @@ static inline void security_inet_conn_established(struct sock *sk,
 {
 }
 
-static inline int security_secmark_relabel_packet(u32 secid)
+static inline int security_secmark_relabel_packet(struct lsm_prop *prop)
 {
 	return 0;
 }
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index b8aaf39cb4d8..ebab037edc6b 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -32,6 +32,7 @@
 #include <linux/cgroup-defs.h>
 #include <linux/rhashtable.h>
 #include <linux/jhash.h>
+#include <linux/lsm_secxa.h>
 #include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
@@ -606,8 +607,15 @@ static int nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsm_context *ctx)
 {
 	int seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
-	if (skb->secmark)
-		seclen = security_secid_to_secctx(skb->secmark, ctx);
+	struct lsm_prop *prop;
+	int rc;
+
+	if (skb->secmark) {
+		rc = secxa_get_lsmprop(&prop, skb->secmark);
+		if (rc)
+			return 0;
+		seclen = security_lsmprop_to_secctx(prop, ctx, LSM_ID_UNDEF);
+	}
 #endif
 	return seclen;
 }
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index bd0f7a0931f4..664191dfa4b2 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -927,21 +927,24 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
 static int nft_secmark_compute_secid(struct nft_secmark *priv)
 {
-	u32 tmp_secid = 0;
+	struct lsm_prop tmp_prop;
+	u32 secxa = 0;
 	int err;
 
-	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
+	err = security_secctx_to_lsmprop(priv->ctx, strlen(priv->ctx),
+					 &tmp_prop, LSM_ID_UNDEF);
 	if (err)
 		return err;
 
-	if (!tmp_secid)
-		return -ENOENT;
+	err = secxa_from_lsmprop(&tmp_prop, &secxa);
+	if (err)
+		return err;
 
-	err = security_secmark_relabel_packet(tmp_secid);
+	err = security_secmark_relabel_packet(&tmp_prop);
 	if (err)
 		return err;
 
-	priv->secid = tmp_secid;
+	priv->secid = secxa;
 	return 0;
 }
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index ea67aa92ddc2..05b023a7c576 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -43,13 +43,15 @@ secmark_tg(struct sk_buff *skb, const struct xt_secmark_target_info_v1 *info)
 
 static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 {
+	struct lsm_prop prop;
 	int err;
 
 	info->secctx[SECMARK_SECCTX_MAX - 1] = '\0';
 	info->secid = 0;
 
-	err = security_secctx_to_secid(info->secctx, strlen(info->secctx),
-				       &info->secid);
+	err = security_secctx_to_lsmprop(info->secctx, strlen(info->secctx),
+					 &prop, LSM_ID_UNDEF);
+
 	if (err) {
 		if (err == -EINVAL)
 			pr_info_ratelimited("invalid security context \'%s\'\n",
@@ -57,18 +59,24 @@ static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
 		return err;
 	}
 
-	if (!info->secid) {
+	if (!lsmprop_is_set(&prop)) {
 		pr_info_ratelimited("unable to map security context \'%s\'\n",
 				    info->secctx);
 		return -ENOENT;
 	}
 
-	err = security_secmark_relabel_packet(info->secid);
+	err = security_secmark_relabel_packet(&prop);
 	if (err) {
 		pr_info_ratelimited("unable to obtain relabeling permission\n");
 		return err;
 	}
 
+	err = secxa_from_lsmprop(&prop, &info->secid);
+	if (err) {
+		pr_info_ratelimited("unable to obtain secmark\n");
+		return err;
+	}
+
 	security_secmark_refcount_inc();
 	return 0;
 }
diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index cf590dd08540..e26e15c2d947 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -8,6 +8,7 @@
  * Copyright 2009-2017 Canonical Ltd.
  */
 
+#include <linux/lsm_secxa.h>
 #include "include/af_unix.h"
 #include "include/apparmor.h"
 #include "include/audit.h"
@@ -365,12 +366,17 @@ static int aa_secmark_perm(struct aa_profile *profile, u32 request, u32 secid,
 			   struct apparmor_audit_data *ad)
 {
 	int i, ret;
+	struct lsm_prop *prop;
 	struct aa_perms perms = { };
 	struct aa_ruleset *rules = profile->label.rules[0];
 
 	if (rules->secmark_count == 0)
 		return 0;
 
+	ret = secxa_get_lsmprop(&prop, secid);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < rules->secmark_count; i++) {
 		if (!rules->secmark[i].secid) {
 			ret = apparmor_secmark_init(&rules->secmark[i]);
@@ -378,7 +384,7 @@ static int aa_secmark_perm(struct aa_profile *profile, u32 request, u32 secid,
 				return ret;
 		}
 
-		if (rules->secmark[i].secid == secid ||
+		if (rules->secmark[i].secid == prop->apparmor.label->secid ||
 		    rules->secmark[i].secid == AA_SECID_WILDCARD) {
 			if (rules->secmark[i].deny)
 				perms.deny = ALL_PERMS_MASK;
diff --git a/security/lsm_secxa.c b/security/lsm_secxa.c
index ccbe78095d70..f0702ac5601d 100644
--- a/security/lsm_secxa.c
+++ b/security/lsm_secxa.c
@@ -103,7 +103,25 @@ EXPORT_SYMBOL(secxa_from_lsmprop);
  */
 void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
 {
-	if (!skb->secmark)
+	struct lsm_prop *olp;
+	struct lsm_prop *nlp;
+	struct lsm_prop prop;
+	u32 tsecxa;
+	int rc;
+
+	if (!skb->secmark) {
 		skb->secmark = secxa;
+		return;
+	}
+
+	olp = xa_load(&secxa_xa, skb->secmark);
+	nlp = xa_load(&secxa_xa, secxa);
+
+	prop = *olp;
+	security_update_lsmprop(&prop, nlp, LSM_ID_UNDEF);
+
+	rc = secxa_from_lsmprop(&prop, &tsecxa);
+	if (!rc)
+		skb->secmark = tsecxa;
 }
 EXPORT_SYMBOL(secxa_set_secmark);
diff --git a/security/security.c b/security/security.c
index 1dec0037370b..e80e7823ce14 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4646,15 +4646,15 @@ EXPORT_SYMBOL(security_inet_conn_established);
 
 /**
  * security_secmark_relabel_packet() - Check if setting a secmark is allowed
- * @secid: new secmark value
+ * @lsmprop: new secmark value
  *
  * Check if the process should be allowed to relabel packets to @secid.
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_secmark_relabel_packet(u32 secid)
+int security_secmark_relabel_packet(struct lsm_prop *prop)
 {
-	return call_int_hook(secmark_relabel_packet, secid);
+	return call_int_hook(secmark_relabel_packet, prop);
 }
 EXPORT_SYMBOL(security_secmark_relabel_packet);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 12614478b638..bf832eff0b92 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -94,6 +94,7 @@
 #include <linux/io_uring/cmd.h>
 #include <uapi/linux/lsm.h>
 #include <linux/memfd.h>
+#include <linux/lsm_secxa.h>
 
 #include "initcalls.h"
 #include "avc.h"
@@ -5414,7 +5415,16 @@ static int selinux_sock_rcv_skb_compat(struct sock *sk, struct sk_buff *skb,
 		return err;
 
 	if (selinux_secmark_enabled()) {
-		err = avc_has_perm(sk_sid, skb->secmark, SECCLASS_PACKET,
+		struct lsm_prop *prop;
+		u32 secmark = 0;
+
+		if (skb->secmark) {
+			err = secxa_get_lsmprop(&prop, skb->secmark);
+			if (!err)
+				secmark = prop->selinux.secid;
+		}
+
+		err = avc_has_perm(sk_sid, secmark, SECCLASS_PACKET,
 				   PACKET__RECV, &ad);
 		if (err)
 			return err;
@@ -5483,7 +5493,15 @@ static int selinux_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	}
 
 	if (secmark_active) {
-		err = avc_has_perm(sk_sid, skb->secmark, SECCLASS_PACKET,
+		struct lsm_prop *prop;
+		u32 secmark = 0;
+
+		if (skb->secmark) {
+			err = secxa_get_lsmprop(&prop, skb->secmark);
+			if (!err)
+				secmark = prop->selinux.secid;
+		}
+		err = avc_has_perm(sk_sid, secmark, SECCLASS_PACKET,
 				   PACKET__RECV, &ad);
 		if (err)
 			return err;
@@ -5885,10 +5903,10 @@ static void selinux_inet_conn_established(struct sock *sk, struct sk_buff *skb)
 	selinux_skb_peerlbl_sid(skb, family, &sksec->peer_sid);
 }
 
-static int selinux_secmark_relabel_packet(u32 sid)
+static int selinux_secmark_relabel_packet(struct lsm_prop *lsmprop)
 {
-	return avc_has_perm(current_sid(), sid, SECCLASS_PACKET, PACKET__RELABELTO,
-			    NULL);
+	return avc_has_perm(current_sid(), lsmprop->selinux.secid,
+			    SECCLASS_PACKET, PACKET__RELABELTO, NULL);
 }
 
 static void selinux_secmark_refcount_inc(void)
@@ -6016,10 +6034,21 @@ static unsigned int selinux_ip_forward(void *priv, struct sk_buff *skb,
 		}
 	}
 
-	if (secmark_active)
-		if (avc_has_perm(peer_sid, skb->secmark,
+	if (secmark_active) {
+		struct lsm_prop *prop;
+		u32 secmark = 0;
+		int err;
+
+		if (skb->secmark) {
+			err = secxa_get_lsmprop(&prop, skb->secmark);
+			if (!err)
+				secmark = prop->selinux.secid;
+		}
+
+		if (avc_has_perm(peer_sid, secmark,
 				 SECCLASS_PACKET, PACKET__FORWARD_IN, &ad))
 			return NF_DROP;
+	}
 
 	if (netlbl_enabled())
 		/* we do this in the FORWARD path and not the POST_ROUTING
@@ -6093,10 +6122,20 @@ static unsigned int selinux_ip_postroute_compat(struct sk_buff *skb,
 	if (selinux_parse_skb(skb, &ad, NULL, 0, &proto))
 		return NF_DROP;
 
-	if (selinux_secmark_enabled())
-		if (avc_has_perm(sksec->sid, skb->secmark,
+	if (selinux_secmark_enabled()) {
+		struct lsm_prop *prop;
+		u32 secmark = 0;
+		int err;
+
+		if (skb->secmark) {
+			err = secxa_get_lsmprop(&prop, skb->secmark);
+			if (!err)
+				secmark = prop->selinux.secid;
+		}
+		if (avc_has_perm(sksec->sid, secmark,
 				 SECCLASS_PACKET, PACKET__SEND, &ad))
 			return NF_DROP_ERR(-ECONNREFUSED);
+	}
 
 	if (selinux_xfrm_postroute_last(sksec->sid, skb, &ad, proto))
 		return NF_DROP_ERR(-ECONNREFUSED);
@@ -6215,10 +6254,20 @@ static unsigned int selinux_ip_postroute(void *priv,
 	if (selinux_parse_skb(skb, &ad, &addrp, 0, NULL))
 		return NF_DROP;
 
-	if (secmark_active)
-		if (avc_has_perm(peer_sid, skb->secmark,
+	if (secmark_active) {
+		struct lsm_prop *prop;
+		u32 secmark = 0;
+		int err;
+
+		if (skb->secmark) {
+			err = secxa_get_lsmprop(&prop, skb->secmark);
+			if (!err)
+				secmark = prop->selinux.secid;
+		}
+		if (avc_has_perm(peer_sid, secmark,
 				 SECCLASS_PACKET, secmark_perm, &ad))
 			return NF_DROP_ERR(-ECONNREFUSED);
+	}
 
 	if (peerlbl_active) {
 		u32 if_sid;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fcfadd5d9994..79140e6829a4 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -42,6 +42,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/watch_queue.h>
+#include <linux/lsm_secxa.h>
 #include <linux/io_uring/cmd.h>
 #include <uapi/linux/lsm.h>
 #include "smack.h"
@@ -4189,10 +4190,17 @@ static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr_in6 *sip)
 #ifdef CONFIG_NETWORK_SECMARK
 static struct smack_known *smack_from_skb(struct sk_buff *skb)
 {
+	struct lsm_prop *prop;
+	int rc;
+
 	if (skb == NULL || skb->secmark == 0)
 		return NULL;
 
-	return smack_from_secid(skb->secmark);
+	rc = secxa_get_lsmprop(&prop, skb->secmark);
+	if (prop)
+		return prop->smack.skp;
+
+	return NULL;
 }
 #else
 static inline struct smack_known *smack_from_skb(struct sk_buff *skb)
diff --git a/security/smack/smack_netfilter.c b/security/smack/smack_netfilter.c
index b363c42f252e..0378f74aa22b 100644
--- a/security/smack/smack_netfilter.c
+++ b/security/smack/smack_netfilter.c
@@ -24,13 +24,17 @@ static unsigned int smack_ip_output(void *priv,
 				    const struct nf_hook_state *state)
 {
 	struct sock *sk = skb_to_full_sk(skb);
+	struct lsm_prop prop = { };
 	struct socket_smack *ssp;
-	struct smack_known *skp;
+	u32 secxa;
+	int rc;
 
 	if (sk) {
 		ssp = smack_sock(sk);
-		skp = ssp->smk_out;
-		secxa_set_secmark(skb, skp->smk_secid);
+		prop.smack.skp = ssp->smk_out;
+		rc = secxa_from_lsmprop(&prop, &secxa);
+		if (!rc)
+			secxa_set_secmark(skb, secxa);
 	}
 
 	return NF_ACCEPT;
-- 
2.54.0

