Received: from sonic306-28.consmr.mail.ne1.yahoo.com (sonic306-28.consmr.mail.ne1.yahoo.com [66.163.189.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B94AA00C
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386551; cv=none; b=gAXI8613rRdSQh3BVVdY2KQMbUTpXA2cWSRCy2MkskWgrAXQun8IcOpSl+mbXcIJNrp6gXNJvLlMV4w/xH5LTqpAxIEfHlPI3tm1Yi92tqLaK/6zE6rs3l3RLVmlIcslVv229yosRAw0QudHMzf5oeHWtaCqiV1c7KdYd6jSogQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386551; c=relaxed/simple;
	bh=muebN+v6qk6ACGUSKBTi0IBPg9qD+4TGpA3UhEWJXTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kzlv7jMhAcnQyJ4d+YC5jq5JDlzxn54DDMTISBkVniFChvqHaigkaa8Q9hlvMOCQV/kR98TLeag33QeSwdBalSDf8pjSibMbskX//h4R420tMM1vGJ+9V32lHZB6s3bPwfMhnjKBpyPvbB0VmkK9Opx/QIeYPBSAFCDG9gpYM3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=IIGu2lot; arc=none smtp.client-ip=66.163.189.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="IIGu2lot"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386536; bh=kihgJhG3NGCIZmRbXk8CDq6KsRQabfDfAuGQ1/19lsU=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=IIGu2lotfxm95pQc4VkndM8SdfUUMIMBUpQbCb6FIgmpZR6X/sElZh9d3TbDmZiAoNQyyVTyTdE42NDVVomvDEeTTP8m1MzdntphwjJEn8Qf+gW6tTTg97uPxn1bsgC6JlTzYLBLl3lBgV4ZoJczYFqeQhix1ooKoQw64vY1/HIGu/RLKZgXH16x+3mnnvqdCfXer7eA9oILmPlKFnCIvdA5CUmqcPh1uSxlmgsDGf4aORTj0SJ/dRpGEqUUSKFVNBNGrTxraJ+mbC/vb/1FoO35+nOwDQZ3SqYSUSvn11y4fwoS56kYFhVUohSLWN3GOfYKDIQ3047794Oa16q1zw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386536; bh=pbKP7c4pKCATgiLZO5dCoEuBFGn3ODDBqYQWJLbu9cS=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=AKV8qrTn73DgynDukQzpJculZ/jLGDHSPL5rXSEzV9ZLMCGa0vGyXgFL2p57z0Eq9a5MLde1ZsmprV5/QfJA4Ch6KWOLrb75Fxvl2oJUt6YAM8/BFQfVF+5mP2ZWhkHOG4NfWuPROvYsHuT3Wbxv2p3m1u78XdquoGgKDKueQEYoG0azUqeNtiwt3CUh8kxIXOHVsW3VcH/XA+uYO9Vne33l9MtYuupIEKKG4Hlod6SKOahCKEwyqh1/FUMRXpoBMD4U9Fy+qJd8T1LVOCVzzSu853Y52SCrXV8/TBJULfUWbO2q/a8Jh6QQ7P23bmaAUVHm4lD58NTpgzstXO2XXw==
X-YMail-OSG: tSZpOnMVM1nOASBlswu3fDZ9aNHeGbodvoFoL5t.XShWlr79by912Z9GmmfgOH8
 Tl9CNaegwIIwY7QDI3HK2rkeFUi7aNlKk_aDWbaHV3UH_IPr4aYqs342I8AM4pY7y7WVt6ssBJP3
 9smzBG6H5hWVcKrvFw0_wjk2T84w_7h328MhcIqQyf1ORMmlY2BtZ70__92YKXHDd9GxW7jpe1OO
 BlH_fwrPHvgBAoTn1Qi9r3CCiwP_dUUGOrtiCOmOc5LvxZ0UBiw3Ws0LQ_loHd6fAEO881I00Xoa
 K1WYFXPV.sZ3iNlpZpQuQI8t0FLsV4fo9J0kwtIwidm3sRjWCmWhuXe3o7hy_rfqLTHeTGKZjPGL
 oiPmGzFkadeqKosS8eKmoHX_3N..rWgB3KCm_X2GglfbrWaCcHKapas1Zy_aF9SVat2d2btV2sIp
 8fcktunM.p4.Ys6bkZn5o_u9xWiVtkpA6Cza27rgoCG9zYAmJdxby_0Twfc1QNmllm_gXVX1KBrA
 Ml0ybD1WmifGK9cJ3ELCGwGnoI45qRZ9uKCYTXnWkXrwA9r8kZQkc9e5O2OU6V810ALSi4ITiwRD
 YU88UX95kHhQAZxhy76GbbZ6HtIwojJEd5o1j0GKvsdbrFOL2hqtcSWlMYcASBA5bvFg0Cqc9SR8
 rwdmNHg3WDCtk5E65hmt_bChS2b0eTqcCBzPFqg61jlayRNLbnalyLNogbSrllD._Tm2ffO0AQCL
 xu5vU.1hCX1AhWfXtATQuGqrCN_QXw7.h_Vl8NQVkSqrXDhdtEWVdXTCFRcVD2vhtmlQCv7t813Z
 EI26pLBntJx1lepGS0N0LQyVfQ1712vMAmFATqnv1dKGeJcazFyHACP9LMDtAN0yk0XecMLPH0X3
 GxCr4Zex92ffY05vCoUSwj_JTc.aQpFWwnSJKGBkoj12wjOPF1qMnuJdX.lH489k4VBon24fyk8C
 b.jj_7W9cAC6yMzBuzwikwrsIhAFrUin2.KfA9wFAwwUtcZLEC8Z_iN6vhdwD_tN9mLq6cOZn6bM
 bsvhvxo6Xn0HN6u3_2uH7hPme5wkyWiuk58t8m2GjkiEBv6X3y4A826jdLQKck7qaFxlR8Bk5PDW
 ktJlb22TBauYcNwmQ5_nNjSq1DqSpWulnfh510feFnI5ITFafHWWwL7dhSVvM9im6sgiAjUgo4Jy
 Q853h5afwcbZcN.XozVXA_kDHEFw1RBafZD8zssb1LOc6XBOlR7d8ugdCDj4AEMcdDpPtXHzOVrk
 .Pyn7qFYw2Fm2oQ2JYtyaKxvRQwdRM6hr7_jipMr728XeAtBwRj2GFEGqw2B4lwdb_vzmlAh1HRQ
 5s7O6K5DFmPX8EzQ1pWfNm01f0NkuzKk8cs_4LqPIhkeaTJGmh8V2X7SofoyDg4q7YzU9n3MxGRJ
 IgHcvL4ohhwzmBKhCYu7w7S5IWM8AA2mJOkHg1A6QHS8RmX0ApRfHjwoaqPiY05PE105Etre3SMK
 ebZjC.gQUP6L8F4bE8Qo.anlWY.4BlOK3_.OOZuSn0ZIpWttG3mY8gt.SvWbU76LY14Vq3P4ILNY
 gCcN4Y5M88Ic9yNydUaNo3LoTYzqLGEKm_HcVLgnSRH_c5Pn4BT1S.rjO60M5PQhBIVjIwyTfPF6
 B6Ty9gumh1jss0cft8zMCCKaOU7WPpAoQ1FNUzUHqLPnuRGhUBCviM8QqHfKIRcw0Zah5q_fw7np
 qIm_nOCqGr_VdDgZlPdmQl5mdukM_AO7HVRv2fGMT1F_vlFNKMcCttVmVAjo5PFSKmXuN4TCw1.a
 x8fc915p9opheeJSzJbnMVvWCxMJVPrnaNqnyyc2NOa1MM7KGjseb2vyk3DMGOgkOJrEARXxe4Be
 VmTewE_bQ6ucJlHMW7u57wgyf3FGzAC0sVU18koNg5UiOX3pMOR_QaviCiRuwTSY3W5xM4OTZ4dz
 8ygz7mmeFrbr1EbFOGr_sDeY_m27ZOFHDEi0FSbmDO3j5FZIpM6XdK03TxL6y15DDsbeIaLK8bs4
 nFH0ylHebIZHlxFQjU8GzEv3i_seLXX2K6S_Tt2o9Jz1PJc9sPuJWHmKF4vM8G4ghQdnb.RZXorc
 liBJHvvHIbvcAzvamOL9m7bateb4rEK_CWBEjXesWdYxw4ny_tOlvRVuuVpZIyOq_34XiSwqWX2R
 lhWOSHpAoYCJLTkZL.7HmIS4Z7V82KuNpFTVbg7uTamGT.lOjdn3qq_Dv2thAI7V_mtNtBaiN3Og
 jcI98uYgNtZO8Ln6TBZWEo64iNovGSl7sT7GRQRK3pUAHJF96NTngZo.WoiMJ8nPgC5clgYX6wK.
 OOfGKWKmOQScvqPJYOMQj6Hg-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: cb6e4167-4664-4d7a-be4d-8ab0e8369463
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:16 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:12 +0000 (UTC)
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
Subject: [PATCH v2 6/7] Apparmor: hooks for secctx_to_lsmprop and update_lsmprop
Date: Wed,  2 Sep 2026 15:01:49 -0700
Message-ID: <20260902220150.18586-7-casey@schaufler-ca.com>
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

