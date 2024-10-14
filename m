Received: from sonic314-26.consmr.mail.ne1.yahoo.com (sonic314-26.consmr.mail.ne1.yahoo.com [66.163.189.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28911CF7AE
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.189.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918912; cv=none; b=U9kMrigeh0HOV4kN0CK/W3n33VAQ7NXhlCG+SFjMml7uxwcBuF9o1OY9Vcj/GeKJuV5sLQ9yq2HFOkT4YWvfOFXuXpcsbRuPJ5TN5yt8sdMtfOSI5xijAoPzBEqjRC3J/KHCr6ckxsfzSMi8zl7U6HtVcTxLBPk/eD5aVbxpa2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918912; c=relaxed/simple;
	bh=w4yTSnKE9r5Ps7xTYtGDMZjpibZez4tae5E7It+MbZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzqAEauqZDZfnqawS4qvnnYcGBaCIuZuLlMHi4w3uC7AaqVbAGu4tpnr1VvfbZgG4tu07IhVvlSWNz1gcmfR5vEsMv2XQIGP+HV5RoJBCOjstVMtdKh+EuTGjoqw+ZYNv9WFf1JBI+hg9clIqX2a0yNvArjg342nBonazfZ3pno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=Li8xQbSb; arc=none smtp.client-ip=66.163.189.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="Li8xQbSb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1728918901; bh=LtMrLSWC/CIpqiboKMENYczoqdAM2a5MXfVTzhAVYak=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Li8xQbSbnp4FinOra326xCOwsOZI19uIFJ8/zuxyvPQcA9i/D1m+eu05zVJIt6EOzwsUPaEhG3uGqBtTJ5aaNVOBFKsQUJnhRuINlSTu41PwNMCJbM/mmJTtrXB4sN9mRnj7hIpagzDGnPH1tz8pVTIXe1lrJqPPNIy07RE3dVmYpYRX8Pv1ZF/RXTVOOD7F8uzUX06+CiqSKTWfE5gvUbkykOpE38Xs6RDFLlVHlhu9vFqzU3VhNOrQUMLSf/BQ/mDbiDZS6VZ2Pw2JcnkadJ7vf4CxOIqadZ47RGXGqCHymfo5tE9q6fPqjCxTYI07LGV47OALH5evOnn2SssTAw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1728918901; bh=1pVT9IDNH2Cxb9jEWGtQvhoLJ1fVgfNvc+O6Y90Q+2K=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=CePw0lZ4uJtPZnN19wegwO63FLSFaNR3wBue5vu3bKe/0x7A0TGA/lfIxd47m6Pgie0K+uARePsgjUUQnc5lKiXbQi++8nca29fMLY14262sXjI2KDUuIyOp2QCyHeqTXlC9vfLVRtM6/ucEsP1ZIt8FODQXtw3FMl5ba1Eu9jF2kVXfOuxJyUVuCCbPAB8E9WPMUqMAe0oClkD+G92WyZpfy5bBEusLPS+8iFn1dTARP+cu97l9T+1SJlo01vIKRbg29vK1vTLcSAGFNnzQydn/ZO1nVjIavi8xNYeMlFE5wNpkKLDHsaAYSeNhg/JM14gcH6v+nVagVMnMssyOGQ==
X-YMail-OSG: 5sn4HoMVM1nvXBZcRCfDal6NUwE0z7l7.9P1Qe7UcJeu__mHxDxaCSDZmmuW4dn
 71waKm4Gm6S.MgDQZk3gd9_4yk5e2pSTsc2ucLMk1WgB8gpbTcbuFcd2Un5vo9BSpGsHGKeBcDz3
 qIX1eZKXYfOe6PjcqSukn0loIv0txDhaHSPFGATRR04g33VHWF5a4NtGVzVvTfxTuYzkgwqi_YTn
 nSQp7Zp4h7nuj90J7c9qFbpRgDDSWJRvnXbS0T95PZ7Ci9sVlWfR1QkY4CFr4IXtZd06Sky2Y4EC
 PCMSaYKiFmJtsyCIWRjGTjVVxsT_xX3DMky1EbuHlDQAQ6ybUSlXzWUOkQ6pA0pi3Zrds8CIdCeB
 xHXfqHKnSP0C5Qdg55oWW83f.x2TznGKmNL87xtKdDP9ezCMDGFJA.dwUiuEEPoWBODTq_7XaQNg
 ZFHDLEaOvBw6eC58lJXLAvRZeEjhc8l8yldcf3l8wbuEsRA638yvuDIX2lPVHpp2ECTOwZ6eO76i
 0UIE18HMnhdjzc2URtNObKyDL4_BjaJASUA40F2OVXOh5hikeKphbCczc5NH9N28W0KWXjUnnA2X
 A1ISkWQnOIwV1SrLeRRx9eXmsblmTuDnxvhI2ZKKHRJEVrVauaIYJfdI8dKB2dRKaHG5nKhnuLPx
 bYCrDWNw5Io0MVd3gS65usoPWt1QrAeKfNNT87K62nNS2w75BNvatM.RpGq_qzyb1MysSOmNd5tT
 nXrfoayhLLD_toY7h85nA2PH0u.Sf_E8mWxe5Qv_XUuKU.JKLSp8UJRnngI2ew9fZbj9bFn9y_kM
 yWegxKfokFGeQ1T35kvYDmaQ0MouC1SZX71cBTIBSxCtMFop8EAopKqlMFG4V.qIj2r93994qbK_
 kRaj05Vf8B9MpjQmXRrHl1O7UptOIR4sQ.j71FDby94SmOeGNMBc7Ci6hjP868eGN7.kDrbZNoI3
 n9xBJql.fCExmsvMLH8PqA7dpRS98V54pXlGMPYpu1nb5MoRtuRivlM4EBLuTb7sOFwiUKuw23NM
 kuZwA4AfCbPVpFOhwkW2qQX6rxMshgV1AkcomCgpVDsXI4ggjqzQNDzInfvB7qpS.OLoE5pgEQAh
 c6m.OcBvl3adKSmHLgmSb70xeC0.VBeJtIDtpOrzuSxFcQv2zTvZJ0uoN1M2M9vq4OjPLRLPChG4
 qNp7Sht_8qIi7l4idsJ_I_tYGt0Yox.Uh.oGEuOsxZuhj4td9K2k8TcmNC_MJQgXON74CV0fm3zF
 iIqsahbhHJkmu8QiFOPDuCqZ52RgLYrjMQ9jCBPYPJS94hbVFgz6V8CuzRCSWKLzo4PK2a0xrwTx
 wdkqR_g9gm.RxjlJoe7ZQ2cUpxCJqmpVLv2VsifwnBa_tWWE8WlTNb1aBdPt.fXE7T05Oc4FJZbC
 GqfkoEeT1bdJCZoB_iyfXtCOLH_cJxOIsrVkIkiTyKGAdrxYfs.8sKGotV_Au777Km3VEDrw6YmT
 eZ0m3lAQZfjxlwdc0U89tczv5MSxQVSfuPJQgv12XBAYIfnjvAGKOh03ILOEs9OEUI6fHL8nQUWn
 Vkse0OXfTFnjM9C6PaXDwXD9JN2TvvHlJMPKWGYqxQ1ETmGX4FI2ImGXtlHnh2ZMIDI8dtuuAvpF
 0HsIQ.Iwh0OC8Udg.owiWwzs69F.5wMH.goXS790UnJItX.HhnI7JPHlNbPbTc6pKX2sVSHBYfdE
 skfUDms6BTW6Nmd7zUZ1OYIczFZl.eMMOXUA9M_VaZgVYZ1_WE1SgAXvWsmhllWts_bSVMAjYOt6
 i40wdXWDe5wSd.gf5ioJ1rMPtTQFgmqWcx2XgCPZeQjovJgnvGP7vNK35r_BOBGWKVK4okDj0A_0
 KQmSuz7.Bb.gJxOdc6vu0GQN_VSTzGXkf2ZPzGO8OPkd50y_L9_C9yz3zUV4.qjl.8MdN_nW2hTQ
 iMyzncERVEpHr8gE4Oc4Djav5XW9y1yfGpPbUMyP3Z1FVmwuYJFi.dS2PnAZyLH3xZaDDDC.UZUi
 1QRJpdFSWJ.uuYhwYE3laFBvNGP3RsghVmY79AzYURL_qSd98kC6GLBU8Dr1cJHyhTrwgFn5dya4
 EGhbXWVlKxAiuj8dQ94st69P91ulws5L0upCVghtdOSlUTVQuTYhZxaLJvWMbhY0wFgAZPzOm9yl
 aCe1j_PQjlw40zKqTLzDjS2Lo0w5WVFMzQ3x52twN4EmCx6x3Y0tvccabE9YcIA_CDf.LZblk2ox
 H3uJrYzENF2buUVMIKjTD_ULYUVXRb8sSgd8BQDWuEyulSGhF4Tccgv_9dhGJasXVdTQ.a_ju2Zx
 fHcb0HQZXx4ewpEvmruFz26SRJeV8tsBvwMYYafDOWlc-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: c2c474dc-baa9-4f6d-80cd-664a9fe9fbd7
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Mon, 14 Oct 2024 15:15:01 +0000
Received: by hermes--production-gq1-5d95dc458-4tw7n (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 6c392927ea0eb898578ed262d71f570d;
          Mon, 14 Oct 2024 15:14:57 +0000 (UTC)
From: Casey Schaufler <casey@schaufler-ca.com>
To: casey@schaufler-ca.com,
	paul@paul-moore.com,
	linux-security-module@vger.kernel.org
Cc: jmorris@namei.org,
	serge@hallyn.com,
	keescook@chromium.org,
	john.johansen@canonical.com,
	penguin-kernel@i-love.sakura.ne.jp,
	stephen.smalley.work@gmail.com,
	linux-kernel@vger.kernel.org,
	selinux@vger.kernel.org,
	mic@digikod.net,
	netdev@vger.kernel.org,
	audit@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Todd Kjos <tkjos@google.com>
Subject: [PATCH v2 2/6] LSM: Replace context+len with lsm_context
Date: Mon, 14 Oct 2024 08:14:46 -0700
Message-ID: <20241014151450.73674-3-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241014151450.73674-1-casey@schaufler-ca.com>
References: <20241014151450.73674-1-casey@schaufler-ca.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the (secctx,seclen) pointer pair with a single
lsm_context pointer to allow return of the LSM identifier
along with the context and context length. This allows
security_release_secctx() to know how to release the
context. Callers have been modified to use or save the
returned data from the new structure.

security_secid_to_secctx() and security_lsmproc_to_secctx()
will now return the length value on success instead of 0.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: audit@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Cc: Todd Kjos <tkjos@google.com>
---
 drivers/android/binder.c                |  5 ++-
 include/linux/lsm_hook_defs.h           |  5 ++-
 include/linux/security.h                |  9 +++---
 include/net/scm.h                       |  5 ++-
 kernel/audit.c                          |  9 +++---
 kernel/auditsc.c                        | 16 ++++------
 net/ipv4/ip_sockglue.c                  |  4 +--
 net/netfilter/nf_conntrack_netlink.c    |  8 ++---
 net/netfilter/nf_conntrack_standalone.c |  4 +--
 net/netfilter/nfnetlink_queue.c         | 27 +++++++---------
 net/netlabel/netlabel_unlabeled.c       | 13 +++-----
 net/netlabel/netlabel_user.c            |  3 +-
 security/apparmor/include/secid.h       |  5 ++-
 security/apparmor/secid.c               | 26 +++++++--------
 security/security.c                     | 34 +++++++++-----------
 security/selinux/hooks.c                | 23 +++++++++++---
 security/smack/smack_lsm.c              | 42 +++++++++++++++----------
 17 files changed, 118 insertions(+), 120 deletions(-)

diff --git a/drivers/android/binder.c b/drivers/android/binder.c
index d4229bf6f789..5cec5b52bd4a 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3290,9 +3290,8 @@ static void binder_transaction(struct binder_proc *proc,
 		size_t added_size;
 
 		security_cred_getsecid(proc->cred, &secid);
-		ret = security_secid_to_secctx(secid, &lsmctx.context,
-					       &lsmctx.len);
-		if (ret) {
+		ret = security_secid_to_secctx(secid, &lsmctx);
+		if (ret < 0) {
 			binder_txn_error("%d:%d failed to get security context\n",
 				thread->pid, proc->pid);
 			return_error = BR_FAILED_REPLY;
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index c13df23132eb..01e5a8e09bba 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -295,10 +295,9 @@ LSM_HOOK(int, -EINVAL, getprocattr, struct task_struct *p, const char *name,
 	 char **value)
 LSM_HOOK(int, -EINVAL, setprocattr, const char *name, void *value, size_t size)
 LSM_HOOK(int, 0, ismaclabel, const char *name)
-LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, char **secdata,
-	 u32 *seclen)
+LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, struct lsm_context *cp)
 LSM_HOOK(int, -EOPNOTSUPP, lsmprop_to_secctx, struct lsm_prop *prop,
-	 char **secdata, u32 *seclen)
+	 struct lsm_context *cp)
 LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *secid)
 LSM_HOOK(void, LSM_RET_VOID, release_secctx, struct lsm_context *cp)
 LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inode)
diff --git a/include/linux/security.h b/include/linux/security.h
index 1a3ca02224e8..64e8b18e6ea5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -584,8 +584,8 @@ int security_getprocattr(struct task_struct *p, int lsmid, const char *name,
 int security_setprocattr(int lsmid, const char *name, void *value, size_t size);
 int security_netlink_send(struct sock *sk, struct sk_buff *skb);
 int security_ismaclabel(const char *name);
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int security_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata, u32 *seclen);
+int security_secid_to_secctx(u32 secid, struct lsm_context *cp);
+int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp);
 int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void security_release_secctx(struct lsm_context *cp);
 void security_inode_invalidate_secctx(struct inode *inode);
