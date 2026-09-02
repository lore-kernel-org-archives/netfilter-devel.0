Received: from sonic310-31.consmr.mail.ne1.yahoo.com (sonic310-31.consmr.mail.ne1.yahoo.com [66.163.186.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085604A8FF2
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Sep 2026 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.186.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788386545; cv=none; b=J2hrhifok54t87sVFc5H3U1BB/RqYKkgD84P+4X35i+luvptJrLp5u6uEbNZhqscz4zU+Ag38UOh1mWZusHds+Ionoq7s6IrTo1vSmhqUJje0c433ZfYTRUGdQeX/VrfDEA9o/VCjEMGQMD5ddWdDgYOBHKDjzmrOLmuyOBWT94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788386545; c=relaxed/simple;
	bh=d4zY/ltnmjXjcN3r0DfckvWNHNEg/g2aMa3mQiZA4Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hdd5nNAL49jxxr7HaJdyl9ciHDG3SzZYO9yIAM9GamhRGplsTu110GNszDhj6CtE+dMOPNhj8jFIHqS7oP//sm+YQMjktItVh+b98ABmU2rl69JJf6p5tEyJzBP6w1UJVQqyk5u+YmukFTxSHQjhClB24bQXfR2Hht+GzANjbq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=ayYjjUm3; arc=none smtp.client-ip=66.163.186.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="ayYjjUm3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386531; bh=8t0OQ77yaNOPEWl7EKKJc1q7r/apIJtz5Yj4MAKBYDo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=ayYjjUm3K9ScfXOuxOosgAX46Dfz6naQzuvQ88T3VuaSpc6rcUu24JJgKl73rnS1QwExgmy1uoXNhhJG5U6mMNRiYF9KN42CGGmpfEimqlKl8mIDpm4SXsZ0KMom17xWMW+8EVrwkkrJLXEXiHr4c5P3KaxPPkQ1TQ5hq3E/YX+5M2VD3PKmVkSwL/Npvii+bAXlNjyFTZFCwzGYSvzduRZ3GoeaUlOMRKgn0E4QozGU07YMCVyao35BofrD8JSIgEIuXxa0WVhiPNlHGfsLr06/glP/kmIC0xQb2ulH1C38MHCwHogyj7COl04u2gpzlx3R7iHgbeDe4YmjhaokDA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1788386531; bh=knvcAXfkU4H8ZRFZFMIhTAp6m6xqNExa9Vl42w+n/Ee=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=JJEepLfC1v5C3SFmSrC3opxP+FHWEp23W63g8LVsvEvImyI6VYW/TAVvnUUpuYD5o+IiqJ373tYMv+FuUUPxPieCgj+mzhAJtfRN1pdUV5+vIsk1sG77AB9a8fT63H1s//WvhpsxyC3srcP5hXxhtRyR9W1xrKPz3ztyllo74fDV5KltwE1N4Hqbnlaol1SToZtyIoR8Jpun+iDsE4Flqi+qux2UTivB4hkbK9/7fDHXSC3vb6aY3+8g+QJVHz89/n0nPtKRMsaJxsVOog0+kZpkQVmscbFRJUfdFkNtuSSzLVWhQqPreEwt76CropqArjjIALavvZvPW5DMI5QcEQ==
X-YMail-OSG: d_zXfyEVM1lG_lj8xgjQEXV.a4t3xiKEfxGWK8IYdZ7zAOGKvhQRo_GYqZks2x3
 VcliSYvjEE7vjuHZJ97QtG6vuRYAi40s_Fo6pa_K67qFC.RBAx_CFogMAAXC6McT34U3f31B1vio
 VGMiUS6QKlLQ4rQek5XcrKI2A2kyxD4K680KEyRzFjhgByhFpAHnZ3FWMhd5CnuHehL8PgQtSIGG
 e.Y9.fn43dxLm3hxQISJv3vJzGlnrAgB3.seaArncXCNpnX4DpQm5cww86XqE7wrj1AjqVt1mC.8
 sJkjjZRzxTX53tygrHNcX3wkSlm8fQjKmacOXnJHb8MzzsP6A6xj0Qs5k8zLFXhzP2lUudr3jiMk
 Ao3Q1.cQ32nq3bGIFYAH3wGFQUSj4NDA3Zg184hKOQNU06whD9XKoNtEYQkNOwjyygS2WzadzR.2
 YpQIN_Mv.EmY2H5OtQVVJ2fqEtsZ1Zpczb1QAocL7ndy6DDVs1YeCiUHdll6uVoL_gfzvRyJFeVp
 FGFv9AtbU7dy5jiZZkzG_vnFh1w6ijzTqq6GEhmYRa8JGEU.VPd20iRvG1Y0g8LNKfkEQIJAeGd3
 f2aGcjvJ.Ff884pLZkEalfVqM7Cw9HkbZS8aNX0lHlFIwgmlS1z7Ws.mmKoTH3EnDNHnX630asyE
 NCbnpwUp5f5ZSxiQXTMZ4tt3HHs1ibsaVODygv2LF4su4Q_Y9Wc2BARZfnHhxM5vTKrgKLe.VyTZ
 qnHcXsuM1MX_sQ6FClMjkM5awSGoGYnxW0Kayq8SyQeDrweGzFYBGc74ohpbpNBdRGPyatL1.REr
 AIZwHsIyVD3xPEmv83P8iHZTL5O3XvmROf6DhFwZMETrcEW0EOhiPUSbMp5Rv2_HOxyYLxrIaZv5
 KHLvmt1h.OoPBEorGUDzfuVZiIZt7BTRJ_.RYPcddq5IIk6LsAq5E8rdp9JaxmKvYODkX1B11K0Z
 PbrfEjhM4mh4kOaVF_2qpbDmSleRNRtexln3PYavbqKfQlugqZGfaVEXCzNN72rUFSgQzxn7qNFK
 dRZzQzJ_Z1_517dWkHgiYeqgwujietgcWGbLw9HttbRQn61hF2ZVG8VVDnlZr_sAc6pPbS.ldYnD
 AIuWALxP6WA0qqBlAEINr_EFx0UvecyffBLaTjR73R8EGOgVxOkLdt52fkvJoQ4ycvpIq.VPZSDP
 TRch44CVAiTKGKhImMSMKuQGv_NtmPXn_Tcr15_sit5vkDfrNAQmB5I5gCAaDoEKmKENGkfGwBUm
 PX5.0bgRey.o_pp_zno9FCwXR7h7UMpmWpnna41jLGqd2AupFCeE.9aFLqRkqe9OdNzXSUmLlI9U
 3TDAbecGYq3ZTBIqWV.oCjVUbu6lfkMK2v1XoFbGKczf_nmpgdoYhOLYnmEyGYwivdMZswsE4FKw
 BOPog7nKxAy15JdBAQSjLECj5oHIpThdijG2IbBdFjHnkYXKJ5bxBEx0Xyx2R9BENhrsoCfNMClF
 uzyr2jHD9.diFzDN0faLkXgbQTmZAimh8HtER4_BRrG74gKVIRpWVNQNW24iJDn42zr2doHfQiKS
 yExryH.9PpOPGpMTEAvcEV.JjNVCr0JkeXdR914vX6qlOsW8.oW2laYXHGGMFJmJqLk8aoLPX.36
 1T7ePWmOYT5XLaaFjRkGlbvn8uw59hBGj56mfBX_hGbt0.zztVil2Qe.9znG9LtrICV.n3FJ4xKB
 alI7NCF3M10lUAGtTpfJnLOILQ2bCYCaOv9FLfWn6obZ2gn8deL5.Fr9opLDC1lKAGAPjDl0JcRe
 Sgabmqtm2JTeMNheoTFsKZRbPDiuDXSpImzzrjfgZxUZtUa0DhEYH.w.iRyP8iE4.rQA620chCku
 d4bJ5TplxTzfuFOjLrWg.YeoX6qFhq9V4XR2.xIMphpC1szI.Wyw30_7X1DVJNODh47k3_uvUXdr
 ZDBalU_YxgWagjapyUbBaJKXkSb_ak67DOis.Zk1YBLz2th0VaWcAVGIsnnMqs.oc3gm8JBhaaCH
 ATL046fTOhpFXrJz2Y5kw2h0xi2jQAQS4VYAM1FGeyLO_f9lAmxl3dcM9zb1acg4V7kPuGf4WxEm
 c3x6ZnMmMmgpv0RpMyNG73GfpmQG4o_iRzXL3tE8nl4QebB7EFzYr2aZY_.jLwF41cX68cKXUoDH
 LrrfH2QOmMxijLzZ.PCl9YbB_mPLjGNq3SPVwJZSwPWyAb0dWIXFzpPnPcFUI_ytwQGLISEFV2lx
 _KP6Wvy2zYbr9Zfz.Y_3AsWvzAHyHOCawXAqkj1jGE0Qf0hWOEtjYTnKQYcastNqLZ6CVwu3RQVY
 VfVLwCvhl1hKafqDOSwvSXIIR
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: f774f129-ab3a-474e-bda9-a787c86b58a7
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Wed, 2 Sep 2026 22:02:11 +0000
Received: by hermes--production-gq1-678d9dd684-dljdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 39a905a7360d4d1389754a332443770a;
          Wed, 02 Sep 2026 22:02:10 +0000 (UTC)
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
Subject: [PATCH v2 4/7] SELinux: hooks for secctx_to_lsmprop and update_lsmprop
Date: Wed,  2 Sep 2026 15:01:47 -0700
Message-ID: <20260902220150.18586-5-casey@schaufler-ca.com>
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
 security/selinux/hooks.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 18dd28b2bb13..12614478b638 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6946,6 +6946,13 @@ static int selinux_ismaclabel(const char *name)
 	return (strcmp(name, XATTR_SELINUX_SUFFIX) == 0);
 }
 
+static void selinux_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+				   int lsmid)
+{
+	if (lsmid == LSM_ID_SELINUX || lsmid == LSM_ID_UNDEF)
+		dest->selinux.secid = src->selinux.secid;
+}
+
 static int selinux_secid_to_secctx(u32 secid, struct lsm_context *cp)
 {
 	u32 seclen;
@@ -6964,6 +6971,13 @@ static int selinux_secid_to_secctx(u32 secid, struct lsm_context *cp)
 	return seclen;
 }
 
