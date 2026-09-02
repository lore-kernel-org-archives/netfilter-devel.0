Received: from sonic307-16.consmr.mail.ne1.yahoo.com (sonic307-16.consmr.mail.ne1.yahoo.com [66.163.190.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9498B44A3EE
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386545; cv=none; b=oi/B7Kbmips2XC5vX8uPZRiz7VlsGF8XWJtX41qBXgTrbu9FVHxYyHUsg474jvB2n2r5wJ4DkUPKyPFsFrYIFSxMvlMO4l3CT+oiDf+cfAc27ion5Py3SorikiFuwE6GUbr5SyBWZK2PVIfixOoFjTVARO2bAQsYc2HRIYjnExM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386545; c=relaxed/simple;
	bh=l5xZJq7SJIQbEKIdMk/8CyU82z95S13RHM4M5HNEOB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUNPUoMeZenJgaQOUJLUk5aNarEN1SSMOkw2czdY5x0q3yoHr4CL2p1C8jQUrbQXAkIjv8sudnhfpzWRNlP82+h+0cPG49RhH/lHA5MOGOnYOyRC0Q4pO5Xo0nkHnEfQerxlCpbPBniPfBBWIENhybel2zWzfhrg3fUTOohKHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=um3r++hs; arc=none smtp.client-ip=66.163.190.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="um3r++hs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386532; bh=spL1TCRGv1nTSaQv5qslf2f6hMhi+lllz41KcBPUl+Y=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=um3r++hsjViMIWBa1PLlvtzqpRBPt4Xhl0SxhAnKNZzY/SBvEO8K+Ha1Ik69CC0RFeCbFnkAb0fhEgGtsbpWk0n/XX62j35ljo1XBqYu8RwuTp0kBSGL8foRi7Xo6tHIHq8gmIXPin//0a/vrmIYcyXsGOUDStiORN5ZyzeQcbD7/hEL3EX+2NhaYr//0D6pIOqFSKX9EaD3KUFV/pg1XFUVuQ8pm1v8ZjKKcoD7YpYb6lxuggZpI+R9jUx/NvG2qgFBad9yn01ZgaABC/i5rvgpWkuI+V6k/ACoVyRaYyLtOFtn73FRIG2VsGOFC0UQx7WDsBb3RV59ryK+n3TNPg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386532; bh=cN8ShmoxI65yHmoLfLBAylj5tbyZqwDoT/tXDnNMj2I=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=DtJECu6/vxMXIKvJIYpn3NLOrlQBWAuNwAj08tnpw+Cwh5CWEWv8Me2OJ80defG8tdF5XXmw4aoyX/NsraJmSPGsBAusfWYEhHXoT4piMBJPcRWWjUi1C9DB9fw8WDelyp1wIIYipl3ow872zgS2Wq/Uv14sHmAL6mojriq9U0EV4sZ3GKOVhkXXmchZc4T619SF9zU9K2ZHalfImLbmq1MM2bqx9xexQmQaqoB3NCmIDadfyVbybncJ/QAz3vkMpA+j3j1YHIzIDN+DGFrF1DxlT7D/Bb1RWYEO4TJMrSyjjaTOf82+G1oi2dyGVELL8oxeDaKVB2LHdfd+xh2QNQ==
X-YMail-OSG: YDLfpBIVM1kCJ26EXAcrQeFbqcJn86F6QOTVHA.A1Ks87lZCc2cyUwuSyeGQf5i
 uDKPNeDeGdeusHC_m4h7XgFFL9wtqCoIhi3wPL_sh8y59PwlKzaKG_.Ktf97.WQaoOFroXVOQnPg
 n.OhLzKdr8UDKCGALzz4uB7YMd9j3R7TOTMFsz9F6swUm1FWNwxQUO5gMNTe7_45ivPQGTyNJu2q
 bwQkhsBy9ykRb4LBtExTDo3eJA4pcK8KG_EEB3DekRlW965mh84qCc68p5r1rnidtNwE6MMcMQtP
 uz9_ZW6bkE8x8np2eAHc6mjpqme2mshLbGRFCZ0.Ph38XGct1lRQOMFUcPOw5EX3EKY5OCEisaXi
 4C8fWC8NY7Y5Gj_tEV8xX1x44d32MhLP.ShG_RG1VVuVCbORJIFPBG9n2LFyKnRTXO5wVs1vzLRJ
 sNKfccfWSNbEtC4YodvQjblwMmmC2OInTm6VMEXoJvck4YBtGklIQvfbZ_j5CK_znmDstEN30PWF
 EPEG.Zg4hCYmM_rUyrI8KocULz1bMHS5dflWfyJD2WO9kPuhVlAZxrT2w5KUC7F9AMUfTLctEBK_
 9r8CKa.fXurYVGkW827MQO6thjZ7nUrRB1.Z.IA5BJzcMKePub0gJ4D_L.PckkEU.WfLqFGRC_BQ
 O89c4zcCCUd.MvUzDYcqgZPNiTUbzk33IQi7jE7bwq04ZE7Lju3Bq_CY0B31_XZlcl8J0MtC6df6
 u2Q1Ovds8emd4qXBGKKk2sFeFH.bUsX0W9topRLmrnXS.ZpciWMFBB0XXzoD8Didirmo8xTiMI8D
 Gmhjsb2OPja8RKgxhWI2BnY6D5uxnWO0.htTmVoewTjleMJL_3STCRHmbMxi.HD52wYdn0GXulw4
 3fryMkeOVIKxipuLc2iCg_B0hyyPfUP4MeM5OCxhZ4dtL.dQCDk1LkOz2oqZBpGPPX3DpOObm1pa
 L0Vu5B3hjyjjv1iDlKq1W50hgYMsAC01vBs0i4GMhvbDXTzyiPKuwTONjAxbOpmwOfTSjAjlobgM
 ZwYuZ3fRrsbONbHwPS0ybZxYQeS2dA2IoQi0JK9L2_Gwu0fE5vfCpbAhPXPc5WAF15wiuctkpvf1
 _f01aOjRJbHswXY5z0sACdTEFPUGmioSnlk3jPu4oUccbu8Ihg9p_rlwJEFDFgmZZMjJUdGwx5pd
 dNEiCaOnhuXIuXbT5GclH_w18Vq6KDGrhixTxvdESivJl.iRrV4SCvPrJmsP2a.ribw4bfV9NuG5
 24sqZmRvqMWBPXeJnvSE0N.Moqvsnk14_0v6mbtPvOgjEyxFJDyFEZKwYQ5B5jMgm.399TQWAGKe
 MQq8qv3whpvxYW28OSz7BM3Vh0mr7dp9TsqV8K5DYhWjphuvzNGj44ILyDNkz_Sc2tZYo_BX3L3J
 MyJAU9ru4LEEYQFCzUVrGF.cOIK2weMgPRuXgNd6MuPZhOOzDcFAKyPo24ZYJsTifIRL.766x_G.
 wkwD.E_AZnkv4Fpc0y9OPCY_mTDBdrndQ5oS51ukPQRJd7TG7ptpvyG7Or9AdKlfnGMMfGD44fCb
 Q9bQmLtDc84LptpfpnQK1ueXzTlpcLPKGrTEL6pEkv0nGYdRXIjm0sE2wM9kF7IH1MI0bGhOZKUS
 __AwlVP2YnZ85bbAljRD5sie.FPbfiOne2G_Nm2X570Ik6fRPCW7PC0eivXvjhIS1SinaJkZAjRp
 m.VxvAbgSZRMA_zQOH1sfQpC2VvHrbBoxqGt8yY72.x5qOeG.UOlVxspeio3MJroruRl79sRVH_B
 xL8oyCzTuyMz8YNLvvsluGpZP0vPWQXDIex1s0emR8U3e1oGfkpP.gQa32kiqxZCKv.DaHIKowhD
 OtJgRbwzE9waSqxYhceh6GjSbx0tNwKazn47xbtXZLLLDbxWZFgfbl_KNDnMKGQKv66B7cvEMKHw
 D_Ujz52aIOEb8xdFynIo6Cq.VBM_pTcQoeA9NIo9mUWdlnrcI0hE53i6mIr_T.TV4aJyJLpPNbLc
 JHyTp91XTYPhEgIlnscQ0Lv1mv4VinAzsnuYAjgLdVgzD2bXLnxDI4NfWqroqnnXAA.NvDy8tLIL
 _V7ugqLvKQqaJQ3YP2r.dQRjpnshhsiAPD1WbfY0atMKDOugFu6pJ8uA7QsVvLDJhO2Me9JfRUvB
 k0TQql4aPDbOsb27ULGpK5gFRhcMqb0Xu9dqBzZW1hmnvvX.rh2Dz55ozOCWxUZgW4Urmw_2t3Jo
 lVVOtm724fokJuvIz1TEH8K2g91z3u8ImdPsWdV_Pav9BinAQhtO73B9UF4Dg.CiT2xoxwP1Yuj7
 lsfColH9X8xrh7mz.KJFGek8-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 509315b0-4d28-4580-b516-88fab8e69a45
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:12 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:11 +0000 (UTC)
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
Subject: [PATCH v2 5/7] Smack: hooks for secctx_to_lsmprop and update_lsmprop
Date: Wed,  2 Sep 2026 15:01:48 -0700
Message-ID: <20260902220150.18586-6-casey@schaufler-ca.com>
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
 security/smack/smack_lsm.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ff115068c5c0..fcfadd5d9994 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4909,6 +4909,37 @@ static int smack_lsmprop_to_secctx(struct lsm_prop *prop,
 	return smack_to_secctx(prop->smack.skp, cp);
 }
 
+/**
+ * smack_secctx_to_lsmprop - add the smack label to an lsmprop
+ * @secdata: smack label
+ * @seclen: how long label is
+ * @prop: where to put the result
+ *
+ * Exists for audit and networking code.
+ */
+static int smack_secctx_to_lsmprop(const char *secdata, u32 seclen,
+				   struct lsm_prop *prop)
+{
+	prop->smack.skp = smk_find_entry(secdata);
+
+	return 0;
+}
+
+/**
+ * smack_update_lsmprop - set the smack label in an lsmprop
+ * @dest: destination properties
+ * @src: source properties
+ * @lsmid: which LSM is relevant.
+ *
+ * Set the Smack entry in the @dest if appropriate.
+ */
+static void smack_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+				 int lsmid)
+{
+	if (lsmid == LSM_ID_SMACK || lsmid == LSM_ID_UNDEF)
+		dest->smack.skp = src->smack.skp;
+}
+
 /**
  * smack_secctx_to_secid - return the secid for a smack label
  * @secdata: smack label
@@ -5269,6 +5300,8 @@ static struct security_hook_list smack_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(secid_to_secctx, smack_secid_to_secctx),
 	LSM_HOOK_INIT(lsmprop_to_secctx, smack_lsmprop_to_secctx),
 	LSM_HOOK_INIT(secctx_to_secid, smack_secctx_to_secid),
+	LSM_HOOK_INIT(secctx_to_lsmprop, smack_secctx_to_lsmprop),
+	LSM_HOOK_INIT(update_lsmprop, smack_update_lsmprop),
 	LSM_HOOK_INIT(inode_notifysecctx, smack_inode_notifysecctx),
 	LSM_HOOK_INIT(inode_setsecctx, smack_inode_setsecctx),
 	LSM_HOOK_INIT(inode_getsecctx, smack_inode_getsecctx),
-- 
2.54.0