@@ -1557,14 +1557,13 @@ static inline int security_ismaclabel(const char *name)
 	return 0;
 }
 
-static inline int security_secid_to_secctx(u32 secid, char **secdata,
-					   u32 *seclen)
+static inline int security_secid_to_secctx(u32 secid, struct lsm_context *cp)
 {
 	return -EOPNOTSUPP;
 }
 
 static inline int security_lsmprop_to_secctx(struct lsm_prop *prop,
-					     char **secdata, u32 *seclen)
+					     struct lsm_context *cp)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/net/scm.h b/include/net/scm.h
index f75449e1d876..22bb49589fde 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -109,10 +109,9 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 	int err;
 
 	if (test_bit(SOCK_PASSSEC, &sock->flags)) {
-		err = security_secid_to_secctx(scm->secid, &ctx.context,
-					       &ctx.len);
+		err = security_secid_to_secctx(scm->secid, &ctx);
 
-		if (!err) {
+		if (err >= 0) {
 			put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, ctx.len,
 				 ctx.context);
 			security_release_secctx(&ctx);
diff --git a/kernel/audit.c b/kernel/audit.c
index bafd8fd2b1f3..5cdd9aeeb9bc 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1473,9 +1473,8 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	case AUDIT_SIGNAL_INFO:
 		if (lsmprop_is_set(&audit_sig_lsm)) {
 			err = security_lsmprop_to_secctx(&audit_sig_lsm,
-							 &lsmctx.context,
-							 &lsmctx.len);
-			if (err)
+							 &lsmctx);
+			if (err < 0)
 				return err;
 		}
 		sig_data = kmalloc(struct_size(sig_data, ctx, lsmctx.len),
@@ -2188,8 +2187,8 @@ int audit_log_task_context(struct audit_buffer *ab)
 	if (!lsmprop_is_set(&prop))
 		return 0;
 
-	error = security_lsmprop_to_secctx(&prop, &ctx.context, &ctx.len);
-	if (error) {
+	error = security_lsmprop_to_secctx(&prop, &ctx);
+	if (error < 0) {
 		if (error != -EINVAL)
 			goto error_path;
 		return 0;
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index c196dd4c9b54..4d3c22ba7149 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1109,7 +1109,7 @@ static int audit_log_pid_context(struct audit_context *context, pid_t pid,
 			 from_kuid(&init_user_ns, auid),
 			 from_kuid(&init_user_ns, uid), sessionid);
 	if (lsmprop_is_set(prop)) {
-		if (security_lsmprop_to_secctx(prop, &ctx.context, &ctx.len)) {
+		if (security_lsmprop_to_secctx(prop, &ctx) < 0) {
 			audit_log_format(ab, " obj=(none)");
 			rc = 1;
 		} else {
@@ -1370,7 +1370,6 @@ static void audit_log_time(struct audit_context *context, struct audit_buffer **
 
 static void show_special(struct audit_context *context, int *call_panic)
 {
-	struct lsm_context lsmcxt;
 	struct audit_buffer *ab;
 	int i;
 
@@ -1393,16 +1392,14 @@ static void show_special(struct audit_context *context, int *call_panic)
 				 from_kgid(&init_user_ns, context->ipc.gid),
 				 context->ipc.mode);
 		if (lsmprop_is_set(&context->ipc.oprop)) {
-			char *ctx = NULL;
-			u32 len;
+			struct lsm_context lsmctx;
 
 			if (security_lsmprop_to_secctx(&context->ipc.oprop,
-						       &ctx, &len)) {
+						       &lsmctx) < 0) {
 				*call_panic = 1;
 			} else {
-				audit_log_format(ab, " obj=%s", ctx);
-				lsmcontext_init(&lsmcxt, ctx, len, 0);
-				security_release_secctx(&lsmcxt);
+				audit_log_format(ab, " obj=%s", lsmctx.context);
+				security_release_secctx(&lsmctx);
 			}
 		}
 		if (context->ipc.has_perm) {
@@ -1563,8 +1560,7 @@ static void audit_log_name(struct audit_context *context, struct audit_names *n,
 	if (lsmprop_is_set(&n->oprop)) {
 		struct lsm_context ctx;
 
-		if (security_lsmprop_to_secctx(&n->oprop, &ctx.context,
-					       &ctx.len)) {
+		if (security_lsmprop_to_secctx(&n->oprop, &ctx) < 0) {
 			if (call_panic)
 				*call_panic = 2;
 		} else {
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index a8180dcc2a32..dadbf619b20f 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -136,8 +136,8 @@ static void ip_cmsg_recv_security(struct msghdr *msg, struct sk_buff *skb)
 	if (err)
 		return;
 
-	err = security_secid_to_secctx(secid, &ctx.context, &ctx.len);
-	if (err)
+	err = security_secid_to_secctx(secid, &ctx);
+	if (err < 0)
 		return;
 
 	put_cmsg(msg, SOL_IP, SCM_SECURITY, ctx.len, ctx.context);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 86a57a3afdd6..dd74d4c67c69 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -360,8 +360,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
 	struct lsm_context ctx;
 	int ret;
 
-	ret = security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.len);
-	if (ret)
+	ret = security_secid_to_secctx(ct->secmark, &ctx);
+	if (ret < 0)
 		return 0;
 
 	ret = -1;
@@ -665,8 +665,8 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	int len, ret;
 
-	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
-	if (ret)
+	ret = security_secid_to_secctx(ct->secmark, NULL);
+	if (ret < 0)
 		return 0;
 
 	return nla_total_size(0) /* CTA_SECCTX */
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 5f7fd23b7afe..502cf10aab41 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -175,8 +175,8 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	struct lsm_context ctx;
 	int ret;
 
-	ret = security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.len);
-	if (ret)
+	ret = security_secid_to_secctx(ct->secmark, &ctx);
+	if (ret < 0)
 		return;
 
 	seq_printf(s, "secctx=%s ", ctx.context);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 37757cd77cf1..5110f29b2f40 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -470,18 +470,18 @@ static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
 	return 0;
 }
 
-static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsm_context *ctx)
 {
 	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
+
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
 	if (skb->secmark)
-		security_secid_to_secctx(skb->secmark, secdata, &seclen);
-
+		seclen = security_secid_to_secctx(skb->secmark, ctx);
 	read_unlock_bh(&skb->sk->sk_callback_lock);
 #endif
 	return seclen;
@@ -567,8 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsm_context scaff; /* scaffolding */
-	char *secdata = NULL;
+	struct lsm_context ctx;
 	u32 seclen = 0;
 	ktime_t tstamp;
 
@@ -643,8 +642,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
-		if (seclen)
+		seclen = nfqnl_get_sk_secctx(entskb, &ctx);
+		if (seclen >= 0)
 			size += nla_total_size(seclen);
 	}
 
@@ -783,7 +782,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -811,10 +810,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (seclen >= 0)
+		security_release_secctx(&ctx);
 	return skb;
 
 nla_put_failure:
@@ -822,10 +819,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (seclen >= 0)
+		security_release_secctx(&ctx);
 	return NULL;
 }
 
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 8303bbcfc543..dfda9ea61971 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -437,8 +437,7 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(secid, &ctx.context,
-					     &ctx.len) == 0) {
+		if (security_secid_to_secctx(secid, &ctx) >= 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", ctx.context);
 			security_release_secctx(&ctx);
 		}
@@ -491,8 +490,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  addr->s_addr, mask->s_addr);
 		dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid, &ctx.context,
-					     &ctx.len) == 0) {
+		    security_secid_to_secctx(entry->secid, &ctx) >= 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", ctx.context);
 			security_release_secctx(&ctx);
 		}
@@ -550,8 +548,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  addr, mask);
 		dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid, &ctx.context,
-					     &ctx.len) == 0) {
+		    security_secid_to_secctx(entry->secid, &ctx) >= 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", ctx.context);
 			security_release_secctx(&ctx);
 		}
@@ -1122,8 +1119,8 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
 		secid = addr6->secid;
 	}
 
