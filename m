Received: from sonic312-30.consmr.mail.ne1.yahoo.com (sonic312-30.consmr.mail.ne1.yahoo.com [66.163.191.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABBD42049A
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.191.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386551; cv=none; b=nHAXECkkSk4NR4aoRWT3Np8Q6s2FC2/dqOxW94efuySldktYRJsUE70mDarluEhu+Cw+3iCcieXEYoyFlilc/wy3XlM70ClleskOV42mO8yfe8nCQ1UIOubM4k6eCwmOt7inEEJ204tzKZxnTsvihcVHO6Jovf8DHqLFelq6xxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386551; c=relaxed/simple;
	bh=XVSjcaZyuUD2SrbqN9FUXg2GXtPt/4t566caTuPgIpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SInnvq3TrVnNfoOFjMSb6ym0o71ggrYEqI8R2lxKY1yT842iSrQQCQa5nMYpyXuoPBFYyNte9pwAEzKOeuFaz/JPbKcoJaMw7ky8hKOxoJO1o3VLMo+Ehm1WIA10rmdFDw9joP/jKXHlPFZyNuPyyh3/fz0hMelmPWc+UOtHWfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ExBwVp8d; arc=none smtp.client-ip=66.163.191.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ExBwVp8d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386535; bh=tLRp/oU1oiSOD4+KZUJnxFQDz8wkKZs/J7I1da4eUx0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=ExBwVp8d8nDylCLh77KcI3HmLcPmefifIFBTLuI11xwwnrrxRtPjDhqHn+Jw76n3X4pqWD3486XgLsfpsghwsoZ4SDKfQehZrtcEXmwVFT7uGfOI8FZ3aGCLY4IBeCy3gK7iwzrrvFQNfOVD4sS3mDK6O4V2xyX42hqlJqzKRylul7j1kCXnIvL7SgulcjMpNlWxU1mqdbOTu7WpR18Qfye98WrxXSg+K3pdLT4CRnDa5JQGKaRE7Qinu0XesD3HuNWC1d2EVJLdwEgP60xyyBJe7Wv28WJWtICsoG3HAz2nFm88huUuc6M1bJdkfFd7/lf46RbJRf1171HgNMI84w==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386535; bh=+v5K2uFpu5dCBXjy939H/WDTC/DhQqaxP3dUSfFGCf/=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=XD/e+qxD7JgnVnbCmZzAQX40NW2slkWKk5gmtFJsbxEH65Du5c3RkvVXMOD/G4StqxPSjn3cMcHODf1jWWy+2JU4dRZkBjrD5KIyM0D8vpygNlBd8nsB2EHnSLKzplhJyifvi6dIbsy2p3zk9yfNxaUuiNAwKEp6r5fysNVZKxev8K1DWqVpyPeD57qHkrrYzV2sgIfmvdA0i5ASME6I7Ua2sp0+i3as+7k18keBephiL38OGP5wSj3z6B3Pel1lT4onnElcIS5F0L9fDGgsCtOTncXyJcwLpDo2+icOPfY7iwnTdeJX9GC2ehZtQrOY4Eg63A1mBRt1FU9WJEkCcA==
X-YMail-OSG: TJKKPT4VM1l_Va2xG1kVZ7sz8hR0vjw6l8SzEn5_05v4yx.PxjeWWgC66InfWJg
 A.HgW9ghqij7Qhcxhq4XVmBEzRbf_zZPZOMV0Qht7fPVfl3kasYfV71ScWpDAn1RERbAHypUK_h3
 feQvz9sJbeJgD10HZUSxvb0w16ExXDvaXQtS6WOXU7ibFrNj6dESZ0wIYeDF49N08mOiLKr5V7JW
 6gVdyImqm5p3vDVt_DUnd4TEnC1iKZORbnKIIdh6mJAnxbo6qbxk1o2SIEhllqqjjhwgCXpcdzPY
 ZtHEBu2kpqbQWSf4lQTMtKfVxAgQSeIfRCIYNs9.xPnGNFxLEsufnBsdNIx80F4zjknoKsFOOEt.
 c9MpkYlLhmZlwqxznoEu9JerC36rpk7fZnoOKm6k8Kbqik0zsna5zZ5RqFwSmOxzLI4P91ZQLX1S
 ez3EC.nyQIWD4x4FBpfkweBhcNF5y3gXTmcq7nQS_jaCCft0jKgj37ccf2HfQfJe2bymoJusfgGf
 8QwegX21pd9LBIcSFLBwj6IEV8THLKqofUr2T.smSubgYNP9rvFk8fwngTtdaG4jLhqdPz2HnJWV
 kgu0nHcO7HfgGRhdDhmurZElPWIAidcEszCQz_vWjJludoJDl2xufuGT8MOkjpBsEIRco4CVPMVy
 Bmz_oHUQ1nUUKohdhCmBFl3I5UfDvgwA70BNaOncE1Bmx3PNWT24TvLxKho2Nyg_7NBNAGAsIGuH
 oJ7z7IbmvBzrJWqG2bRjYio_HKJDJUzNZqlRAy8tzV8IPSD3A2SEav87cwaCYn2zFmqV9WL3z7RY
 P2PDTZnZ8f.TivwXJ6Mjiwu0VYahNSsBn4GPErBDaROgiL9xEse.ymcw24ZypGKbTtK53myhHP0N
 jvm2iLX.1MI7CUBmXxkH4_2D.qaK5r2L85eluifWZmOEFG1LSVXbofIJjQnnIdomhhtlmgy06q4Y
 aHow8cQMfzOH.jqZojFRFsXmjeuyaepm1XyGewGwkxVGv7bOi33e__UEJHMgLiI89vlm2v0Q_Rac
 kSXohDcCBWaoGqmDfgi0zLnBHJZKDz9Sgm0Ca95BtIWJHIdBWeOyFh2cZWE2QrOhFNMJ2eCltdkP
 H4p7l0PjDS_J5LJsc6Fh2lj6UQJ7f.Ntg6oWrxpVB6lmjhd3I0sQOQZi6oFWIkm4OhE4._E0AGrm
 IWAERlq0ICfxBMYEbtrOOrXPxxBxjXujzfdh2xOdwMvDct22tyWIK8ODMQ5B6JyEU02dCq.kfzVu
 RtgMjCzxlZ6qph1nFEOTtU0BxRQIA1mtGVPSddVaTrJWeIs2PUWQWu3hVLgvyTraDg38yA9q0.hL
 hJixHC7_qL6X3LLqJQji2PWkCh8ePuWDx553wlGFqn_RUXOYwBZAZu4OmIuGxUVXi.1YGVtFqHg.
 2X4rdMkdlY9usnquLCp7b1pIISGNW0_tmk730KUWGXun2g2TDeHydiHGaGjJbTW80VXuPGw3mfIx
 IXu3niTCRzT4Wr.uHepWBmXX2fGFkNnGHqEyMO8_K6zQEnWvSCnjmigFkhaz0OD1xY_5gQWp3rET
 bXirnxggPfc17jslbrH9352KsCevpRWmlilFMb6dLCFagybghvx3hRFERPDQfJ0Gd0Fnx_ZneMpc
 yvMZMEVApVqqiwPNmum_Q1xtdtVe6_S0dCjI7Lf78HCZgsGXOyAxMpuDlj96kgxeM5Jtw4lq8lWt
 ORn5fdELp10XtVmYHd4B1uBoh13ALjR0tOwPyhFBLWzcbMaADiJJBraz917r7A6eCpY.KQ.rqCJA
 VKkYssY5b0zLVgyAfnyWmy.cJjuxasmRTtn32UGSibVjgynKIiWzcY3VPxfbziFxVQiCtyL5q6l4
 H.SWG2E8YAjDMefU3xuFdBsmxjY_g2ibEgIlxvHPubUmqyRbp3Ob7tRmFIyKwz1M0nWjTW6dQ.U2
 drCss3HyHbb9MxvQbjIdc_QrXLZFIIftv2FruyJFx7KDX24e2vWH8Pv6BVg_y3DkQkt3jsoimrP_
 2xS0pu6riyL7AhOtibsl1gR.KuV2Zn.VsfS2ZwT6D2.mNnHttTnB48KvvucnwkgF.NWxKPobQ81H
 Jx..FJG7VPSPVjHnMfuUR5WHglL0EMfDXaawdvbbv9F7zaQDH6CZMfK0YF3rKwBH1hBPSLyq8u58
 bmZnMdD0UNjrzeWeE5ITIL43tuh7J3JGIja3mnQNqtN691jgEcj_18gGLeFoJlwQlurWMMBdoGOA
 0E8Gpuwmw5GsUFWMDrb3vGjaSmsw0thalu074CSFilTwH.ZKY2VYGfQHWJ6ThZsLdlydazzB4eYE
 1sJ_beJJ7TCFWDwEUCxpo0lA-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 1557c0c9-4797-4679-b987-c0c0087dacc5
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:15 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:09 +0000 (UTC)
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
Subject: [PATCH v2 3/7] LSM: Two hooks for manipulating struct lsm_prop
Date: Wed,  2 Sep 2026 15:01:46 -0700
Message-ID: <20260902220150.18586-4-casey@schaufler-ca.com>
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

