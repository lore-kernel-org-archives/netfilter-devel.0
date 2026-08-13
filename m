Received: from sonic312-30.consmr.mail.ne1.yahoo.com (sonic312-30.consmr.mail.ne1.yahoo.com [66.163.191.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BE736C582
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.191.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654160; cv=none; b=ro82uoGcBxVfi5YVz0gjuihLNYe/qFZIwq1B07yxfuSN0gvuv51mozEezW+UKHqq6Q/Dxt+n5bq0I1goYs62sHxaTY9dILrivVXm38LoP80wya9JN7pWOzB+0releUC2VLUPhunjowfr72Rm4/rJoc5/+WbSozqp50c14UMKVfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654160; c=relaxed/simple;
	bh=dgCnGtDWunupJVBmMDbBgaAex+j+MWb7sztonDRNoKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVV2b13JxQMs1JAXCHoDjk5GvXmzIz2nGRVAsE+ODbpitumZjWr1vJZYqZpXAF8ycTnPgn7qA2ft/uUgX016XT2tXXZ7Fi9HZK4WFLSSMBpkJQTSMM9D4aHAfNZoEhL3utjGd5eePiPN0bi7Unkt/TCwic4GVNHCGF94Y0xo/po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=pCvLWvKz; arc=none smtp.client-ip=66.163.191.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="pCvLWvKz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654157; bh=4jgSYkvNqJAotmJA9U70wuCpNvKAtOU4Q7SDLp3QXXs=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=pCvLWvKzJ4wOxYW2cxJqQR3vdumArbBVP4q/PYiKDdSkwC0qNT9ytKtpMokTYf6oy288+YrYyVnGZ82OsL+ZIVlsMiw3dJqwE6BOafy/bX6rwTwYxBxHS1R8ZFEo6jnTMmKl1QfuvfQXpam9r5V4pEUvWqQjIZz5WTezIB8hWjRS01ojYj7mjtbG3eLBXH//WJDfHrHnOo347YRCNjONziO6Ol+ury6rP21xRUBbWD3bhdGIbvbttxdFmxWxtK69ewxGNwXePI7N/RLiiqNoG1gI8d8ZCYRc70sXg3s6cI9k4KP8aflWCuS9/j+Av5DKVJAJ+8Z1dNIxBGsHloDYYA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654157; bh=5mjeRZJsPe++HzLLeJLHExlsYFMKWa4ouHmCCD1fkWs=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=MG8vOSeAkGiuSoHpeLFdP7G9k9AH8ZH6Zm8GYQNxdHAf/QdEa9n8DbkHGWsKnwzh529BcUH8gHiDN86DKpoT9+uHsVtyqEVcdBI20olnsJlHFymWf66dOHxAZkWE2Y3+sYx3WihOCx4fooS06pQ9cEikzyWArJKVmUPLZRMIoKyr5rT91N0DpXixuF4BRQGpAoVOVSJHD8818+wZWU7WH+qMR+rPGqso5J1kjzJVPkNUnKYIzw3Oko7e42uMhx0+6xx3zQM9MObIGa6/uVhv6ql1yD25Ceyd8eyCAt0QoeNuayC4s+jp4P3LV356i5nViLujxBxhelsx6onFAWL97A==
X-YMail-OSG: iLY3fV8VM1k.C1pPxnRkLGfTCYok4KBkR64wivAixl12.NkvjZ6OvaaKFatdxjB
 GYdlGqO0RqEj0cOy8SFLdPEps9nVHJNCpJY_BjtdDEP33_MFXSp2IJQAb.4WWnpavMyanmCmM63X
 y50GIwgOHPnxEmraSzfiyX8U_lZE7bI8AOcXqqbFqGb_Y3Du3gVf6jtiuiE7CBuTQZTrYf5CmavT
 AnORPWSNAYE_ChjqER7rOBFDHuQUC.5xeEnd2Fl261Fg9199V84RD2k360EzuOoQ3nNw8DVK3DVy
 10bIRk996_w1md4wdpw2Iyv7EwFxFmQHBE.xUVi_BZkKIt.36S9c52rBj4h4y6..e3f2zt4tG2nb
 eG0LYcEzRwQZ.dseBHvIFW2A8B1r0ojd6Ive8VS.JbsYGqSPPS7W8xYdi6GoeZb1dwnnqcBi2wu1
 H2fU5UawPxA7VuxEEd95x4_JIgnqvhlhOizwp04kPeJQN7YErl4U6hr42hyF6D6Ckci5f9e9tS62
 Ueg7XAvMjxXP4AIBcVXA.h9NswC2lFucOEZGoifiYqKcQ0Zv2WM.1NrkbmGCgsLUi9ZrX_jxd9uz
 9YtnwPt1v4ILsUkuXSBn3qMxVleZgaB.S.ZQU5r2ieWliRx0KMXE0Wtvq.jx8LFKdGi.15dOxYrl
 3FA7RlJf2AYVSJqioVuzQf9DLjRT5xI7B4LlykRPiT9yI4OuF2cQZn8cGmjj1tY_ljWj9SEROymw
 cxS3mS682Ly73JCJDAn7Byz2cWL0GEJlaKdKUD.Gjnpn7Ki0AOzLKAX.M_LPdF.ROd3ZwU8jUCoG
 uetiKTxBYCUG0oQquSXasgYX_PkwuKnlLy2VIhRo0P2lUcTThok2JscRAfCvPVvcJlPNN.dzmI50
 2c9djM1hZPTN_brninaJB8UMWPVM.iKiZb_fOTg.7jJf8QeKiBSQbsu8ao3G1bsOXg4rMEazf.Sa
 ZBvA3oUtj.iG9NMZLCG8gm4qH4f942UdY7jOPZ5wwRJiWqwM5MHGKDTG3QJVvwQWgMo.AoolGgTh
 cBgmMfDHY4SZpMFjhhrOK6HD2h9NiCD7WD2jx05rhfz5LlonzIn6EHJ316QdVmkRkl.Eo6_Oqicy
 RmwpTeVHePIlIBpAh..YvYYRveTRPO3imjVLauB0L12qu4jVkBE4f723Zxr8E7TNUVCuR6kXVJ5V
 kODHRV72jHV8hnv_oJ1L_kPgtbaCOMYdd9mRPbkp9GrwcIboRX16UtkpUjaP8ZjQa2r_JvwQwof.
 EMpsarY2s85D1LPdsKbWFx1WbEFtbVaKvikpbdsVSMGBO24Ij6HzcQuiCW1HhTvfDqJ2jaEPPYCW
 Lo.J8wL_QQ6LkCSyXvuopeUKoPY_ne6u9aTJArtl8EoURrDo.hdUPJiZ2r49M_NPj1HAB4ns3HhL
 riOKnygrjXn0byQjS0sr_oU74k0FjCo6e8EO9au1wtNr3Pq.1NHKC0CKM7ei8m.NTuk3f7v3P.WE
 GvB0Ujn.7Lkw7JtldPWjVPltuoJttPAE9YoJT8n4jM4VkNLFKh0rfXWDPm2jbFL6CtEaLxsqmDSf
 ZWoF13zovNgmmjBgDW02ixxSM8ca0JxM.M35KpqAj9kptnIkYrzLmyTHujQRQWkBKic9OPTiK.iC
 TTQMdz1hUtVJ5qHnX5ESuurHUtr9W1i0VJupyGI0hMMdRK6Guvzg6iD4n9SjEhad0D9Oxz9LYBvp
 5FpGwvYZrpKzKd9rDZgtDLqJTSV4OxLoRwp7EiMQXqJKofPVUvVHWQHthbASstTT0u3zDVTD_3fE
 Yj__7BZb52iI_i7XIq4niRxXmON_kNBIOMAzFHdRvn88LXbwFhe.8nj_zBjtyUPRqjjAQv3plKvR
 QyZnnZ3DhR122vwVQ5S37dLi3eAPnERIZ5tLSEvnQ.145BbR.GVMgQV51_LDRlKonjSqBWSJ5VEh
 dEvoPyaDbwmaA5dgK9yXbLCfUKYGgt_WqDfYgMSQtxWs8rMq7sbLv2fdvuDx0Uuwh_V5_MgQjtgC
 lZ9.B.tYm6xz4gZGopaDB1d9DQcZYevE6g6cb00a3ghLTPE0DjAVJoZY2IuR67DKV6zJAAQlgHE7
 gi9L_4lpWfw3KuRgCDubNOIvHePnWWF8cKxTljwminRdwtRb3g4nLYP5B_xVEb10Ua7.rk.pinni
 NSEBsjd2zZaJygt52SPBbT3YDHo9ldsebxoYbDiufK2AQJ2CvpgSNIyMdtoeLsFCw0uh1WaXQjqe
 RVPi.mF9AwsNi0VTKRLRjfX1X0HvFm4X3tCLBJQ_CrMGi.486RZk-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 3b115120-30a8-487d-b45f-93ffb3cc9c5e
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:49:17 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:15 +0000 (UTC)
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
Subject: [PATCH 5/7] Smack: hooks for secctx_to_lsmprop and update_lsmprop
Date: Thu, 13 Aug 2026 13:48:52 -0700
Message-ID: <20260813204854.19211-6-casey@schaufler-ca.com>
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
 security/smack/smack_lsm.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ff115068c5c0..8e3ab61dfdd9 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4909,6 +4909,40 @@ static int smack_lsmprop_to_secctx(struct lsm_prop *prop,
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
+ * Returns 0.
+ */
+static int smack_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+				int lsmid)
+{
+	if (lsmid == LSM_ID_SMACK || lsmid == LSM_ID_UNDEF)
+		dest->smack.skp = src->smack.skp;
+
+	return 0;
+}
+
 /**
  * smack_secctx_to_secid - return the secid for a smack label
  * @secdata: smack label
@@ -5269,6 +5303,8 @@ static struct security_hook_list smack_hooks[] __ro_after_init = {
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