-	ret_val = security_secid_to_secctx(secid, &ctx.context, &ctx.len);
-	if (ret_val != 0)
+	ret_val = security_secid_to_secctx(secid, &ctx);
+	if (ret_val < 0)
 		goto list_cb_failure;
 	ret_val = nla_put(cb_arg->skb,
 			  NLBL_UNLABEL_A_SECCTX,
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index f5e7a9919df1..0d04d23aafe7 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -98,8 +98,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 			 audit_info->sessionid);
 
 	if (lsmprop_is_set(&audit_info->prop) &&
-	    security_lsmprop_to_secctx(&audit_info->prop, &ctx.context,
-				       &ctx.len) == 0) {
+	    security_lsmprop_to_secctx(&audit_info->prop, &ctx) > 0) {
 		audit_log_format(audit_buf, " subj=%s", ctx.context);
 		security_release_secctx(&ctx);
 	}
diff --git a/security/apparmor/include/secid.h b/security/apparmor/include/secid.h
index 8b92f90b6921..550a8d3ed527 100644
--- a/security/apparmor/include/secid.h
+++ b/security/apparmor/include/secid.h
@@ -25,9 +25,8 @@ struct aa_label;
 extern int apparmor_display_secid_mode;
 
 struct aa_label *aa_secid_to_label(u32 secid);
