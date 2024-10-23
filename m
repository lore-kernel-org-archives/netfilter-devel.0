Received: from sonic314-22.consmr.mail.bf2.yahoo.com (sonic314-22.consmr.mail.bf2.yahoo.com [74.6.132.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC75E1FAC50
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2024 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.132.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729718536; cv=none; b=JRp21DwhGFJjoe4+t1m4dkYvIrB4FMrhy2aqVv1uKcUNTPkrUOzeLdUJ6ILtDa0RJhJLMMeC+NRjQedNuY2jMt+FNa/PBYL99fRWJI5EXzLtL+WB/QH/R3UPy/M0K3Mz+mLH6tI0PwfIuEgCP6Gsq52WNsa3Qlp+gT7tfUTkDLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729718536; c=relaxed/simple;
	bh=P1bFdA8Imw/lI7Id+NXhq6gjKgzY8SZvX5qQ0U2pbe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1frPjjIFo7D+VLYDw0F1Pt/rsBbZRGMTFAiWDi/rJSRsAB7my1XuORtVA6gGtiTXZff8fuPJb0iMR7Nkvovglg8vesnmh6NJ4kIK1/HhYf6ofs2CTC3qsCmwIJ1ZgTS8O3Jq6q7y1/RsxNu/U+9JmQ9xKYbjfS7s7oecHJ6nr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=szqwokkl; arc=none smtp.client-ip=74.6.132.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="szqwokkl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1729718532; bh=eFiFw87gTeflI6YpF/f724PdslN2RkDib+9BWmN1JP0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=szqwokklZEk24ijjmcZeEW1mGI3pN7XeuJQQDVmj3P+6Bp4z0nDu1b944t30ZqejML/8LdCXGEp2FqAzY1dpgvYBTvvUH0loT9FnSudd1jiRW5G6i4037DeZluNEaQz7V0qisH2N4OI/MhK9wBgOIzEe64pKaZELBkLSPhvScqQCqdy96eIjZllMQfm9P8AbN81h9CVtOGNvONEhKoeSSO3atKYRzFIZDqw74dAYynHcKv2f0caRH8WFktogFMLCD+eHHo9Qn0bfHubcYo7OsOhYfI9TppO7rNyQ1Rig2WL+x05+ugGZ2Un2dbTAtxJLou3PFwlWzJMMnvg2FKe+nw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1729718532; bh=8/9K3PSORsDxdHRPLThouSpURIwSuYqnKYNr55IHpya=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=Auk0I7NvmkC88A62HtUMBtzoeNeAwrb5Q1/Bi5zuGdM9m+Uo6TRYaNwbPj8pd2a0g4LlI7v7AUUla4hqfIwWrpAYFcTl95CITnHGi+bzd9QLUim63Egqzu3mII/fiUuPeatTz64iOc7ZbxqY41Af78GqWfQ6LyIWX3jJFvvEebB7Fe5yaQzJGCVvlJ8WLkHYqGcbYd5heXzx71erHzTgV7ioSEiyL4F+bpCtPWgvkgHBY7UtR8fpMSicgGd8S0tvW2pqM8xXzHbVwC0SNu4+RxAdgLX7b3v1lWGlEqKn97SxMSHNUeH6l6/BriD/ibdRidCo55rErkob3mbQU37y2w==
X-YMail-OSG: 5iiIuloVM1nynEk2dFsU46nra93DqKMreTtL0tMCD_S9tIWA.LcuD.LkRvDHONC
 NtsX4CRlK2n94bBgZ9x4rgutYUVZ.uRBiP5vqWjdEjv8WnsJjiTbVEjmXszI5pBSPlQfsVu08Vgh
 t9YBPA1cCQ6oMvnKU56Nm7sZoRhol5P6CDbLsptHCcmDY3eIhWVgyRUhjzz1pvSA.8MOJ3rLLRsy
 iOcdn0COWEPGxHWEO9idaHELepRfujKflwOs_jvQD3fR3Y7yFTVnNqHbKzEK5wS9TNTIyaOr65V1
 t45sg3Sx6UV_ZtwNo0ipVaQbeQD1B6uH4Ikkja8NcL1rgg6YnWMqCtN4SYII7MdQ5m5bGuEKjU7I
 0sstoY2YtXIS9rc8jHrtkkdxv8rPaEOtkJBTqUEcHxfFnEaaYufzlZ4szFh4qGxwantg9F4QWGQK
 mqjaDfhzg4tQRzxSYktXd.cbOdfg5jtqTHSn2tAYTZr8u._KrYhtKNG9li7.MZP1Nh4KMZFS.JnV
 HmDUyY7fpyhnaFoJsfLsJq73Kx2s75UKZ2IMV55AxXKZbqj1ktsSNcvBwbMIVac4JJEuJEBMV7_1
 JgUBU7hFWNK0zHlElsae9p3_k3d9CgOypb1eHY1Nq8TpEXhlVMCUYMX9OCT2AhauYF6tB9Jql8HD
 ndTKBUvWd43VBakUcQVScbCQ9FQ46utS5xTZGGfOlf9WCZlIS9v8jTvzNkuhvpxyNjIwykMUXSTT
 VCsws9ZFDoUGfb0bPI_gvZQADnv9PyMir8SXmEaY1bRVdeN554GVLbiSoZcOgafEiH60uapSe8ru
 L2RJheF7GD39KrHGwFlehXDQvNacZKUpL3NG62VSA.d9yHFfElxq.PZAmr3py.Dhuhg2J9gA9dP6
 fJTkY4u6z8_3iTPZ2hzWGnc9CQICZ.fLTTPOoVr7LsxMAzPCvnG3_JQnIkmo6xqH5hj33kYnqh9U
 ObcaeE5AB2ceGdZIq99uMDPmRyj3qgaZ3FAAyYMrXr07scbw0x_8Vmz5trwVIMdrjUk2Ux2XBKBv
 l3p6IMJ.WURuSJ9wVObKbLD8T8c4HWZaRq_3wbHkAg7okWvLYmqs6vbJjkDdtB0GAO2JXeH6NtHZ
 IkLY5BHGTGzFgaj4E6fIPgL87PwFynnl_Phe3dS.OBCW_xKkTJC1SaIFl4HJhhiqth3cw6Pkg0t0
 eL60QNFVgel6__dYEmEo3BKeNUxZWt82QOW_y.xNS3SJHUSdu8PePVFJZlK70v2X1xinDPgA6nBO
 zhBT4a7UX6bgHIt4UKGSpvBiMiFzB9GARIENh27Gx90EBikrIZnxmO19YB5xhtn_0iLDLFFef8iJ
 1GqnydDRPh7FU.PjHKcX_pWWcew_9Nzfcll0SexCdhfmaa.MHBxgaXaHmwr9UtXas7_smff4S4x7
 E.jNLXl.zeIOduw8Jqptu6GTea0foS7RV_PAuxdrWH4bMJKcnsftM.nWY174CdQMssrigDSKyr_C
 MbmBKipG11iiI0YTtm0vAdv3wFaOdC5Y2ag0yRfRergJbB9b3ZniG5oRj9KypqAyT5JOTG00aIge
 RNB92d5MbzrTsRbKQ8R.U_7mHeWJ9MjhgV0EShB1F7d.k297TIInAiGaX_Ox9tKEkAX0KGyyr3M5
 4PBl.UUxXFZCxWB1iAiojwW9fERHJqh9.GrQZIDDU.oj5Kn3gRDi0seG8dPanbBzAkn_TiRZxM2J
 HfONhP1usuFBjbMTwghuj7yCJXW4_2yXgi.1JLjXG2OQKdzSJbsWAs.tPpctka9R4aafXFqUAR3f
 lkQVzmQms1uqv.11xT53DWpz7Os9E7fXptbDeggLrxEpl6.ABxgkyj7kxZQaBh6ZnRBJiFkFnW3S
 O91z23p9OqXZnMvfnm8Wi11wRJ3_o3qPfxqixLZ.fHbcnt.vfW5quln6S6nasrunrd7Se1g3CcSW
 5ggbzzVxKSrOWIXR.HP3mwDFFpRvZRRDxi8VRLsj9aCODsANOkRRt7_jG2cuCBFiZoHIPdYFTaXO
 d.TB71uf6fjSgUTtRWYbN4g9BRYeiNzBB0zjRAB_OcPQ0s5NvM9jj9I0LYwaaiGOMU1oJy0pvFjf
 nQn0Io.ynyS76kf59Qp8P2rytQGJrIAhX.q.8Kg4_1DumduoPIisnSHdNxrH9liB.LpC54yigUJi
 gIt_Iq792Hfc1TQDswCwjWpUlJHTSSO2V7vQQdfrHmbAB0nWJdQTD_NPJE_AwVDw7Z1LaciqNjJE
 pAC2tRJiEhJfcIQSF19.WAL6E4SdF9zI2EEo3OmHmEs2qBt6G7oZWU.WSKSA_KiW1UdRscLz6sLm
 W.SZRA_L07i87HZIskmiFZFFSFRs79nxo
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: e613aa9a-a350-41c5-a8e7-1586dc32c6bc
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Wed, 23 Oct 2024 21:22:12 +0000
Received: by hermes--production-gq1-5dd4b47f46-5xsmt (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 8a7972f72a0226c80fd86fd6bd5371c9;
          Wed, 23 Oct 2024 21:22:05 +0000 (UTC)
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
Subject: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
Date: Wed, 23 Oct 2024 14:21:55 -0700
Message-ID: <20241023212158.18718-3-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241023212158.18718-1-casey@schaufler-ca.com>
References: <20241023212158.18718-1-casey@schaufler-ca.com>
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
 net/netlabel/netlabel_unlabeled.c       | 14 +++------
 net/netlabel/netlabel_user.c            |  3 +-
 security/apparmor/include/secid.h       |  5 ++-
 security/apparmor/secid.c               | 26 +++++++--------
 security/security.c                     | 34 +++++++++-----------
 security/selinux/hooks.c                | 23 +++++++++++---
 security/smack/smack_lsm.c              | 42 +++++++++++++++----------
 17 files changed, 118 insertions(+), 121 deletions(-)

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
index 921fa8eeb451..bd7094f225d1 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -437,9 +437,7 @@ int netlbl_unlhsh_add(struct net *net,
 unlhsh_add_return:
 	rcu_read_unlock();
 	if (audit_buf != NULL) {
-		if (security_secid_to_secctx(secid,
-					     &ctx.context,
-					     &ctx.len) == 0) {
+		if (security_secid_to_secctx(secid, &ctx) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", ctx.context);
 			security_release_secctx(&ctx);
 		}
@@ -492,8 +490,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net,
 					  addr->s_addr, mask->s_addr);
 		dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
-					     &ctx.context, &ctx.len) == 0) {
+		    security_secid_to_secctx(entry->secid, &ctx) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", ctx.context);
 			security_release_secctx(&ctx);
 		}
@@ -551,8 +548,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net,
 					  addr, mask);
 		dev_put(dev);
 		if (entry != NULL &&
-		    security_secid_to_secctx(entry->secid,
-					     &ctx.context, &ctx.len) == 0) {
+		    security_secid_to_secctx(entry->secid, &ctx) == 0) {
 			audit_log_format(audit_buf, " sec_obj=%s", ctx.context);
 			security_release_secctx(&ctx);
 		}
@@ -1123,8 +1119,8 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
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

