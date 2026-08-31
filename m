Received: from sonic314-27.consmr.mail.ne1.yahoo.com (sonic314-27.consmr.mail.ne1.yahoo.com [66.163.189.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54A33CB56D
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 22:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216510; cv=none; b=XrNJhBvkD5uv9qwfYamFg39BZxsNOrXw5X0gaAEWE+plmFmUuCqpup9LGT0b0lyGXQW8rpxcT7HtH5MeN7pP2Pn4YSTdWbs/wuLQjf3SagtJC9G7jQSa4UU5CCnHqt2tibKv5KwrUP9JKXE+ExnEQBEYClZ95yv7/LW1/eHFB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216510; c=relaxed/simple;
	bh=3Em4dnMVLjy93H+M96NVDsR9j5BHc56wCz13Hmgs1lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npMI/jjyzEeLi30wofF47GR7JBkhUEnB2DNV7eSSzFB0a56qd5zS/5HrVrzIGhVO6vdwLdFFBbMEgEFCMx8bDQUVTXIBmC46ovOwFQkb83jrG6yYP+Lz3mJl+LdC851ASCQz/1u3pGTgvRpIWyfSjvw0cVp91llrxTZmCgXtQac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=SZ47RQrP; arc=none smtp.client-ip=66.163.189.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="SZ47RQrP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216506; bh=Ks8XRiS+k4/39rYJBCyFDwLe73n5LVvsb3STBy6zqzM=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=SZ47RQrPAKpXRQWGe31JpvMVtJjfzbY1UryaB0jTyfQhDvBD5+WPgjmhLW5x9blt9r4MiSS9LXZI+OgBmY1runh541eYaD3X6vLowpKWATI1P7NPQ5C2UWBCcAexNdlYiHI7/qM0+FcPwnvKH7LyOIy6/A+W49KPme0NWdE2QFy2NOdDI6J/EdHgP5y70ioTt+g8Wsqax/no6Cvs9L91Fga+gN6i5AvW4PhH+cfTkhg5jlsOn02ZHY3Mybsu669jcquPe+ngy6R7JkXz2O5box04uWQPOwPMwCwKSgtB6mq4jbwQV2zFhIB52ZNeFjnSxtqleOx52ZLIhNcEMr2jgQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216506; bh=Nbq7s+MjHMUyqC6L6UmP1/2Ash85bEjj8qaeda3SwlP=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=n+ZbJJ4rpzw2YpmM8dj7KCy7f/w5vnvyUT/5jJ68V2jss5bla/Hcj+JiFsnT6UwiehYoNfppVmlXK0w8pNBl3UWrfQ5ftJHtbo7B2z3qp8SDktaX2uBExwulfWy2fB4nt5m/hszLFXccLieWH4CS0IRpCE4k2+rEs+r3j4tvcdNUI96S8+wuzBhW4eNgmSctEePjTl7Fjt8zbCj/sV6QsJvHy5g3O5UN69CDKYFlrxhEOZC0xsoLP4xLE5jij5iEg/2tQn+B75MAsAZolLhOSYVdagjRp/IHNs+ZG5dwjfoe9r4Rq3Fna0Keiq3TM9c+cpa2SzGHIMeP79HG17UZIA==
X-YMail-OSG: 4OypUFsVM1my6J1g3aQ1PGQIFwga6sJvSEh.d0VSMBf3gnZGmHoWCRUOMbDyznO
 D3ZzYxCkaN_SjoY8zC0Lp39tEp0gPhJhe7576tELTjhFcY.7UVPzKCeXqjl3BPqy9gTgwm.Y0J5Z
 kG5k0FkEXY3BYFoW7oxNnXsIppM4k.xPw_wPODpDxr1flD6Y8vpxIBopGXU8zYKr87UMIEpG_qrI
 EsWhnRJGwjBVUYVHsasvULtFC7mtVApEhGjeSS5EGBqD6K1qaUvEDLi1T.x6yf5WlCJlSjmW0S7J
 IYDEhjl7IbojDpF5ZicMg8m2vuN5sbnT_lzJmoJiLi9YVX_FD_.8GXVgcz0OniDiBYVSVDiXhVc4
 7_mpKkbK1dcRGg8Qlbi.v_nDN1Z4HxIUOf9MrX1CzSZgFGygvO0gVQwpVY.5xzJiRN_3kvbsibQ.
 1cRggTF5yphX5xLz3NOr0ugolbDOdwY5eah1zCa5_rp0enbpOhYgnfAfuvJO1AjEe2YmxglzmdJS
 ip4_jJ.2CTssn739l2.vqXGNic.jJwAWmMyO3W9r6.mdw8ZcbOeKG2rjB83PG5e6zm0QDlNQo_WK
 TMkM7is7YNCMFFL7jpfE0KB92UfzFk6bVobFuu99X7kQKPPQzFRgQg9eavvH4.c6YdSqfXu7nQIG
 KWP.v44Af5AOtb3F5w5Qs7AvC7wPgXHFEJOtpB7blqKn6QzVRrUoHhNcLNtE1ef42qHprcKMf5Wr
 ok.DO1FyQoqKgOPGB8ky4r7zYR9qdgyr9ywvo1kOKp_1E4cp4lQ5K7Th.5mypc9JKcW_MiN_o_4B
 kdqeNZWbZ705QqZPH4srP_CWUydrvuifoCLbD9NcaTLOGJusbgJNQ9J_awvApWf9z4lEemw8bKxh
 03eOH0yNfDzqz0d_BOJ8tfptm9ohnS8DCWiY_qdZS4Md30jRU5uSl6QQVWpsKiA1AUHaB8t15rwW
 y.kvUu8MJcy4CfwOzOTg5wYPcs4Bb.5oKDDIrQYKekePDq.o.AjBaFsiwSa0GpIJGyAcZyWI4io6
 f46TRTUEYf29dOcEaf31_5CdQcyP7G7aIFomhINsIM8aIGMRYSl.7FeKgUVITNj4UPoC8i29SxG9
 1Kn4JO0DLEqJGh8yCEiKtCJApPTvzot7teRCwjR5FkZ2NnWCtwfQlytKLC0CGufTGTCm9TmaZr.s
 1KmP.ccOLKsg7tNoX7WGHZFsXZOw6ZS8A2sf_UQPLYp95Q_isaBLLIlEf1LumWoGD29FCGEC1XwV
 7GvfeQIlaI28dGAYvVRikxIXOSywqhxNtL92dhfWX32mqbAcgoEzCEyJc5b4S_QLYysB3oRMO67y
 9IUqNCv.2jbo4M45.W4KFjFDWs22AK4SETKVVXhnb6D4S81hSuu3jEmTQIhca191xkOvLUGp2Xg8
 yM8o.XROtmEUpsQnUmbnk.rCyH6QyYc.4Zu7.74SykjzQ1NYk4btGD6UkKyK3OBtVf_BB5dJ9Nuj
 wpxeU1oWfQRMrX7jGQ7vt9_HxMttbdqTv6FMyF2KWEPBoev.BbHlod5TtZ_fSTMMjlkgYeW7VZWX
 5wjv7AwT0vGzVcsFZZsN7j0vkM9wUMueyEKZ9LqpyojoqmKQl1hfSPhL1aAdHY80u9HUQuFyBtaO
 qkWhB2Q3pa2IZ9k3wsWsuD61PGRpL5IyvsjWEnGH2OBsyG00xrfIQtoxKTvtwUW_pkiFGAz1LhvF
 You5DFMkT_BQdZF1rjPlYb0qx02ZzvCGJPn4qH5jk7WeQwYFLADdOnxyTaLXA._i_9g58cVmgwkE
 G1rvUZ9gkDyvYOxn75nE.tHTCm9QqwCya2teWwc1PnhnoySWOxM4HCHtscnPIGGTruqEa_jp5nLh
 w.fFs940jmQqpVi53vXZ69pj7yCsx7tezKeoTHGHZWFhgYWtZhut9HO37E0IsazbAoGVktz0XPdr
 csHb2P5qnFvRMwmfya8Hmr4N64SBgjbqrBhlqWqt4Ko3NyRLrzCfoirpC_V4s.Vu9x7sUZzsogGS
 cmFD1ejRK39brNT4OP7XUUbIEoisDQkY7e6nU8F.ZMGNCgZKtDd.lAzTR.98falR5w0n7w9I.iMA
 wgjLWfg6qfF1FHRacVwcxw4bBae.aaBCVL6g5x5QwACxY5TNhsIi_ULSxxvwVuXIvir34UytmPAH
 xjgvCpr7ToSw.kwJBanTE8WukC5Ia8ZmUS4uA6O_yEOozh5VtA_GlixTtg5pzAyCqhB51t34zxA2
 Jo1zIUav.raVdlQRDgWhwY04Yd_aeaKWxlBfYnvpF8I9kXVgJIvqzjf_lkclyIhHwhKLhabyOVp6
 sN62G5jWgI8NB.OlDd5IeWXLxF9uUOjw-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: d7c61874-2010-4091-8054-a888ea0b4e8b
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Mon, 31 Aug 2026 22:48:26 +0000
Received: by hermes--production-gq1-678d9dd684-vr75x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9afda7e456c775b6473ef75f34d3e2be;
          Mon, 31 Aug 2026 22:38:09 +0000 (UTC)
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
Date: Mon, 31 Aug 2026 15:37:48 -0700
Message-ID: <20260831223748.4304-8-casey@schaufler-ca.com>
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
 include/linux/lsm_secxa.h        |  4 +-
 include/linux/security.h         |  4 +-
 net/netfilter/nfnetlink_queue.c  | 12 +++++-
 net/netfilter/nft_meta.c         | 15 ++++---
 net/netfilter/xt_SECMARK.c       | 16 +++++--
 security/apparmor/net.c          |  8 +++-
 security/lsm_secxa.c             | 37 +++++++++++++----
 security/security.c              |  6 +--
 security/selinux/hooks.c         | 71 +++++++++++++++++++++++++++-----
 security/smack/smack_lsm.c       | 10 ++++-
 security/smack/smack_netfilter.c | 10 +++--
 12 files changed, 153 insertions(+), 42 deletions(-)

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
index 569c7f242b78..5be9d64e67e4 100644
--- a/include/linux/lsm_secxa.h
+++ b/include/linux/lsm_secxa.h
@@ -7,11 +7,13 @@
 #ifndef __LINUX_LSM_SECXA_H
 #define __LINUX_LSM_SECXA_H
 
+#include <linux/types.h>
+
 #ifdef CONFIG_SECURITY
 
 struct lsm_prop;
 
-int secxa_from_lsmprop(struct lsm_prop *prop, u32 *secxa);
+int secxa_from_lsmprop(struct lsm_prop *prop, u32 *secxa);
 int secxa_get_lsmprop(struct lsm_prop **pro, u32 secxa);
 
 #endif /* CONFIG_SECURITY */
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
index 50ce613e35c0..2991aee204df 100644
--- a/security/lsm_secxa.c
+++ b/security/lsm_secxa.c
@@ -99,7 +104,25 @@ EXPORT_SYMBOL(secxa_from_lsmprop);
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

