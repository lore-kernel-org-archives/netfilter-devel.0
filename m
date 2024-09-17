Received: from sonic305-28.consmr.mail.ne1.yahoo.com (sonic305-28.consmr.mail.ne1.yahoo.com [66.163.185.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F18615B10C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 23:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.185.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726617140; cv=none; b=AMCHx2avRLWe1cTb9oDPmyCGpEGdK3rT2TKpQfLtzBNAwm+rx5F+IjDbBWwSjXACAZY7FfkAwjah64YFVepaGXN+Nov+0QmKKqoKyK1/2JrmvzFi/gZsBqN45ExFr8Jh0uWSClhzHykD1QE3homdMbhYvTS/BC97oM+UWi0SJ48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726617140; c=relaxed/simple;
	bh=pou8xUe0C7VTTiS9qE5Y569/pWfKE9WiY5Fqfo6ibco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoyjuulZEPstQ909UmVC/38UZbZII57/K7OHykptFrI+Vx5N0bbXtTr9+bypY1yTXgTh2WhJmgJHSaJML5XVxWHxUFp5pDqcokK3l9tGIfdViWgINjgvuGiVKL7BC9fqTCxk/9lRox0L/fcHqAnKLEWO9eLZznH/0LQlJSVvw6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=DaOBpihI; arc=none smtp.client-ip=66.163.185.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="DaOBpihI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1726617130; bh=BGWO/pKS2OfUbZ0HvCCtljkvg31m71b2sydeASh6V04=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=DaOBpihI/7OoGbqzNbej6A1Wx33NC9jsSFSvrzjylv1AYLlN6cUjl8H9hTwpGVPwKKwVcuFl8qiD1zWrFaAjKyQst0ZcWMGVKk8nCbgq3WEXOJc729qRGcuzlcM5QzZ7ExqPYPooSjs22uTuYmeyaUmMvnF7Wvs/vQ5/yX7Knx1jXn4RrKKNq1gdWGwe72NzWBg6oox2/tdicA3pwMZ1Zkcz1s83PEez5RpWZP2G1xeJqSWN7b2mxR+rmB5WGE2Tm/UJ7KV+gupLKicR041i99d0mKBo0EGBFC4Hmh1FM/PwERegXZWteGQBRqeQ6cCFvdPOdiKZBj1BGUqI6++HDg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1726617130; bh=sZe524PhSk8Okdcd66JU/NWJPnN2y/nKpMp9nkw8iNX=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=kQHrnJ6O8NSOHSU1uDl/VGMnTq55v0Kzl5jqN5ZDAyZHSA2x8LgdLfk0jBbm7PowV0sK1BlAEQCIJBJcYn7zvLibWdPTEeW4V4A1R47VsXUZS+HlbqWQvG+UMS9xrB+SlE0/CSTSX3WyqIM3aZUbnF69hX90ayf4YcU7CkzH6pVnb0wDQZBotJuNf5zIBtduBBXIAS4dQCwr0wGo8Q4mzA8Q8CpzhnCs2QMsI5YoJIR5U7boK/QlCPT5YH7OgPxQbUAEl+HeNq1XPZWXNLNDUaHO/kWx8f8GkK+qJG/AqTYtspO362m6EOpcYf/16nCVkoMu7P1UW311qGwuixGbcA==
X-YMail-OSG: rwP75fsVM1naRvjTGTUmAJGPatOYKoTxJjyR0reRf4sxmgxexndYDRvGO16l5S6
 pbhM4Vd8Ld.qugLu_2dNGGQzUpZc0xU62wvItpy91JsLMaljQqvlDUHXbYRK_0xMyH_LdwKU2JkM
 EKA7dsHVpAAwJLCQmFQvtq0kRtq2wBiEIo138nDTP0Qzk3tcdNqwGbAAhMWTQN3HtootvcuQc4br
 o9aDaX6pCZhiTuh6LuANzE9FQMwW7RtuwCiwXZI_3BDvPRSUxrAZ33X0zwiSzasS5iBVb1KtA._A
 awpCSHTODKqhO46aHHy8xgkgoEWM1Zacnpyh_e3hpUdVUwdVWUs3bsWpaZvYBi2F8323NN6re5lt
 NA2eaf4_d.W4KY0sTbLYhMQxTdejd_e1N0.VshP6ohWuukxL1KNTbnqEfXMFpvRqh.taHRAMlOf.
 VG76Dvr5HO4a6.f69yPwKhs..SGcbE8xDQ5hwxWUdA8y4UwAwQpdzw2XADLiKWvlWo8w9Q4v3zM2
 i5qly0cSMWLXIPsqhE7IAxprIu4SyPTKo8SkVE2i3oGG18u87MDyb6IpJkpMJYlOd7m4pFz7OjsC
 xmzppbeBDu499347Jfi.oOY4kEgWSYvi4UajwAy4KjV7.RPqa1RfaYz9oovtsqWqgH06QMYzfzHy
 qpJGbBr.B5oD5qvH6F0iulxBClWn.qkrRH_2apvhdhdSttexh0C.2IyHRAuGw4tuJPFJENkn9vc1
 0UqKwfWYN7eMFNJLL5F82TJ4E62kBZjDnsupLxB3jMI23VBTQZFlzp5vEVvh.M6jHVopKah31SE5
 JxTiRGMpa4ktTf_nK8hCQ42DREJMz0GuVy5ve0RkdGTvEgV8onojQpkb_pUBM__0vMjyKNCuNokL
 e708iI1C21ZTbJBlSI4XZKPfvhOMAzOMVMEFb1T.JqmYCmSs3aftA10Cps4i3XAig.SLNrbvMOyf
 4nQJPPf0kal5fdWoceWTffhHOD0BjJjDyFrzqAQh6GK9bft4khXbiu5kMKxhQ4wHKgZom78JTXcp
 9pAj_5HYI7axKLpVfiGAtiNh2zI5pmVz1Me03h44Z5F0sRqLtim4I71ATs_Vom6jZOgwrwhDStNV
 UrM6q6NdYRGwZkBmO2lXazvlnf1bTzW5N13VSdDl8wp3BvJGrcjn17Ujz99_H9bv3nGr_07mSJxJ
 X8hwouUlBaRWjyK8pu0gzigb34rGNWa.g6HPhFLSYPsPeMOpJK1EdgV7s3xEKGX7QoZ63gp0di0l
 L0erfEh5_ofsC4i_8GIrvQstOIVCogwpAeEhljs4w.htrPTC4s4f_1beOQTPOqJ7MMPL2JZ2mFmg
 5OT_B9pKqp8O3pRDb3P2iKH0xDcMS1tGz_zPE5JQOo0Qsg7e29yfZc6MX3JLtQ2Re5gpSu_D5wMV
 RDLy2A4ihx3YQlfc5khJaLrGT89JK9fCpr6UCznkeOf4rwQdQSQJqizv.ONS.R9RUT5D1FuB9wU0
 8uo5Y076bagB22Re4S5wMpAyl7hl2Gxd55AIEFgVk_vKWGt2jHahyE11u8lPJJtBB0MnpOKbxT7U
 RIGVw51TER952LVLprvwv_nNFd6omoltrBv.zQc7SiBOG.dfmHET1imd9bHSR0ZpOupvTvpO4nMw
 h7hc_uDV6SWYNYvwUWGGY7DSakEWoh_aXHJbyMFrAHV2tFkoWs4TZvXtKBWTNT0wyNpIhzwgFlqa
 AV31jtNNq9pyCazd2.47BRp6kBjtg2gbTmfOpGJSCf1.bSj2LxToAIqAQrT7qRU_gWBepSMVJnNa
 PtOvbGcwKHnQO6UVi1xHFwGoyp.nD5w7KGc.4QyEgGSSIuVrTh6KvCxsHOCz_BRFt9GeRfLec8ET
 x2l43PGP6QwXqFkX7hNWffHhFyoOpky.v7Z_pfJhwQe5yz8d1iE.8JPALyePPEmuGYZ_XT36S3ym
 BmC..grdQxXOSk0BYW9QwmbpnR6WSGfl3TBm0jB99OQKWjPqPWRqNWJryz3QQVJ_sNETXwKe98n7
 ds9Y3L4IHMqdNuSLn4huP5lZz5GfMCOV6hk2akoJt13TQHzJJOu0RjfJNM2tJZ.62UN3jg259fi5
 3KbQ6DN0QuXF6pdtG66.P7024h8urlHVXWubERRp81uosa8bivdm8X0g3KG_R6GxZZJh142HGrdd
 WiGclDGTHtAdb3za2t7KF57_rwD5ZbBiE3C0aQMmkTUckkAZMLCnucImDOtQzh8cKFhgJcR6o_sp
 gxg8yxOI_fk02P4A7srwM8705iW63dnX6KoJLE7DzbGaHFsZTipDv9oPDQBdE
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 8bb36148-d7b7-4cec-9731-341893fb31fc
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Tue, 17 Sep 2024 23:52:10 +0000
Received: by hermes--production-gq1-5d95dc458-vkwd9 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 2b3a84955471b9061a763fb967f12395;
          Tue, 17 Sep 2024 23:52:06 +0000 (UTC)
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
Subject: [PATCH 1/5] LSM: Replace context+len with lsm_context
Date: Tue, 17 Sep 2024 16:51:58 -0700
Message-ID: <20240917235202.32578-2-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240917235202.32578-1-casey@schaufler-ca.com>
References: <20240917235202.32578-1-casey@schaufler-ca.com>
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
index b32416f8f9cd..59081edb3370 100644
--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -3289,9 +3289,8 @@ static void binder_transaction(struct binder_proc *proc,
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
index 418611f21831..95c7640919ba 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -292,10 +292,9 @@ LSM_HOOK(int, -EINVAL, getprocattr, struct task_struct *p, const char *name,
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
index 432bd4763703..2604ea16cd6d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -569,8 +569,8 @@ int security_getprocattr(struct task_struct *p, int lsmid, const char *name,
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
@@ -1530,14 +1530,13 @@ static inline int security_ismaclabel(const char *name)
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
index 32a9864c648b..5ae0b26e5d92 100644
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
index f2fed7a37e22..268117628a2c 100644
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
index e02e088b8794..5a93804e5cdb 100644
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
@@ -669,8 +669,8 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
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
index aaf54900de3c..e43767c35930 100644
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
@@ -559,8 +559,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info ctinfo = 0;
 	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsm_context scaff; /* scaffolding */
-	char *secdata = NULL;
+	struct lsm_context ctx;
 	u32 seclen = 0;
 	ktime_t tstamp;
 
@@ -635,8 +634,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
-		if (seclen)
+		seclen = nfqnl_get_sk_secctx(entskb, &ctx);
+		if (seclen >= 0)
 			size += nla_total_size(seclen);
 	}
 
@@ -775,7 +774,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -803,10 +802,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -814,10 +811,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
index 4f73cc52ad5d..58f5fe1eb6c0 100644
--- a/security/security.c
+++ b/security/security.c
@@ -4190,40 +4190,36 @@ EXPORT_SYMBOL(security_ismaclabel);
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
index 2b027c08168f..01e44a14d3d4 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6616,15 +6616,28 @@ static int selinux_ismaclabel(const char *name)
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
index e5b47342c274..e85efe894ac3 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4836,22 +4836,35 @@ static int smack_ismaclabel(const char *name)
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
@@ -4862,15 +4875,10 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
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