-int apparmor_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
-int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
-			       u32 *seclen);
+int apparmor_secid_to_secctx(u32 secid, struct lsm_context *cp);
+int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp);
 int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid);
 void apparmor_release_secctx(struct lsm_context *cp);
 
diff --git a/security/apparmor/secid.c b/security/apparmor/secid.c
index 8d9ced8cdffd..5d92fc3ab8b4 100644
--- a/security/apparmor/secid.c
+++ b/security/apparmor/secid.c
@@ -61,23 +61,21 @@ struct aa_label *aa_secid_to_label(u32 secid)
 	return xa_load(&aa_secids, secid);
 }
 
-static int apparmor_label_to_secctx(struct aa_label *label, char **secdata,
-				    u32 *seclen)
+static int apparmor_label_to_secctx(struct aa_label *label,
+				    struct lsm_context *cp)
 {
 	/* TODO: cache secctx and ref count so we don't have to recreate */
 	int flags = FLAG_VIEW_SUBNS | FLAG_HIDDEN_UNCONFINED | FLAG_ABS_ROOT;
 	int len;
 
-	AA_BUG(!seclen);
-
 	if (!label)
 		return -EINVAL;
 
 	if (apparmor_display_secid_mode)
 		flags |= FLAG_SHOW_MODE;
 
-	if (secdata)
-		len = aa_label_asxprint(secdata, root_ns, label,
+	if (cp)
+		len = aa_label_asxprint(&cp->context, root_ns, label,
 					flags, GFP_ATOMIC);
 	else
 		len = aa_label_snxprint(NULL, 0, root_ns, label, flags);
@@ -85,26 +83,28 @@ static int apparmor_label_to_secctx(struct aa_label *label, char **secdata,
 	if (len < 0)
 		return -ENOMEM;
 
-	*seclen = len;
+	if (cp) {
+		cp->len = len;
+		cp->id = LSM_ID_APPARMOR;
+	}
 
-	return 0;
+	return len;
 }
 
-int apparmor_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+int apparmor_secid_to_secctx(u32 secid, struct lsm_context *cp)
 {
 	struct aa_label *label = aa_secid_to_label(secid);
 
-	return apparmor_label_to_secctx(label, secdata, seclen);
+	return apparmor_label_to_secctx(label, cp);
 }
 
-int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
-			       u32 *seclen)
+int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp)
 {
 	struct aa_label *label;
 
 	label = prop->apparmor.label;
 
-	return apparmor_label_to_secctx(label, secdata, seclen);
+	return apparmor_label_to_secctx(label, cp);
 }
 
 int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
