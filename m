From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/4] security: secid_to_secctx returns len when data is NULL
Date: Wed, 13 Oct 2010 16:24:48 -0400
Message-ID: <20101013202448.15272.35041.stgit@paris.rdu.redhat.com>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org, selinux@tycho.nsa.gov
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab0JMUZ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:25:58 -0400
In-Reply-To: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the (long ago) interface change to have the secid_to_secctx functions
do the string allocation instead of having the caller do the allocation we
lost the ability to query the security server for the length of the
upcoming string.  The SECMARK code would like to allocate a netlink skb
with enough length to hold the string but it is just too unclean to do the
string allocation twice or to do the allocation the first time and hold
onto the string and slen.  This patch adds the ability to call
security_secid_to_secctx() with a NULL data pointer and it will just set
the slen pointer.

Signed-off-by: Eric Paris <eparis@redhat.com>
Reviewed-by: Paul Moore <paul.moore@hp.com>
---

 include/linux/security.h       |    6 +++++-
 security/selinux/ss/services.c |   11 +++++++++--
 security/smack/smack_lsm.c     |    3 ++-
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index f050119..44aeace 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1286,9 +1286,13 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	Return 0 if permission is granted.
  *
  * @secid_to_secctx:
- *	Convert secid to security context.
+ *	Convert secid to security context.  If secdata is NULL the length of
+ *	the result will be returned in seclen, but no secdata will be returned.
+ *	This does mean that the length could change between calls to check the
+ *	length and the next call which actually allocates and returns the secdata.
  *	@secid contains the security ID.
  *	@secdata contains the pointer that stores the converted security context.
+ *	@seclen pointer which contains the length of the data
  * @secctx_to_secid:
  *	Convert security context to secid.
  *	@secid contains the pointer to the generated security ID.
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 73508af..1d4955a 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -998,7 +998,8 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
 {
 	char *scontextp;
 
-	*scontext = NULL;
+	if (scontext)
+		*scontext = NULL;
 	*scontext_len = 0;
 
 	if (context->len) {
@@ -1015,6 +1016,9 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
 	*scontext_len += strlen(sym_name(&policydb, SYM_TYPES, context->type - 1)) + 1;
 	*scontext_len += mls_compute_context_len(context);
 
+	if (!scontext)
+		return 0;
+
 	/* Allocate space for the context; caller must free this space. */
 	scontextp = kmalloc(*scontext_len, GFP_ATOMIC);
 	if (!scontextp)
@@ -1054,7 +1058,8 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 	struct context *context;
 	int rc = 0;
 
-	*scontext = NULL;
+	if (scontext)
+		*scontext = NULL;
 	*scontext_len  = 0;
 
 	if (!ss_initialized) {
@@ -1062,6 +1067,8 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
 			char *scontextp;
 
 			*scontext_len = strlen(initial_sid_to_string[sid]) + 1;
+			if (!scontext)
+				goto out;
 			scontextp = kmalloc(*scontext_len, GFP_ATOMIC);
 			if (!scontextp) {
 				rc = -ENOMEM;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 174aec4..bc39f40 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3004,7 +3004,8 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
 {
 	char *sp = smack_from_secid(secid);
 
-	*secdata = sp;
+	if (secdata)
+		*secdata = sp;
 	*seclen = strlen(sp);
 	return 0;
 }

