Received: from sonic314-27.consmr.mail.ne1.yahoo.com (sonic314-27.consmr.mail.ne1.yahoo.com [66.163.189.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A357C3BCD0E
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 22:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216503; cv=none; b=SFzW37A3Y0YlxSW4wWpLmsRvCCaVmQuSk1C5RZwDujuuWDWMHM00pN2T3ZKrRhHYsVNO2y4FGr/VAvCnvt7eDZcPRSsbndKYTtDv6ciWO6Ms22RUjkSxpU5W5QGF0hfvNWVJBtOpjg57EF0o0OiUVJQBnsv7ySO40oJs+VIZV3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216503; c=relaxed/simple;
	bh=XVSjcaZyuUD2SrbqN9FUXg2GXtPt/4t566caTuPgIpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aelbU/igj/0+HsVIZDjSCi+oH1I6fvmnywzfraFWJ/9OTH5oqVv71x3P3bhRVV/4lUrs9j9G9kUMVdWG3SE/5LxO8zgghynEwvv61114XdJCKS5dGvhe/azsnC1g9Csybw+4xRo++JQhq93hmknnAPVxzIbRbrIWXRjfVd4c5Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=JG9c8kog; arc=none smtp.client-ip=66.163.189.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="JG9c8kog"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216501; bh=tLRp/oU1oiSOD4+KZUJnxFQDz8wkKZs/J7I1da4eUx0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=JG9c8kogUJT6zz5KKprXcCdcObTNQFdiKyN04nShXKcOIgXnfFjeVLe0JpZCREjPoRwPoqnHnBfugFVvfXqLaCt3dqg7zqDVlqf2K4Kw0tiI5BOak7GsqZiKIUlcNXrov+VKl/mNsx31Krxi5zEIw5y+4pjRSqDnoSZiMwj7NQq2d0kKizw5QMMDzSfTP1U8t3Kl/vkqPHJaKo6O9bYXkXv9aIng+9S5iZ1QOTFXt4zUDPZbwdnZk++akmMmQMLXPalVbuGTwfTiaMAITYgsgNhCxkhZVIEoSYwOM+PkMofbvwv/FRv92a8ewxPfSXnMAmwHuen5XCPnI/CkFDGAxg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216501; bh=SWMiwzxy1sTRKKpIyLbyqGvt6xVeZVUnpveeAr7Hqj2=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=liPR0nzGogFfBt39Uq25HA4KHX04QkINbKsRAVczcObCH+TACFXyA/g6BEEq1qQwpRUQtI4EPXCvMlj/SLEyK8o0udN2icZoIrWTS1DkYCYTlcHHCXxdrgmSubavWEH7puaTl2YatvY9knU7igCP9DWZzm3BF0vJZkV8WshkaJ2Yyn8nTTHEix/o7LRf57R7bDH9+EQ+jc4vgpT9eI3HRIBJwjXXdmvO9HEhCs9ilErbe4xJq7Koin6tjyo6qThOLmUCH5vQv/yX2yl1jZbAe/i4jajng8x1M3DdZPIHU/0hAO3WkbjcU2HrDbDBrL8/Rsxp1wI1Bt0wXVEPjwUTqg==
X-YMail-OSG: r4mSwyAVM1l0GdCNgnHvnP9wSKs0gd0UY9Ts5o6sEt3lJS3fIkPMmzhivF7eCfF
 dPGVSHMoNe3TfbSI2FKmQmNLv0VG5VC2_qnL1wBwuQl_tDgAmahK9xnc3TS9e9v6K5eS6ZCdt28k
 qTgebUj4zdl1zXsvepfLzTiRfqmTqC2vGjMgxxSpD73NMB7A7Avlal4dI0kOm7M9YYYierwaCuja
 8x0ma9qlpc7W_TxP757pL6uCRBIawnuobVKMALhxcIk968lwAXh9dbmhlngNqyDWF.nm1kSr6obW
 33TTdrL96mSFz04pWjFId_hPPlChBaL6fsCYzpYhleAZIEv9p91YqOwr_02C.XfqMGn65j_eFOxx
 iW0BIEA56pIQf2KfrqxYUkEfZ.I0cY9utIyTTFzLZoIFD80LKqBCNvusRX946eCMjx_Sg37XYZLH
 Dsts3qRNz2pJi9.Yhe1SYqrBvVdju0KQzdGZ7BIOmUaE8Cx2amy_FFPg17JjyTjbLgALxSgdouHY
 nVNn7ixIgR_26ziepY25k0ZAl2beCrun99TRfymhDEWvrAUJpf28lCXsqvP1ljXXp4Slh4_jQ7fs
 BxkN6l_y8yVmY9mI9bt.K5LPZj4mjFrPw1q0jYDn4Q1zlj74oQqBjNDRffK3TBY75WYH_ZNvBxG2
 vrAJtuR3ivYfDNASdExRhGyNYjc1JOuWZEhxxFrYeJvUjBu3heGAd.jcFVHwtrw_TDy26NkisrHd
 o4bZ07lOzQ6rhF527PFvdyozmIOPiHX.H0C64oLI_kJJbnebcxtyk9jVWf8v9bsN_RFT0GrsW0qQ
 dA57n.ZPV.xPywikhmQt2ok.7gV7G23WzCdD7o2dL2aW_cX6vD27FNwIwpssHfnOQ4et39ekArBx
 EY4PDNqDfdk.ovoMTMxVV1p80dHy25y2N1WmPOVuSxi0IoNOAUhg6LKBkqhe9fUj9tx6FH7ywYDv
 IftnHJQkppioRXywiCBsr6bgwgaToCtKU5KATioeQEkYXPmpOe0.pRzU5EdQpeBHb192TejyUOBO
 5UJL.dm4hhJi1iaWgFa3nYhLPmaG0jSVfGGKugITVZMgwCR.opmTX.xuk4ChjGvGFQP1Q.03Ulbw
 MRDWd1UQjnZt0rPCnp43EEYJ1daGuQJ1g7z.83p_C3mziqGYsrbTYxxKE6C9UNbFiwpDVpyXp2Fo
 9nKU7tnuFQaCp1nUG7i868oT8i3ZGir5JeI.EDUz6_5.bxbTT6fqmwAK6nB1gscxACYzrDIyxMdO
 oO9fcO_FrMRhhYXf3zzq2Unn87omu3k3s1BkN_LyIJCS_3ccGtZxJA9Oso4IBza4gPN1j1dFWk1_
 CLxVC48_vQ25cOvzmyLulmh_S8xbaghU_iKT4jPD52yYToqZZVfNR5hkgN20oZYmP.nIc_LkacrH
 F5yMSTgk1w9.51iJ6qPaCXHLT56.8eZ11EWL0S288RIP_avlY8vLyryVTcWl4Jkrw1njAmxRuitN
 vx1nBoNaqBzpeGdncPICmg5U3d5RdEUWrPH.ORD9y9XQ8Zo2hsxbsFWYg8Bwk0gea7JHXju.ij03
 PrlmTZA_IYMtpfNPMs7dddUOJjAkROQUVXdToU1cjR1QOzrmaeyUTPC3ETBQ79y9hw.VZB6ZrHcn
 MHkirXQThjSLtmnKosOI06qxPluqFtVHqRh0JCl5_G5GtAy0oa9stknF63ReSDndqFqNjxFOhAPX
 haqGAI2CF3YmFltNFvfDV9Lin7tqoqeGsAeNoo_IAM9AAUFHbGC6P5ioxUDq7tZbiMIPG4UgQsGj
 PZj6UMXI.edYZWhgBI2aXHt.eg4cnELXmuRZEfxJYlcGs1XCyT.YwegQdp60NA9Hx06ZbFbgg6sB
 d49_lgZJM7PrqwgWP3ZJCE5v3.S5l1FRUo43GTZ9VXzU7v0btm5biUr3OezqKWg8RjId3f25iAxy
 SHdHHvIZvcgJOJXCJDp5Cu1_Rpn8xvnrTYALf9IIhg_RSWG6jBcATaUtrkvl7DQgHAJ50HccPXFq
 7WIjuhS7j4KsQvNcKOgehaJSvO.mi5XJliuIWA6OtdPTmLBAIc3CLDPvDrSHL4WUWVqpFeRx9wfS
 0OQN6w0I017IucBKw2bDg0xf7_M9QgXkJ_dLKFRi47UsdJ13wIQVcTnWTBAwvy1Pih06gT7VmgR9
 iZBpiutakD7N2mP_fgj1VRQKjtQ55I53uWttNvAmizON8UZnaApPMZtE2noypWdtDLNPXOe4iFoQ
 D1ZFaTFl_9PEk2iM83ak_uECZRtaBIjcVlC2SRSVXHPQA9Ngc
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 951b3f9a-4cc0-47df-9489-96d6215cd7ea
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Mon, 31 Aug 2026 22:48:21 +0000
Received: by hermes--production-gq1-678d9dd684-vr75x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9afda7e456c775b6473ef75f34d3e2be;
          Mon, 31 Aug 2026 22:38:04 +0000 (UTC)
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
Date: Mon, 31 Aug 2026 15:37:44 -0700
Message-ID: <20260831223748.4304-4-casey@schaufler-ca.com>
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

security_update_lsmprop() updates the property of the
specified LSM in the @dest structure with that in the @src.

security_secctx_to_lsmprop() sets the @prop field associated
with the LSM specified to the value of the passed security
context.

LSM specific implementations of these hooks to follow.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 include/linux/lsm_hook_defs.h |  4 ++++
 include/linux/security.h      | 16 ++++++++++++++++
 security/security.c           | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+)

diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 65c9609ec207..679c40a8e127 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -305,7 +305,11 @@ LSM_HOOK(int, 0, ismaclabel, const char *name)
 LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, struct lsm_context *cp)
 LSM_HOOK(int, -EOPNOTSUPP, lsmprop_to_secctx, struct lsm_prop *prop,
 	 struct lsm_context *cp)