diff --git a/security/security.c b/security/security.c
index 0c9c3a02704b..914d8c8beea7 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4309,40 +4309,36 @@ EXPORT_SYMBOL(security_ismaclabel);
 /**
  * security_secid_to_secctx() - Convert a secid to a secctx
  * @secid: secid
- * @secdata: secctx
- * @seclen: secctx length
+ * @cp: the LSM context
  *
- * Convert secid to security context.  If @secdata is NULL the length of the
- * result will be returned in @seclen, but no @secdata will be returned.  This
+ * Convert secid to security context.  If @cp is NULL the length of the
+ * result will be returned, but no data will be returned.  This
  * does mean that the length could change between calls to check the length and
- * the next call which actually allocates and returns the @secdata.
+ * the next call which actually allocates and returns the data.
  *
- * Return: Return 0 on success, error on failure.
+ * Return: Return length of data on success, error on failure.
  */
-int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+int security_secid_to_secctx(u32 secid, struct lsm_context *cp)
 {
-	return call_int_hook(secid_to_secctx, secid, secdata, seclen);
+	return call_int_hook(secid_to_secctx, secid, cp);
 }
 EXPORT_SYMBOL(security_secid_to_secctx);
 
 /**
  * security_lsmprop_to_secctx() - Convert a lsm_prop to a secctx
  * @prop: lsm specific information
- * @secdata: secctx
- * @seclen: secctx length
+ * @cp: the LSM context
  *
- * Convert a @prop entry to security context.  If @secdata is NULL the
- * length of the result will be returned in @seclen, but no @secdata
- * will be returned.  This does mean that the length could change between
- * calls to check the length and the next call which actually allocates
- * and returns the @secdata.
+ * Convert a @prop entry to security context.  If @cp is NULL the
+ * length of the result will be returned. This does mean that the
+ * length could change between calls to check the length and the
+ * next call which actually allocates and returns the @cp.
  *
- * Return: Return 0 on success, error on failure.
+ * Return: Return length of data on success, error on failure.
  */
