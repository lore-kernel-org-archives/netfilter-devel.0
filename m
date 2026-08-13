Received: from sonic314-27.consmr.mail.ne1.yahoo.com (sonic314-27.consmr.mail.ne1.yahoo.com [66.163.189.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCA3438485
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654778; cv=none; b=txawK2wZ+jk3m2eYx2swBjEFjZu3I4Qbf4AkpN6AeTeKJByfZ2vyu01JZneee9qpsUg9zHPLG4QsL250qWQtZaGGBeRC8GMna7q0ZEYN96dFcpZaLNpsYtFEuyNDSFMIiT3EjqYwXvnQdW2yyN1jmv10i3d/IBtnjZxvUpTV9jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654778; c=relaxed/simple;
	bh=iplEOpAuewoDbtmO5Bgo946/rCYzlrvNkYvSo61Gg+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7kReQO7YF7wofu3Ji54qT85GHMJtmbmkJzP0GBbhZ2YOhd2fLFZEw2lwMCYD8JbyndQjU3/fVyt4kpr4bzQ11vqT2h9k/lCtfwXBo3uasxkF+GpS1xG0XoiCF0Q4crbHl7pi7Z+iCWnbiSUOpR80vuFnr8NF1HHi4U5/85M3W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=c3Mn0nRj; arc=none smtp.client-ip=66.163.189.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="c3Mn0nRj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654775; bh=L8gF9lbb3/GdM063c/AqJxtVF10JcTPk+9Ii0LVaols=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=c3Mn0nRjddd37T/EP2WpMG9zFCl00+SHVRYe+X9IKJdPYG83mnP3ATutvQf0q4KqwcT5WLpjlNUsUHXD3FKbcT0fGbN+pSkiulkBRD1Xlh1NBwuV2FOoWvxIKYxDJxbR27Oa3eVkwZntKRZ5MrAgG4ckSGZGO6vZ9cxJ0e7b2mULFSglAvdiWaugVQpwXgYBOMQNHUxqAneJ9RD8Cv9NtxmfEIvAIhJdp0bL3/xmBjAWxAqZJHy4ZZDrHfN/VPdyYd0XZH827KWbEAUTkz0qdZUV4n7c/i1SYXlriQXyw/QNAcvIsx55BRiLk0ymRhBM0vIKqDNI1oIjSbrkKib/eg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654775; bh=bT0lGHdFMPn5QSXBUcZZAWIWY3q+ILHb9ZA+rVJMDUa=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=W72pRKat9oLbOCegwLCZNZflvtTMF7e8elBjWB+PRahIuRFQNbGP89boR3oyiFKhV8v5qGJf9/6k0kbZXDaCJxrz0RdhMjCrZnp/YDxct0yjLieiQ75Ig18Nhdfk1nMXZPTyWkNt5An7f3Dm103CHA/nFA6InIk2s1y8jR8OAr57Ho1se6rWfrS6sazVWjQjUpvXVJGcVmIbM5Fi1dzecXktAV9y3bicgFsH5D8aRootLvmrnLypEzV9/D6qITCE5cdlmqMbglkx97QczftEpCpeohUmhfm4Pl+Kfv0kXGIfjYHwOoLIin88gfVWFoDSeNltMa2sGFZ4fN+VLb/auw==
X-YMail-OSG: v.aM1UEVM1mRwhXWuoIVtQjgLTChcQQxIObiZted9Av0P_KoQiCW.xehYlBLl4A
 PLwehYS3vk8PER1Xh0xS1.yuwDmZYiTxyHZuTVmkM159P3eBPxHZP5zrkrBoKD3rb0yphLvwGBFw
 3oY6IMYZaDc768E4yXc0kAgWZ.CrLCaVxqNicV70IETUJCWPTUW8dVm9IQ_mPY6g3MoyUmsNVbcA
 Hsx_WfkBco_j.Ruv5oRn08NQS2Wfz1ZOjNwFfIIZ0i0w3DNHjpBx1T9mWZd0sxRJ9dqgGpdUuTx8
 rVYZF9F.Xm6ZU6Vw6MF4rvQBUZ9nAacp6UOJDoxVdHiUNB_Xg6mXMfNXaec8M2x4aCstqwRpNjPy
 c7E6AbQkOtiOK9OEyBFKGlxmOFs9QxJ8tNK0_.r8EkqII2DX3FL2hwLKxBBPxGo._nVaPA7SM7tM
 NKx4iACoecExmdLp3AJcrl69dpQqNuyFIfejqSdD.zcBdnERZrkSGCkZAhHbdMJ1CZ_o6qSmvqwJ
 bnndJdun2GlyI27OixsCL4zzoYtnjoJoCkjxU7FL_6GvaoWnd.qqzBL8x8AxXBqt5RgkYBeMXOom
 ESNLKjH4rQGYzPyB0QKqMc30DJaVzzHHj8kWcPLKr1DZrhoUzdaR_wjv4MJ4reyFQHqE8Q5IRt06
 vkPs_aRho2szOvPOEACcP1ZIoCgegXkKkwX3oLDj7o.sss.u9Uxu2G92HtMkoez5xxsxEwAD3Vc_
 C7kRDfirVII3KUFrObh7kcWjiAzq36POX16zxRT61wTB5Ot07LQz0zeIpmd2hVsGmJ5_ujZ8HTOn
 I2z3AwRqtgHVYfpciOqJbvobJ3gXeQ3.387L_44bzjhVHovykA8OouPd3sN.UnmKYvadQnRw3kTn
 FJjSUr932.a1nbXEDCfbk0kCrOgQ327edZhNmnZIaA1S43ULRdmslw9FieM.YgyB6oFYwnZFm79.
 Xt2ZgoBZ.8qoulNYdynHD1LPSet70qNK9fMfYYVRC_cfXiedCXC5l5hVaRxH6YBXKqSv7HubvAGJ
 Eo1Nk5vwRsgix54M6xX3geqBcQ8AHeXu7CBetfsh_LHXRfh_b4fQZDu8_jy0xZJ.qjr.cYCMaCpD
 MunEwUo0RQ.boGMOWNmFBUHXh3ckOaksrSde5Jo9SgFNLVzpQRmAAeOBCHcwpx9nTUWOFH54UmxV
 tBOdB9leo_z2hXT9AhyK6Odrd0unf7lQvFsVB.76KmYdcohJ0wNOfrkMUxFZ35PVeA_7S.atGbil
 M56LNxShuCbFJ_Ne2fZYnpwoTqwgY1DYbonSzk0hL9HuZjWu_e9oUdgSqucItfEOeZu_vhsnco4_
 pTBnVVWiXmiOR8yB_0D6j7yGBCoilC4FlxK4z8JjMSStXl.CYYYq.q1T89x24csVxQjP5i760O_T
 gB.WGcCGEPUaZV3fh95ExKK3e7qcp3kTeBzCdyKUwVlhtYXHHF9FWhkx8f0dfoh31zFz7CpkHeyv
 rv1VUbiTJ6RGQbb3azj5D6uF0mzs1d93MDQPcKRU9L4TpX..XS6E2Uvny8RWpm4gmaU9OENjQH67
 TQDucHVDQbVqsVE3IHg9NTp5uqe1GQbJEtaFUTQpp5AezAWGjZ0oZvYkmBW1iwZ0YKwAJPIoxQfV
 seggGTamasoVAs8fLQhb_bqtcQ8qDyDMRPGErj.ujm__rPfeeXbF26LrAfZ_q1M1wMAdRoCpnsSS
 ECBsI7emrRmKIno_jOICb1xF7urBEH89cBY._0YnBOiv_OgKV0hLBB5TjsfcKeSmNWaN_LfGtiMM
 OQaOxEq15AG_dLHd9Zf9qEkeRnXVE2KyvaNQXlTm1laZdie9db9v9qS.oAvivvkBy.V9ILnUIQRc
 HBTkSlGo_mIPpOlfzeXw3vXUBG3aHa6T2TIa8KkGnFLoykwpqjfAAMSOr4Tw0kr1sJ6lbaL4uU.6
 3g0Luj4Qz6D.fongKWk9dE1GX_UF03E69N0WMHG3jaWdbXnRBrlJkFMIlpwrIVVbWelUuu0n86Xe
 SBJ8aqwfGjNiPSNntx_pHWLUvGEK4SZwf1HOe85hg799WAYnme.YODkYUmvD4PeFdr1UkCLlv3DW
 H_7UILBPn4AfHAL._V9MYUZHzc776s18rNPtlkDotIP1q1VpeYsFasx9FPdFcUZqC38UEVS4UjwI
 UZvoz6F_7dv_jALSvix_fR2AFmsGvSL3DPk2dpm72fNvmTUsfMLrtPFtOZ.dofufu23RYIkBGJm7
 D9xgKAe4RX6DHO.XmAdYs2dcn6bojntgT0mITsok9RP83SB_fxjSotKwQGQZpkJ5pyt7emKlfW25
 .A.4uBYRKRo93gfKviGaKhsvUks7g
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: b6a70a9e-8261-4e33-811a-1e77ff204f88
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:59:35 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:16 +0000 (UTC)
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
Date: Thu, 13 Aug 2026 13:48:53 -0700
Message-ID: <20260813204854.19211-7-casey@schaufler-ca.com>
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

Implement these hooks.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/apparmor/include/secid.h |  4 ++++
 security/apparmor/lsm.c           |  2 ++
 security/apparmor/secid.c         | 23 +++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/security/apparmor/include/secid.h b/security/apparmor/include/secid.h
index 6025d3849cf8..b290ae8f9b01 100644
--- a/security/apparmor/include/secid.h
+++ b/security/apparmor/include/secid.h
@@ -28,6 +28,10 @@ struct aa_label *aa_secid_to_label(u32 secid);
 int apparmor_secid_to_secctx(u32 secid, struct lsm_context *cp);
 int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp);
 int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
+int apparmor_secctx_to_lsmprop(const char *secdata, u32 seclen,
+			       struct lsm_prop *prop);
+int apparmor_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			    int lsmid);
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
index 28caf66b9033..51f3e4ab053e 100644
--- a/security/apparmor/secid.c
+++ b/security/apparmor/secid.c
@@ -106,6 +106,29 @@ int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
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
+int apparmor_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+			    int lsmid)
+{
+	if (lsmid == LSM_ID_APPARMOR || lsmid == LSM_ID_UNDEF)
+		dest->apparmor.label = src->apparmor.label;
+
+	return 0;
+}
+
 void apparmor_release_secctx(struct lsm_context *cp)
 {
 	if (cp->id == LSM_ID_APPARMOR) {
-- 
2.54.0

