Received: from sonic306-27.consmr.mail.ne1.yahoo.com (sonic306-27.consmr.mail.ne1.yahoo.com [66.163.189.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4413ED3CA
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 20:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786654159; cv=none; b=Zq1a/dRJoIUA1rBKlTa9uWwFSYs7LjPwNt6Z0qJQh+x1YK2kEfPwtVSbW0X1YtR3/yHQt4DUWNJ5Et2C1RN2x2PH9qfJTfUrwr6T5zcnW0PPKqT55JfBnGtATv0i/WniaJ8Z3jpQ4BOIpmWm6q0qariqy3uFhTeorLx+v7UkrN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786654159; c=relaxed/simple;
	bh=s5artP1LDQIWhdH1NzccW8mdrQNOfSA1a6tUvGlrj4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdQNmhw56lEL4LGs8o3ZNdZ/uZtElCPeQmv9F4STl9rO8xP5WJGO5yKncX7ks6j1Sq2TKMn9kQOnDsrVi4YxxYVKvkUXGf8J3fTjPLSUu0Ir/FJrTYDTQ5u2tzMTPd2Rm4rQ24/fRBWG/EKnu0I8JTiJXD7yj5ja8Z7BUADm+mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=lmEdUXyf; arc=none smtp.client-ip=66.163.189.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="lmEdUXyf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654156; bh=ED8dgmLby4uDvmQmYjzWJwEfBzVYP4wU4faKBGjAcEo=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=lmEdUXyfBPuMcxDiFFWDNhr5nLi5X6ecLYp4xoMh2HKBtvywgAETVCA6gIBuDK4Msdx5+PjndqA/DvFL0eNeWj2FA9i2NjOjVywVoFDlRgJnAS0r4w8IF78sA/TY8hMO14ftSFvBkR2SVNVvyYpI1GiN+jWstW5MgBRPA4vjhKlpW2+nq2aQ3cAnU6+Pvn8Lw1zd/lgSnMMaUIE9zpBFcHhq7r8CX5n8gM+AcB12m2rZBb69B+cZ4HgA5M4W0ycAqdGWzMCcxrRklu1r6LheddyssEjS5VZHgLbwyfB0bPi8ToiPQxjAQ/HvbQIT9MmieW2dbb77YRtEH+m81nGU/g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1786654156; bh=KUaGpOy2b8TtfyDWk5b5Yhrja/CHfpWVBJBbthJvJ97=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=shTNst2vku2ID3wTuCgRFmF6wnNO7cvM5cPUW6sp2DXVvz13ckPerKfhJujRzHqqObfbH0ZXAcAXR2LZCJNppJl0xYmcwZH6BJejTSXd03szjm0C3AidLxfWVdGdiDwXSJpIwQudmxWa9333QtTKnyF7PCVakCiFCpFAY5GepmK0H1if6kN/Nd+TMAIZVLWjNpHAA671xyYaQUUqwssiGtBYY89LEdaHpNYByv0XW3MHmkAjyKmqu6jT8knd0iZlgY2P9pkX5PHVLpYTu2U3og6BbaJ/rkP4Ji2LczBCM5LFzvD9ggPu2q4hbHc2tfdddby1v13WrN38KUZm5mZDHg==
X-YMail-OSG: NE_mH_gVM1mJrncOfyNJgEZqlITHP1oKTkq.qtypC_o9eFVc3h0e95Nfk5ZtFuT
 aGkqmv9GM6nGkWemslN5P2S._5.uGEz1DcLWfnaSGc5lgiuJyQF28qi8Z1aCrpaHqO5vDNYTNODt
 AOZhaOiaZ5_64Y2tQ.Y9nGJ4sdSMY7IvqOxNmA4b9k2ozV8FYSXBgINfxDK1EtqpnjY7TU0I7jET
 ftwu4MeHm17SCWl06YBPXY96YbbS74LLwYBoEZ40.PCsEMNkZyqWAOJDVVFD5abIrMaFVg4pNvBp
 pSSs.lSqPYdtun78GaVyrcp2.Bi7QAdWphqI3bSrQNxpNNMkkRWcINVYwRQ.ksmyhqGNy1h87s5S
 DDZUPdH8QwOfoCZ4M.P.wSHHIfbE7ozhx.gdA4czgHyHNhlHi2a6W9hz0plRQWkELIwac4546uPJ
 vBM.hYtTtbI.KW4811cCQXuskecgsm5x_aJyRW4Wcwz4AhaL3lNAxItUKtqXKfM3xxyvMNuZiMgn
 tFg3GfFtDp_Os45VoRrVmpYwfVU5goUG7s5TsNjsm8VDXjMQ5V1Ed7.WE5Ndp0Tb.wvkQ35pqfQd
 D79uYolN67aZXNufPtF1IYihrL6DD9dkAszuTX7f6BHrh0HF7MRtq0NwUa4OpT4miSoi2QhIZHqE
 tlOgc4_vKuij.xQtGd267GISmH0xt0z9lczDZtX9mgkQQo4dCxgc8tO8Z6M4206LxLbkSNIvGOyr
 gTbJrjk8tv.vThhU8Ho26GwPrunUgIA0Q9LzGzbzmkhSGJ6O6o_tKr_qDIcYLDHGxD2nLs13J5lc
 Zo3yiDpxfbHuhdeMJ4uKPwFsRufKIh9Mxr2tScMTOm1TQ_I6VhQ2AK1ka5BsNmSZB.cBkZTujaOz
 FnW1yEp2ofza.Dcq1u4bTsWyaKj8zDjs.qyx5MccELYQCmS3MUr4T34YZeIkNrAvGLcyOKR1BeAO
 6vaxWnh1iMHLDdav4p9JshT7Or9jGJYC5Mk_Pq.LjEmWvjj3.WsmeoT9ltPzq7QgQO5oaiVhsiMN
 x9yZ40y71gD7q_xW8kuY9OZPS3DiZqEJ.UbyA3An6XbVCNe.twBo5HVDROfdod8BJ7uglh93Cq75
 54Vzpbg62NSuK8MgFRMlPO6m1ZYSxTmMRTRbLOsuGPmiqXqoQz_pq1m5JIQDUG1Qgcu51w4ebTKD
 .KjDqbUGJdyemZe7ah8I3XT9cEz7tByyEaZVLsFCU4q33SviqLWnZheg_mrK9pBjOVwO_TXyJu_I
 nFesJx1bj7hmxOxx0HdEAiUlzRZkpVYaAwuGt_NLdzJyRaEbC.ry6ZvSYixTaA4DfTNZompNetZr
 zno.SzE_h64zNtAcFcxYqg2E5nfMivEHTzgoWeG66jjWHxUQfKpKzVFtow5MqDuwzD7SrOIqrEPd
 kHtPYdsa2lPgx6gl41NXgHZcy603sRcun9_Ms6yXVdx1.orweL1kaZoET79jLJF1TEALkOEUTQ.W
 5CPiZop9nUDzV6pesjS73C8Gyt.zmx6ZT.eZ8nHRnChmmH0KBJSkI6UtZEtWqgjyXFPgHG1OBAP3
 cW26ROpz2BLSSqzhTmrWolvkls8O5hq25Lv6MUTSZ5punVgAkdqbUulzI92w16gEpRDvOHE2TPOB
 mEyTmKDla4U2oBwIT3bGWW6jqF5rQwZzlP_YtfmrpluLzJ37Em9NXsS9ZI3cbNDExnkiG01nEzb0
 MFup7py8j8OnYAFmTkc7Ul1RIa9Rpl6NPptxOFeZ46iE2xtKemHOdb2B2NpfJ2GTL._4XCnwSBrS
 E7kDvpwEQBTH0Inklaqsw84i.PLsPJhrCCkbSmHgDRl4Gzmu9fuw8hhGCsO_4RTqhw6o0q3v4gFk
 Ej9JxvI9hWTGu_haWvAzKW3jBlHqOog.ZpBbQBsFdaA6sIthjPBmX2H8lvMDg7kQBEC756JjX249
 uDiPbdwUJfD292fpiC1mj9Dvh8xhcWwG5fRJGUj4mTnfDFakK3UY_vpvX_05uRtXrHZr0SZ_bp39
 9cKy.HiWdw4oIhOzy438Wab5v7fuxM.L8pbXBd3Q8BLaEvSHml2xuJvGDrFF7S58ziDtro3EyECg
 7qkdnw.65vVNDNgtyRpeJo7.v6fDVxbI3MNdYq1IqOyY0SMKuiKX0bURyB6mdVwY4kBCecgVYczp
 4ITW3XBPS0zNTkgymBP9CcRT.I.O1BSysv_AXpM17a72EG7A7.zPqyckBDIRFswt8o0x_Ecj2E4P
 ofekgTmbzUYgnBf44fA1JanqONynWWmzozoLgIgHC6m9VeDFsHHtSAc8xdbkjCuqGNfux.eje6jn
 XrCtSd.Xw_Gp0zoF99CDMzgtkR98-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 732d7d6b-6705-4274-ba08-40485e0f121c
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 Aug 2026 20:49:16 +0000
Received: by hermes--production-gq1-678d9dd684-6hkng (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID afc5ff34d004487469fb59f8ce77dff6;
          Thu, 13 Aug 2026 20:49:13 +0000 (UTC)
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
Subject: [PATCH 4/7] SELinux: hooks for secctx_to_lsmprop and update_lsmprop
Date: Thu, 13 Aug 2026 13:48:51 -0700
Message-ID: <20260813204854.19211-5-casey@schaufler-ca.com>
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
 security/selinux/hooks.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 8d6945edae7a..c05c05e71078 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6946,6 +6946,15 @@ static int selinux_ismaclabel(const char *name)
 	return (strcmp(name, XATTR_SELINUX_SUFFIX) == 0);
 }
 
+static int selinux_update_lsmprop(struct lsm_prop *dest, struct lsm_prop *src,
+				  int lsmid)
+{
+	if (lsmid == LSM_ID_SELINUX || lsmid == LSM_ID_UNDEF)
+		dest->selinux.secid = src->selinux.secid;
+
+	return 0;
+}
+
 static int selinux_secid_to_secctx(u32 secid, struct lsm_context *cp)
 {
 	u32 seclen;
@@ -6964,6 +6973,13 @@ static int selinux_secid_to_secctx(u32 secid, struct lsm_context *cp)
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
@@ -7694,6 +7710,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 
 	LSM_HOOK_INIT(ismaclabel, selinux_ismaclabel),
 	LSM_HOOK_INIT(secctx_to_secid, selinux_secctx_to_secid),
+	LSM_HOOK_INIT(secctx_to_lsmprop, selinux_secctx_to_lsmprop),
 	LSM_HOOK_INIT(release_secctx, selinux_release_secctx),
 	LSM_HOOK_INIT(inode_invalidate_secctx, selinux_inode_invalidate_secctx),
 	LSM_HOOK_INIT(inode_notifysecctx, selinux_inode_notifysecctx),
@@ -7812,6 +7829,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(sem_alloc_security, selinux_sem_alloc_security),
 	LSM_HOOK_INIT(secid_to_secctx, selinux_secid_to_secctx),
 	LSM_HOOK_INIT(lsmprop_to_secctx, selinux_lsmprop_to_secctx),
+	LSM_HOOK_INIT(update_lsmprop, selinux_update_lsmprop),
 	LSM_HOOK_INIT(inode_getsecctx, selinux_inode_getsecctx),
 	LSM_HOOK_INIT(sk_alloc_security, selinux_sk_alloc_security),
 	LSM_HOOK_INIT(tun_dev_alloc_security, selinux_tun_dev_alloc_security),
-- 
2.54.0