-int security_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
-			       u32 *seclen)
+int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context *cp)
 {
-	return call_int_hook(lsmprop_to_secctx, prop, secdata, seclen);
+	return call_int_hook(lsmprop_to_secctx, prop, cp);
 }
 EXPORT_SYMBOL(security_lsmprop_to_secctx);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1503d398c87d..692735eb04aa 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6607,15 +6607,28 @@ static int selinux_ismaclabel(const char *name)
 	return (strcmp(name, XATTR_SELINUX_SUFFIX) == 0);
 }
 
-static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+static int selinux_secid_to_secctx(u32 secid, struct lsm_context *cp)
 {
-	return security_sid_to_context(secid, secdata, seclen);
+	u32 seclen;
+	u32 ret;
+
+	if (cp) {
+		cp->id = LSM_ID_SELINUX;
+		ret = security_sid_to_context(secid, &cp->context, &cp->len);
+		if (ret < 0)
+			return ret;
+		return cp->len;
+	}
+	ret = security_sid_to_context(secid, NULL, &seclen);
+	if (ret < 0)
+		return ret;
+	return seclen;
 }
 
-static int selinux_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
-				     u32 *seclen)
+static int selinux_lsmprop_to_secctx(struct lsm_prop *prop,
+				     struct lsm_context *cp)
 {
-	return selinux_secid_to_secctx(prop->selinux.secid, secdata, seclen);
+	return selinux_secid_to_secctx(prop->selinux.secid, cp);
 }
 
 static int selinux_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid)
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0c476282e279..d52163d3dd64 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4817,22 +4817,35 @@ static int smack_ismaclabel(const char *name)
 	return (strcmp(name, XATTR_SMACK_SUFFIX) == 0);
 }
 
