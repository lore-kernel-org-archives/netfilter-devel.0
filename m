Received: from sonic307-15.consmr.mail.ne1.yahoo.com (sonic307-15.consmr.mail.ne1.yahoo.com [66.163.190.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E01835C1B1
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654773; cv=none; b=Nvratneo4UT5c9liY/O/RYzh7cFTijPE8aqQ5eZg/+5bTKcb4WO6Th0CClkSdZbwOs/Jb+ziOmMwjS9XdREwf8F8uPsUME0zJx/9Iv4wTDxi6OS/YX3yIP99PXjAOeSdYPbMLw8caSwMteoln39/i+Vi716hcUOiNQxRq2gWBcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654773; c=relaxed/simple;
	bh=ucSHUE7F2He/v65mfJnm8qKl06ZZN6jMNIuyCzgKkmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCgOz7klxtq6QdESj8Da5URsVfM2QS3HAaVnKgFLxiRzyMnA4tfHjPVKJJx92KrXHjWajxv2dsT43FzEGNoK9RrLZc1upsz85sX6LQRvhUaVdQFOdxsMA2VhXuwQ77cJiqLXO/oaRgHw8rKe4ivwKyReeujFOKrYEt1sRR/YQ/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=HgV4gZlO; arc=none smtp.client-ip=66.163.190.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="HgV4gZlO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654769; bh=sDHCxHvBj3bCkYweuZ9BxvPJbXdZ56Ci0vAjxYPJVdU=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=HgV4gZlOWgLCNfYCGn+u99v5CkZfJ5st1UYy/qdQ287zxF4e4z5FQMtit2K1a+seHN1IhCElMeWQnjZ11B4nc8Ru+p0MRCAQmVpwbDmIFNUZshT9xZe0AabHkV2t1VZKtMZ+Y0YYiYjOR4coTt5qF1BvcbqCAzAjglCLDsyj5ZsHg9NbousV1wHrlKCzgLWk2Apsc/f6Zu4SXc2osyJNSD7ob/sqzSK3+0bcPXfPWoJFWqyh5q1ZPaV1xtcsN4kM87ju/BD4owmzf8H0/fnq4tfO3E9rWmMk+H+4b8bqSNxemy3pfE30BXiHhVRISZPu2gPGSJhGN233verqQaekRQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654769; bh=HIYDMZxQccBKbir7Ml16MJ7ZjCHc2OPrsUHb1Jik0qi=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=kVY7eSgIkB41BueNylZx9d3PuXAqkEDfZReQiZD5zMka0AxYAFP0XOu6bPc1GPidSTndVLLvzd6sWQ1j46ienq/fvZ7eFmXMLbrdasBVwekxYc6KSwOY7KjxAWPM3Kz/mIQNBPyXKG28IBnncAyt+GSBa0Lo7lLX3QCFSVQKGIS6C9r5bU6N68n4C+/n0Y9SwwZ8s7awVdE5ptzqlHdm/lUU8qYnxq4lxhHP8akEY7lref1OOcmUZPris6bVQQUeKxofSLCF0XBtQuwSRyWIM6/kpvWxrkbKMJIb6akCCNtqYwvrqgJfUF7Rs6fEcfFpgq7Q77+3M6+A7nfPlexTeg==
X-YMail-OSG: aJLRldoVM1kVIP5pT1W70jK1xP_Mg3FHL8EYG35rT10I6P7CiytQSdnBZJsRjEx
 YDPCiJLuDxPmmay_zgjaoj6CcDPN5neK4PcSVeSx53omHah21lGwBgFcVA2zmR_F6b6KsJMcfxoh
 pIOiACBCy0VqN7SQQWEDmMbN6yMbshtCDG_d50Ic0E4twllkv5NnuBvOTvde545K6H_T9DeGR8Wh
 HTiSPREM4HUOUitn_lyzxSoG6ZqwiGiDj4Fzfdl_E18Oz8w1eHCQKyrpUJPBPKnrgIhga74auMkc
 NObpsNo5s8ZjW7XErsvUPTrjZXTiGmIQQt9Q9SdleCWfvqqihpQkavn5A1G8oeUCg6ZPi3eN5tg2
 X3m3_Uo0RUiIkup9scPzUYl2.bqhCOy8oA3R6z6tIM5mxEl_pNgZo7JrapTYuf.TVpOCKqcfXhO7
 PXgjjxbbIeMcEOupzXPJ5CFtaR4lJ3b8PgS.eMKHUqFe05IDkirbAHoUcXL1N9J3.2kgbrCvPc1S
 .zCaETh6rmRZyniMe3kckYhMQSGUKse2cfjuhV4PLSpr7XFlnozYRgfQxvDVKuCrDZGbGP.CCaEg
 C9kgC01rNg7UU5YHaswrKONDnP1T76Ywv8LCc_AerkO9FLVKlT31y_4XtsbT78xc7bQnFOm480SM
 NZQ21hAl9xlYmMpYyNs_y8NRApOx.Df26tMEhal9x0CdXNI1rOAmhbWY4eJ3aiQmQJs2ebr4Bb9M
 VRNo16uwVpbpOHrK_TPw_v11rFun7tPjgaeJHntxFU.lgF81GHnBnthVQP.k.2fBjJHcUS_RuyBt
 aWTxT19bPoGCrMGfmsC6juHWqln0TvvKLjSsYupNmy45KMzAU93HkIi9Dp5bf6Cm8cFymiEGVFIN
 v0FcNGVNqDbRGar3z1S2WAFs1VD5f6Gl0t2byVPzPriRtaT.MPNvubd9D0S3BEKozgKCN7N4aLdn
 7HDTN5bBs_ogfAHr3_wHwyra6xLSGgDz_gBkmtBSvQPA9xzF6fnshgdZgSIu.9yqBqH6tYWcpwsI
 G0MHAo2f3qf3oZDzWww.iFBDFQgXfrhqwdefrBgrQKdUBbpv4qjSOLmHf_h3NOSBertujA2OkK5h
 KCbiyrqMjzFYzoOVd3LN5gVncxrGSmNo_ds_Q1NqY9f1xUGuYwDTqGjD.nm4b2tZ84tbw0ZKL4GI
 cEyyg6biWTdhJuOqBUFOckUONhpqrAzyWKVHkZrUEtrR.jzGAz9LUY0BZueT3d..Wk5we_AJE_OJ
 WT.ATVNQMVpvLl4vnv4bB1Al3WL5FxGm16vgaCQA.CraSP_oNf4ta8EvGo9BfYNWz6ehERkWnFsv
 GnKZBbalcYBKZ.b0TjeJZqZ4r2OT4fB_AXtypdQmPw7jHdp2Hq54Lq1MLxh75W1lNtb6yns7JNXG
 oMrMn7.H.UN0iVqVMRgdROlQ4pyQT.UbJOu9RQE2K8FN5uNHW4zq8xeywCEuwPmHkU9ibLqcPktC
 MdOlpSEXhJzCxLNJquJtH5Oo6vseTdahTh0AVY7OTWxzrj30YqBMflCheeuyImQYZ9SO2qAJjIwA
 G7.feRZffedw7O0ymyhA0FLFEtT5Fw9V.G1dErS_HgjiddRfyWY9O3FYSZsWiCFNdqodVGPoqO9m
 1NaE1NX6xnIdvNtal8_ZA.XoIp.c2MYPtTFrY5GUJIl6BD7BLWP.cpKYjR2.6ke4TUzWGfw5EsVW
 VvBtKmHABNlLaDDidLs7qSzuVF.tvGpXk3n66_l3mjfbjSyEgApIir2va2z4LMS1b3DUpoQ0RyLI
 FkAdD6MMntKOMQiJD8GBPEA8tamFjf.JYsXki1h.LScQmOKxBX6PvZzGHb3kVlloEHMmkcxCZrU4
 P7Iky90f_oxpYgKHAKOog_mKf3E5h0lYR936t9IuPmmaN.INmjVx8Zc0xVR7Mo00keYwF8lnSgIx
 PgbdCK2spL5NfCZOYFP3O6NMtT0.P2dq8spOhTtjxcMfY2nveyFjLCtC3WexwJm8iPvoNC7gsur7
 xZOfYXP_JMGDyt4d36rEIAYEQpyHgxka8XqiqFHWeyUSETs09dBrjSHjU1KaWsz74NnhnPyOAlMG
 XuUh8eoDQpHVy8gFjukLwZ4imD5SISb3QnQ7AWlDP9LBoUGZ5VwF4DTXzwnxoC.A.PV9aJ4qlJYO
 cGvGp9QhoNkaosALlUD4DGbymgjBCruaz3Q7Hy2Y19gzDq_6TZV.g9Nl6FbRXfs1o5Ir7ZguMPGe
 VrM1Y54M03MNID2o2z5qJnAC40p_x_Lp7FopfkBXR_9Z4bbxsUU7KtINxc5u_Cte0mQjSsNvCitk
 V5jNKfw5WWyAQwkCWSflARK4dLA--
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 079dcd19-d024-439c-b9ca-4b87691621de
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:59:29 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:12 +0000 (UTC)
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
Subject: [PATCH 3/7] LSM: Two hooks for manipulating struct lsm_prop
Date: Thu, 13 Aug 2026 13:48:50 -0700
Message-ID: <20260813204854.19211-4-casey@schaufler-ca.com>
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

security_update_lsmprop() updates the property of the
specified LSM in the @dest structure with that in the @src.

security_secctx_to_lsmprop() sets the @prop field associated
with the LSM specified to the value of the passed security
context.

LSM specific implementations of these hooks to follow.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/lsm_hook_defs.h |  4 ++++
 include/linux/security.h      | 17 +++++++++++++++++
 security/security.c           | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..3666d821b8a1 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -305,7 +305,11 @@ LSM_HOOK(int, 0, ismaclabel, const char *name)
 LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, struct lsm_context *cp)
 LSM_HOOK(int, -EOPNOTSUPP, lsmprop_to_secctx, struct lsm_prop *prop,
 	 struct lsm_context *cp)
+LSM_HOOK(int, -EOPNOTSUPP, update_lsmprop, struct lsm_prop *dest,
+	 struct lsm_prop *src, int lsmid)
 LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *secid)
