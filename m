Received: from sonic310-31.consmr.mail.ne1.yahoo.com (sonic310-31.consmr.mail.ne1.yahoo.com [66.163.186.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65B13C09E7
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216510; cv=none; b=GpajSuhCCeblkMJEM1x/tvTKDmPlCWGpcW7ne2gDov4yFTyUVF2zBiat0YKJlfC9Ilss0vgh2bsbKfqyuiS/owEsoeQp7ByzEy13o37chsuEIEDAa6VZFR2SNrcz7gUPWWjlK9SbKvroqmDkWm8VBbadjAg7L5XZUUDTyq7ZeJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216510; c=relaxed/simple;
	bh=muebN+v6qk6ACGUSKBTi0IBPg9qD+4TGpA3UhEWJXTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlGi0B8fXaOuj5MKx0OXX+8JDrEW3ETLXvIX/zEwdZIIbfDmxg4fHUEkia6yq+wvMSX8wg+JQWo45YYpva5sGmBLGD3VSA+5rVpz/tYBb7u+BLvjJc/0BHo6S50SSt3PUYKS0JeVsAo3+0WcNO7l/RU5ejgTj/wJs7PVAq/D+6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=gIoeGgOO; arc=none smtp.client-ip=66.163.186.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="gIoeGgOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216507; bh=kihgJhG3NGCIZmRbXk8CDq6KsRQabfDfAuGQ1/19lsU=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=gIoeGgOOVudWHZP09hNxqu4idnsu2xRYwYeTSqLdXkUBGG8ZmXYLkcNhK8qSv71q0fYvSe1Yp/NBaX6SgM131++a+ghEFLCBO1qy6XxqauqquZOWNBMIbS5e5InUwOCym//Tqa2A4gop7su8yDiilpf5A9eHbwQg6f8XUyzHmsBjFpqyjEG/SiV57il9JtVT458wK78+iujzJrTHzgcoN0+oGni3O+6dulleZulgmW9nK2JRZMcGUyg+AAbN132jgjx07qg77nYaPuCps+ay3IrzIzoy+e2sXBizCiBo3+9vga0oNDmc3GFX3/fV3BM143BQxKUmFWWYzz1gq3AsWw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788216507; bh=/shlCJISK3rPvZb0OarcggiNow0TIC2HUtPmeN/n9K2=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=ty3kDkO5o6TzUwg7deHk3Z7C2gcm0y0O3LLvEWZVzwbdboLAGsCuVBSyroAeoH338Uqn5XKYoP8ifLg5ohNkI2nUrrY4cVpFyrwi6pzKz3nbW1+26LljMXpNe7KCGum+KKqeLWYZxClDHiG60236qSsAKMtqVDOrXru2LNKHgxcNhsyPEyjSh/6QRg1bve3h0ROubcuWm9qiSWEg97BPkBxLFbG8FUKdt4f0y0x8JmAbTYch/dxI0jtUN9LXy8uSLr00XaAEHQswzA6aRTLv6LRV2R93kFBYwTiSn69T3vd6eIMDqWD8Sk1b1l5J8zGbcnM/oUqYJQucqVH6QubCAg==
X-YMail-OSG: Yh27HCIVM1lmsqqbZgmt9reafPSEAX7l6EpSEfgG8iCOYafh0__tl72XPEkOvec
 sSHDmzBNP7u7HWuFO1My1pJMwOKf41eWS0PpKOjrnaP2zEm9jb_uzk9ucZP1MZBL6uF5Eo.4uT9j
 5xYrRn8u5N3BTAjeFpby8jQ3WartwmB7cK1HLomC3PLhVeHEGYWncO15O9mB7p5GX.7cnnKNc8bH
 wSZ7j17S6YqVAJk0yYs5CAP.ckCL4Jg8KMjbRQLI5mfVObtFKLvydeT32dPPL0M0DVZ2d7u_E0o4
 94PG9JEARjpIwrqwp3UEL7eJAlYNfK06fsnA2rTLTVCQxXRl.x8GszdYxrOdpydkWvw0iLtUhJ_j
 rcesD8b6GTjICJJWz5hAOYJsNeXhYogtaPGE4n1kd_ViUi3jeyC6VZ8asKUewrJny5nJ3fagCVyb
 5lrHexjuS6gU2WEL1KzqBIbYSZ5zjtstWScHD0nzBvmH4oSAjlXm6qmJKMOFc4wJYG4mPtC6zACA
 VNhTJY8PBUST4O6vKTxZL.1fepzt6RNrM.daptEox2RbT7zIfqJOKumVRugC6norroq9IoAPxSn0
 mi6zXET7zSBoackz8CvgCGQNp9QmT8fNRTf1wbUjjBKBzxTfVjs72ZClUt_qmTylu6IIwCjaL4ZA
 ViFd8H4ba7KMPnyXB4Dj7_ziR1IDwIu_sIp50qzafQSRNZ4DXQn4BMNLw4M4_nmUS9znEBp6WRfH
 RsOj0DFhy4eHzcSta4TW6MGlv2I.xQ.ZROWGOWsSx_FiWX3sgRDfq.N2paiRs9s7tGa.d.AD7oiZ
 0lATUNJdn49xD84Fz.5yFpC9RGpGRVek8TNY2beuLiNfoPnlCtIkzh5vfU2NNXRbtyOJSwuZ3Y.P
 hWhlYkNVLxZoDuv19zXBgMqrdMLYS2rkST.KsfPYDalglavduLFyfEwi76cTbeeQh.05WgDrNUlt
 InoWUUF8D_K1lT7bxJ1D_Q1i9kzHPYn9UV0zsthkiW3JojlYslutdYrWc9mSFZ7xttz.GjzCkSmb
 mO_gH4LYqike1nO6BHmNFYI8lGMP4xVWamHYSuHc.aYivxVqk0i_8dXI7ozio8b61RJ6AlMF9h4M
 6VpO3xpvBmwTc3NOzIsXsnBl.gZq.iwdnE2Dptxi3wDJ6mXFoGYRCiDqurBu9iO3knueQxpTPKdc
 .HlhiG9B4vtcyOwoKJqMM7nYkwIu9Ou0sF8iWtlLCEjNBx55tkqulkoEfF7pQ8TCE5XT9p3qtHq7
 hQBmBEOgUSBJVsXjeE9V8tsK4abXTQiVCkRt6aWk.qxAV5SPIkoXFZk.5.xsg0OpVyUM4jjiKQUx
 TCe8rObjIvsPQDnkEJCA5NV692wkaIoAcHCyWeXnK_HbLNMMszEImtX8XBLJcmRC9kFKxVyUBKhE
 1WIrAPF9wZ2FnKbLXJ5.tGvC.Gug6ATMQQltYArsiFupwC2iSEQ7hS1S_.qwLjLp85zzvTvzEAd0
 BC0y3s1y9D_1SuO4iJC8DI3hmydph_xaIpdyaRixyJ3Q5VgR1ZLokLLevpARjedf5aIY9mQxneje
 CAQTouYkwo1XK1JruZAhBE9ZMpXwBBm1G6vyw82fYIMEpIdDna0.xTJQjTFWY58cjcS9_dBf2LB3
 iRevYqAXw9y2oOWqIdxSdd0vRwz2LY6nD_H6jET0ZKDO28SSa0dEYXALGbWyfg4OyoaOz8me5YG1
 pZbR7zvNZyKijSGu_7Jtv1VTC03u4Q7_LSR2AFqLs6tKnV1itka.sWDJk0fe9I9usGp6lwFMuflk
 nVPJnIZaKQLPiGJ5EiM2n2pvJTSlKsKQHudPPL6K0sCz4cMd8hWMfgJflkmFUYwnmsF7d0Bd.7lF
 deS2aS22wG7WyPxDciL01hpc8RULb33APIjvBMtD6cyOu7NkBAEWFp_ds8BmkupEHM.bbo1NPpkm
 bZqjyhk2G2NpcH_s9NR64UXfCjjsAVJWnpL6laCI_bgHOGPDhl87SjUepQD0UaaS.1qUoQ2mEADA
 N4cWAmzXG4qh.99gmH0WahnojZc44BjlPYPdUnHNXeWYJx89dCTuLTKoEORALlyFsavLvIyUwwop
 SiDDH00B_aCU1vkKL1hclfb_BUk_VfhEqHYP85c.HQsJEaPEdjhZ_vNGus09.zAuOLPGiHRfJ78S
 EUlgQaULJ2KkQvzs4u5SNPyquOoJ29MH7JVkJuATk_8VgD3Yimra4mlKG9qje.pxGBUp6kud2W57
 VEWgcXS3ptmKYVipTi7DxhUoEImKJ_ML2yQvm1GsKP_10Js3cPf9A8s5Z6GjFKQMTH1p1V2aOTj8
 xNlPgPWdERuTdwVQWvKGnqt381tc-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 308d9de0-972d-4455-83d9-7d9858fbfa3e
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Mon, 31 Aug 2026 22:48:27 +0000
Received: by hermes--production-gq1-678d9dd684-vr75x (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 9afda7e456c775b6473ef75f34d3e2be;
          Mon, 31 Aug 2026 22:38:08 +0000 (UTC)
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
Subject: [PATCH 6/7] Apparmor: hooks for secctx_to_lsmprop and update_lsmprop
Date: Mon, 31 Aug 2026 15:37:47 -0700
Message-ID: <20260831223748.4304-7-casey@schaufler-ca.com>
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

Implement these hooks.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/apparmor/include/secid.h |  4 ++++
 security/apparmor/lsm.c           |  2 ++
 security/apparmor/secid.c         | 21 +++++++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/security/apparmor/include/secid.h b/security/apparmor/include/secid.h
index 6025d3849cf8..ba7adf2fc09e 100644
--- a/security/apparmor/include/secid.h
+++ b/security/apparmor/include/secid.h
@@ -28,6 +28,10 @@ struct aa_label *aa_secid_to_label(u32 secid);
 int apparmor_secid_to_secctx(u32 secid, struct lsm_context *cp);
 int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp);
 int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int apparmor_secctx_to_lsmprop(const char *secdata, u32 seclen,
+			       struct lsm_prop *prop);
+void apparmor_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			     int lsmid);
 void apparmor_release_secctx(struct lsm_context *cp);
 
 
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index 88d12e89d115..1f304b88eaf9 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -1766,6 +1766,8 @@ static struct security_hook_list apparmor_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(secid_to_secctx, apparmor_secid_to_secctx),
 	LSM_HOOK_INIT(lsmprop_to_secctx, apparmor_lsmprop_to_secctx),
 	LSM_HOOK_INIT(secctx_to_secid, apparmor_secctx_to_secid),
+	LSM_HOOK_INIT(secctx_to_lsmprop, apparmor_secctx_to_lsmprop),
+	LSM_HOOK_INIT(update_lsmprop, apparmor_update_lsmprop),
 	LSM_HOOK_INIT(release_secctx, apparmor_release_secctx),
 
 #ifdef CONFIG_IO_URING
diff --git a/security/apparmor/secid.c b/security/apparmor/secid.c
index 28caf66b9033..d35fdbf074e0 100644
--- a/security/apparmor/secid.c
+++ b/security/apparmor/secid.c
@@ -106,6 +106,27 @@ int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
 	return 0;
 }
 
+int apparmor_secctx_to_lsmprop(const char *secdata, u32 seclen,
+			       struct lsm_prop *prop)
+{
+	struct aa_label *label;
+
+	label = aa_label_strn_parse(&root_ns->unconfined->label, secdata,
+				    seclen, GFP_KERNEL, false, false);
+	if (IS_ERR(label))
+		return PTR_ERR(label);
+	prop->apparmor.label = label;
+
+	return 0;
+}
+
+void apparmor_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			     int lsmid)
+{
+	if (lsmid == LSM_ID_APPARMOR || lsmid == LSM_ID_UNDEF)
+		dest->apparmor.label = src->apparmor.label;
+}
+
 void apparmor_release_secctx(struct lsm_context *cp)
 {
 	if (cp->id == LSM_ID_APPARMOR) {
-- 
2.54.0

