Received: from sonic310-30.consmr.mail.ne1.yahoo.com (sonic310-30.consmr.mail.ne1.yahoo.com [66.163.186.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C5742FCCC
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654168; cv=none; b=Wud7ySAJrTj1aQkb+CaeMhd+hXDUR/Ei9kn2XUmX8H1zxeIqP4FuqQFg5F0SShC0VaqO1Zbhf+8QJ+NKosxO2mqyIGqnvw4uPuGWjjMT60F0X3+5FVIVZou6Md7ym04MHW21wMuSaEgXlg+4fFMXSzdrmc7xDEsNEuTJCQCWJFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654168; c=relaxed/simple;
	bh=72YhhNU6NWvPLl2DQfZr45uphCv8J0DRSZwFwwujUac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gae73HUA185Bw80OYfkNTm2k8ZhWvM2m/jeVc0ohJ9UekznxrT6dm0uuDXYqYymA705X02d+Lol9uab+3a9BU72vKu4qiZ4qYamGWzDyLHn/SNxFqIa1NxrJwizM/rOMZbQIfKEdo9DsDGnRI7muK1tIXQo4st+0PXd8shwu5RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=THx0I7te; arc=none smtp.client-ip=66.163.186.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="THx0I7te"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654165; bh=FRCocopSO5EfBEt+ygxtllafaFTCGOtGFBdAwiisUyU=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=THx0I7teNFzbrIqHaJkKIrnOhmnV27/qnEm8Mp6hC4PwZ535HBMVrlwKpt0q3d+ezoGnTUa9e//PJBqMZOqgBuK0Ef08Txq+ZNIjOLykmNeTXqPewpPSXpusM1nIbRfUO13irOgn6OpxLDVC0Agkxzsn0kmPTJrIMzAbjv+VZmxbabt+DZw0ROiAwwI9nOvipP6VLOrvApPPZv2qoGcIgPUFP1gag2IWEmYIXegqUXwnoibb3Lob6Ri7nmV/pFobD0qC1SibfF4gmtPUlkRePJllxHueUg/PvSRejUNeLyAi5AYfIBnvya47Zc4z4X3SFrYNOtrc9SZCLMlPxKFYdg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654165; bh=i577mnP/8KO+geTT2pGDgvbizXY/QJgNdeE6nW+QAjF=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=aD84lthkbmls705LZ9wv3d2x9gRxUHSkZ3Ow8T1j0LcuLsbp+1Ie7pJSwvsa/Wsob8I8uj89/bnvRPUX43O4Pt5F6b32AvCROEHo5DYpcuCkEj+v++rqb09a/oS3eO2Qof+LxK1awpA8CP37yI8OpFeh01XdCLS98RxblM6XSk1B0k9edC2ffniOkeIXf4+4JIzaFpHhXejgcP7C1BxbFvnFZJ0oG3hyyhDXMw+VmXhT8h8LSB1GsGPPtXpqi+4ZZ5ET4JCKRm/ErIc3bIDmCrXWlYlyJKzPJetbND3v9DkKPzDOtC4bZrvnbAZWc5U5CePpkEkcDp8z357EY91gpQ==
X-YMail-OSG: FVTJgFgVM1mVr_LeJk8uwxbYUs3Pe0JyVAa.zkfepHtlJxctuMQnG.j_8PPk0AY
 _yN9z7B4ZbdXcsBeEa7mjRn2RtaO2CmhkoszHI7XSoT1tVE_usFManAcFfvLLnIwS2BwMkJBSnlT
 B.5Ozu60kjjA6Bx304AKDmwN0YFFm_h4yAMARN0N4mk7Efr4hvrWNPBJoxWTKo78iY_UK5KwlWd7
 4vPInDW8sKlS1cH6xRf9cMsHKPlWuudSd9rTfptBdGx8ZYsnCJK8v40.L9DfwKxNu_EaCWwaOyTz
 1K0kXP_ZpWgvJfeC_U8v_l2gq5uTrzGgWO4NzFoUWxreBwhHbciVUuHdVbKFEzpt5dV6pDRLolG6
 vtZY90nAbN3f2KS9LHxf.oWTMXua29Vn1Ctqrx.EocucA23bZ5pQFVfinhI2zmdeeb7Lc2fyF.01
 A0Mqys6ZbFT6Kr_jC1GmhAOffqxEKyY.8ZZHDPbZecdr_qG65waysQfCCB_KsinUepm9_prHNI8R
 6acVXUI4giwNXPhdBXT_Cad8ss1YycvzH0AQ.tFkpeFxloi.FvDiTnskGEBrxDq9RLJSFqhLW9SW
 r7LRi0gCCVxX.3h.w8hrO19e1lsKh1ZIkHYr7Y9sTdazrhJK.ai2RQkfzdAW3u16cVmfV6f_Lthy
 VbdEK0KhxyZozwhM1BZUdPxi7BVf5ZJHUm7I3ZDCRL51WS6d3.0coPWifuFn.zQmDSxLUGt7yME0
 S74OiSSDkC4woV7OWdjiUmC0uMJA_c1Y58JLq2lKp4g6bu7Vs5mn1Hesw8iq.61wsjMPBPRP0p33
 gzwNH4oCvOuUYYtQVdhc0pHJTJkPsLmyPqiZZ2hSVr_EQYUVl2nn9tYDwfeHlvNFN_NzQDHOxHSj
 2OJ3Pz5IdUuHpK5wWDjm9ZsVj_MX55CXEZZasYton.lfzkag8E3LySk037PJo2aoyUhNShWYbD1u
 iYbjXbzaNmv9gbxe0HJDeqykDCVigcE3wt8iuL7WiDYCw96RPdqPamudFPfyk04VZ.Tz638cYwBU
 JzuYZryH0OO_qQxPdgJS6B9zbyG4sxDG.qdNu3sCrWBXrjUBsJU8EoLvVJhOBBxkZjtCHXauCK7E
 Augs1eCqGFGYz9JTM74Bycf67pKrWgY4o51PtU0067igS4DMuwCi2yStJ5E0CWD_zHGKHsauO32t
 zoexSl_mTjZV.DdjYDzU6PtyOmwCqYhofqdXiE45E9B9JGPvqDaupj5PvxJsQ7DwEJLbDHLUlKzg
 4pPT5ovSEY9otAEe6OPZRt8lzt3y8MEz1J1Gx4vGz5Gbq7JEWlCLVjbjFmh6GYwfuF4PBExjaOaH
 DB11Mf4G0qXlVC2f3dd5foomJ9CgmcG0ReF2vALcfuNO8.__40JvCLoPW1asbTby8uVOCjJ5xWpj
 MEVSaxYltIUDJPwYDCsOZrkhclSVVH7i52nYgg9Jr6FDmonkxr7AC1_Yv3iL8sauW7NQuSzNYKh3
 QHrgA7L49gpibxiVxcDV_1PPceVqX_xzoc.eBSKXxLyj0YXYaE9UsUUNZFoPE93OGWez7HlV7HVI
 faYkArRt51ZcyHJryuc3FM7KEHvaobjlLhaBTv6RKCsi2_.eP7CsleAqcowWUgeIa2iheS3smYbZ
 B9dLiC4JEKmXPxBfaH4CyuqwvLy8zTcW_DZTRHiSII92Q9nJlapjWvHdU2pm9r_Dg2gIbACxykez
 ETbXdY8EIcEtqDZUnDQ_bjPC6URiCEpaHDML7CS2s9bhvWS.jIxRC9AhfNqm6aD2uSiYhakEi.UT
 E81LxfjCcoQAg79PRG7tnEnmrroBspzamb6YvZDTK4feG_8ZImTS2pR_g90g2OCGWunaC5_1_TPD
 02GNBkf6tj8FTU5aPxD6L8EM7ZHjVLHL6Hp3GCBGuwHTrmJFRLufVdsGj6srk_9TJNOJmpMZzvCu
 y5qONu6IvnHTsoKRrd.jyS6uEx358_Rp88FDLG0qUroYpbOqBgD.IoRxkrFTy3WEt3Htc6mHFHpW
 5oDQRwREaG7Wn_63iwHGX4zGtQ0dK8k1rlKNu.wyPazNQayN9tAhl9N9qhm8zn66cwRmM3BBN.Zw
 TDyopT4gWknXlN37Iv8eRogaCwrD4oDglQijVw6G_VyERQDTjLAoBmUgcKiCxmC74Y_KJWelvpLC
 4NDi1a3Jdr6BuKqMB6mER_8qm2HoLm009OyQGQi3Agpdhgv9Q9KupJAefVBS.1UIhDXvt.xUfWbT
 STsXGaIC3Q65pbKEJCPw0cmbsda43lwZ_vqxAykL6zZERGjcIIbVhrAHUa7FWZZ6Ij0N_qA428UL
 Y_QfEP59c.DItcVsknSykqpDBXU2xJeExDQ--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 7eafed83-78ac-4e4d-b4b6-05717535b423
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:49:25 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:19 +0000 (UTC)
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
Subject: [PATCH 7/7] net, lsm: Change skb secmarks to x-array indexes
Date: Thu, 13 Aug 2026 13:48:54 -0700
Message-ID: <20260813204854.19211-8-casey@schaufler-ca.com>
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
 include/linux/security.h         |  4 +-
 net/netfilter/nfnetlink_queue.c  | 12 +++++-
 net/netfilter/nft_meta.c         | 11 +++--
 net/netfilter/xt_SECMARK.c       | 12 ++++--
 security/apparmor/net.c          |  8 +++-
 security/lsm_secxa.c             | 18 ++++++--
 security/security.c              |  6 +--
 security/selinux/hooks.c         | 71 +++++++++++++++++++++++++++-----
 security/smack/smack_lsm.c       | 10 ++++-
 security/smack/smack_netfilter.c |  8 ++--
 11 files changed, 127 insertions(+), 35 deletions(-)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 3666d821b8a1..7ba4547daded 100644
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
diff --git a/include/linux/security.h b/include/linux/security.h
index b209d681e79a..844fbef4a6a8 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1716,7 +1716,7 @@ void security_inet_csk_clone(struct sock *newsk,
 			const struct request_sock *req);
 void security_inet_conn_established(struct sock *sk,
 			struct sk_buff *skb);
-int security_secmark_relabel_packet(u32 secid);
+int security_secmark_relabel_packet(struct lsm_prop *prop);
 void security_secmark_refcount_inc(void);
 void security_secmark_refcount_dec(void);
 int security_tun_dev_alloc_security(void **security);
@@ -1899,7 +1899,7 @@ static inline void security_inet_conn_established(struct sock *sk,
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
index bd0f7a0931f4..24535c45dab3 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -927,17 +927,20 @@ static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
 
 static int nft_secmark_compute_secid(struct nft_secmark *priv)
 {
+	struct lsm_prop tmp_prop;
 	u32 tmp_secid = 0;
 	int err;
 
-	err = security_secctx_to_secid(priv->ctx, strlen(priv->ctx), &tmp_secid);
+	err = security_secctx_to_lsmprop(priv->ctx, strlen(priv->ctx),
+					 &tmp_prop, LSM_ID_UNDEF);
 	if (err)
 		return err;
 
-	if (!tmp_secid)
-		return -ENOENT;
+	tmp_secid = secxa_from_lsmprop(&tmp_prop);
+	if (tmp_secid < 0)
+		return tmp_secid;
 
-	err = security_secmark_relabel_packet(tmp_secid);
+	err = security_secmark_relabel_packet(&tmp_prop);
 	if (err)
 		return err;
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index ea67aa92ddc2..5a7b83c67430 100644
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
@@ -57,18 +59,20 @@ static int checkentry_lsm(struct xt_secmark_target_info_v1 *info)
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
 
+	info->secid = secxa_from_lsmprop(&prop);
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
index 5b67d8218fd2..2015dab01bdf 100644
--- a/security/lsm_secxa.c
+++ b/security/lsm_secxa.c
@@ -71,8 +71,6 @@ int secxa_from_lsmprop(struct lsm_prop *prop)
 	int rc;
 
 	xa_for_each(&secxa_xa, il, lp) {
-		if (!memcmp(prop, lp, sizeof(*prop)))
-			pr_info("%s found at index %lu\n", __func__, il);
 		if (!memcmp(prop, lp, sizeof(*prop)))
 			return il;
 	}
@@ -101,7 +99,21 @@ EXPORT_SYMBOL(secxa_from_lsmprop);
  */
 void secxa_set_secmark(struct sk_buff *skb, u32 secxa)
 {
-	if (!skb->secmark)
+	struct lsm_prop *olp;
+	struct lsm_prop *nlp;
+	struct lsm_prop prop;
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
+	skb->secmark = secxa_from_lsmprop(&prop);
 }
 EXPORT_SYMBOL(secxa_set_secmark);
diff --git a/security/security.c b/security/security.c
index 932a2eca28b3..059cf0a97d2c 100644
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
index c05c05e71078..55d7679f3403 100644
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
index 8e3ab61dfdd9..38bd97c89179 100644
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
index b363c42f252e..5270b55eaacf 100644
--- a/security/smack/smack_netfilter.c
+++ b/security/smack/smack_netfilter.c
@@ -24,13 +24,15 @@ static unsigned int smack_ip_output(void *priv,
 				    const struct nf_hook_state *state)
 {
 	struct sock *sk = skb_to_full_sk(skb);
+	struct lsm_prop prop = { };
 	struct socket_smack *ssp;
-	struct smack_known *skp;
+	int secxa;
 
 	if (sk) {
 		ssp = smack_sock(sk);
-		skp = ssp->smk_out;
-		secxa_set_secmark(skb, skp->smk_secid);
+		prop.smack.skp = ssp->smk_out;
+		secxa = secxa_from_lsmprop(&prop);
+		secxa_set_secmark(skb, secxa);
 	}
 
 	return NF_ACCEPT;
-- 
2.54.0