+LSM_HOOK(int, 0, secctx_to_lsmprop, const char *secdata, u32 seclen,
+	 struct lsm_prop *prop)
 LSM_HOOK(void, LSM_RET_VOID, release_secctx, struct lsm_context *cp)
 LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inode)
 LSM_HOOK(int, 0, inode_notifysecctx, struct inode *inode, void *ctx, u32 ctxlen)
diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..b209d681e79a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -576,6 +576,11 @@ int security_secid_to_secctx(u32 secid, struct lsm_context *cp);
 int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp,
 			       int lsmid);
 int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_lsmprop(const char *secdata, u32 seclen,
+			       struct lsm_prop *prop, int lsmid);
+
+int security_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			    int lsmid);
 void security_release_secctx(struct lsm_context *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1581,6 +1586,12 @@ static inline int security_lsmprop_to_secctx(struct lsm_prop *prop,
 	return -EOPNOTSUPP;
 }
 
+static inline int security_update_lsmprop(struct lsm_prop *dest,
+					  struct lsm_prop *src, int lsmid)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
 					   u32 *secid)
@@ -1588,6 +1599,12 @@ static inline int security_secctx_to_secid(const char *secdata,
 	return -EOPNOTSUPP;
 }
 
+static inline int security_secctx_to_lsmprop(const char *secdata, u32 seclen,
+					     struct lsm_prop *prop, int lsmid);
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void security_release_secctx(struct lsm_context *cp)
 {
 }