+LSM_HOOK(void, LSM_RET_VOID, update_lsmprop, struct lsm_prop *dest,
+	 struct lsm_prop *src, int lsmid)
 LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *secid)
+LSM_HOOK(int, -EINVAL, secctx_to_lsmprop, const char *secdata, u32 seclen,
+	 struct lsm_prop *prop)
 LSM_HOOK(void, LSM_RET_VOID, release_secctx, struct lsm_context *cp)
 LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inode)
 LSM_HOOK(int, 0, inode_notifysecctx, struct inode *inode, void *ctx, u32 ctxlen)
diff --git a/include/linux/security.h b/include/linux/security.h
index 153e9043058f..19adc19eb9af 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -576,6 +576,11 @@ int security_secid_to_secctx(u32 secid, struct lsm_context *cp);
 int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp,
 			       int lsmid);
 int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int security_secctx_to_lsmprop(const char *secdata, u32 seclen,
+			       struct lsm_prop *prop, int lsmid);
+
+void security_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			     int lsmid);
 void security_release_secctx(struct lsm_context *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
 int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
@@ -1581,6 +1586,11 @@ static inline int security_lsmprop_to_secctx(struct lsm_prop *prop,
 	return -EOPNOTSUPP;
 }
 
+static inline void security_update_lsmprop(struct lsm_prop *dest,
+					   struct lsm_prop *src, int lsmid)
+{
+}
+
 static inline int security_secctx_to_secid(const char *secdata,
 					   u32 seclen,
 					   u32 *secid)
@@ -1588,6 +1598,12 @@ static inline int security_secctx_to_secid(const char *secdata,
 	return -EOPNOTSUPP;
 }
 
+static inline int security_secctx_to_lsmprop(const char *secdata, u32 seclen,
+					     struct lsm_prop *prop, int lsmid)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void security_release_secctx(struct lsm_context *cp)
 {
 }
diff --git a/security/security.c b/security/security.c
index 71aea8fdf014..1dec0037370b 100644
--- a/security/security.c
+++ b/security/security.c
@@ -3965,6 +3965,13 @@ int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp,
 }
 EXPORT_SYMBOL(security_lsmprop_to_secctx);
 
+void security_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			     int lsmid)
+{
+	call_void_hook(update_lsmprop, dest, src, lsmid);
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