+/**
+ * smack_to_secctx - fill a lsm_context
+ * @skp: Smack label
+ * @cp: destination
+ *
+ * Fill the passed @cp and return the length of the string
+ */
+static int smack_to_secctx(struct smack_known *skp, struct lsm_context *cp)
+{
+	int len = strlen(skp->smk_known);
+
+	if (cp) {
+		cp->context = skp->smk_known;
+		cp->len = len;
+		cp->id = LSM_ID_SMACK;
+	}
+	return len;
+}
+
 /**
  * smack_secid_to_secctx - return the smack label for a secid
  * @secid: incoming integer
- * @secdata: destination
- * @seclen: how long it is
+ * @cp: destination
  *
  * Exists for networking code.
  */
-static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
+static int smack_secid_to_secctx(u32 secid, struct lsm_context *cp)
 {
-	struct smack_known *skp = smack_from_secid(secid);
-
-	if (secdata)
-		*secdata = skp->smk_known;
-	*seclen = strlen(skp->smk_known);
-	return 0;
+	return smack_to_secctx(smack_from_secid(secid), cp);
 }
 
 /**
@@ -4843,15 +4856,10 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
  *
  * Exists for audit code.
  */
-static int smack_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
-				   u32 *seclen)
+static int smack_lsmprop_to_secctx(struct lsm_prop *prop,
+				   struct lsm_context *cp)
 {
-	struct smack_known *skp = prop->smack.skp;
-
-	if (secdata)
-		*secdata = skp->smk_known;
-	*seclen = strlen(skp->smk_known);
-	return 0;
+	return smack_to_secctx(prop->smack.skp, cp);
 }
 
 /**
-- 
2.46.0