diff --git a/security/security.c b/security/security.c
index 71aea8fdf014..932a2eca28b3 100644
--- a/security/security.c
+++ b/security/security.c
@@ -3965,6 +3965,13 @@ int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp,
 }
 EXPORT_SYMBOL(security_lsmprop_to_secctx);
 
+int security_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			    int lsmid)
+{
+	return call_int_hook(update_lsmprop, dest, src, lsmid);
+}
+EXPORT_SYMBOL(security_update_lsmprop);
+
 /**
  * security_secctx_to_secid() - Convert a secctx to a secid
  * @secdata: secctx
@@ -3982,6 +3989,31 @@ int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 }
 EXPORT_SYMBOL(security_secctx_to_secid);
 
+/**
+ * security_secctx_to_lsmprop() - Convert a secctx to a lsmprop
+ * @secdata: secctx
+ * @seclen: length of secctx
+ * @prop: prop
+ * @lsmid: which LSM the context is appropriate to.
+ *
+ * Convert security context to an lsmprop.
+ *
+ * Return: Returns 0 on success, error on failure.
+ */
+int security_secctx_to_lsmprop(const char *secdata, u32 seclen,
+			       struct lsm_prop *prop, int lsmid)
+{
+	struct lsm_static_call *scall;
+
+	lsm_for_each_hook(scall, secctx_to_lsmprop) {
+		if (lsmid != LSM_ID_UNDEF && lsmid != scall->hl->lsmid->id)
+			continue;
+		return scall->hl->hook.secctx_to_lsmprop(secdata, seclen, prop);
+	}
+	return LSM_RET_DEFAULT(secctx_to_lsmprop);
+}
+EXPORT_SYMBOL(security_secctx_to_lsmprop);
+
 /**
  * security_release_secctx() - Free a secctx buffer
  * @cp: the security context
-- 
2.54.0