+static int selinux_secctx_to_lsmprop(const char *secdata, u32 seclen,
+				     struct lsm_prop *prop)
+{
+	return security_context_to_sid(secdata, seclen, &prop->selinux.secid,
+				       GFP_KERNEL);
+}
+
 static int selinux_lsmprop_to_secctx(struct lsm_prop *prop,
 				     struct lsm_context *cp)
 {
@@ -7694,6 +7708,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 
 	LSM_HOOK_INIT(ismaclabel, selinux_ismaclabel),
 	LSM_HOOK_INIT(secctx_to_secid, selinux_secctx_to_secid),
+	LSM_HOOK_INIT(secctx_to_lsmprop, selinux_secctx_to_lsmprop),
 	LSM_HOOK_INIT(release_secctx, selinux_release_secctx),
 	LSM_HOOK_INIT(inode_invalidate_secctx, selinux_inode_invalidate_secctx),
 	LSM_HOOK_INIT(inode_notifysecctx, selinux_inode_notifysecctx),
@@ -7812,6 +7827,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(sem_alloc_security, selinux_sem_alloc_security),
 	LSM_HOOK_INIT(secid_to_secctx, selinux_secid_to_secctx),
 	LSM_HOOK_INIT(lsmprop_to_secctx, selinux_lsmprop_to_secctx),
+	LSM_HOOK_INIT(update_lsmprop, selinux_update_lsmprop),
 	LSM_HOOK_INIT(inode_getsecctx, selinux_inode_getsecctx),
 	LSM_HOOK_INIT(sk_alloc_security, selinux_sk_alloc_security),
 	LSM_HOOK_INIT(tun_dev_alloc_security, selinux_tun_dev_alloc_security),
-- 
2.54.0

