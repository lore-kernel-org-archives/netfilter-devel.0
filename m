Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B423B3F9D5
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 10:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727259310; cv=none; b=MPukMf8GPhru6FFqB/Nl3Qa4TTZOIDirnVnws4dCrro6jnF8FNTkSFEa1f52HyyhyY9tkjxo1/Ga6rQDZTokrV26BRIswWcv3d/6R2kKh3cCvTvYXyycrE/MsL0PbkJobeCHwk0ia73tX2IYNefGQNfiFRw6Mz7s/o+IvY9ESUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727259310; c=relaxed/simple;
	bh=5yQetbFCJErxLCwTumq/1IWmaxOek8zrOQFzDNKVorg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=GZKc5iIUK8hzXLr1hsLR0ITwKEaRrxl0geARMQhm696Yt92wgVkuCTXRcKaxE6LsHjZ0Ba6W5Jw767AmyirjvPnLgLaeX55QQeVhXSGaXQpkq+g7+DX+XR/xGVPLpajOEBmtBofl4ruqQXBlHRx7eB/nWLgQVywuhpx3baaHhmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack] src: remove unused parameter from build functions
Date: Wed, 25 Sep 2024 12:15:00 +0200
Message-Id: <20240925101500.14003-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nfnl_subsys_handle is never used, remove it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/internal/prototypes.h |  4 ++--
 src/conntrack/api.c           | 22 ++++++++++------------
 src/conntrack/build.c         |  3 +--
 src/expect/api.c              | 20 +++++++++-----------
 src/expect/build.c            |  3 +--
 5 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/include/internal/prototypes.h b/include/internal/prototypes.h
index 82a3f2948e87..36063a245258 100644
--- a/include/internal/prototypes.h
+++ b/include/internal/prototypes.h
@@ -4,7 +4,7 @@
 /*
  * conntrack internal prototypes
  */
-int __build_conntrack(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_conntrack *ct);
+int __build_conntrack(struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_conntrack *ct);
 void __build_tuple(struct nfnlhdr *req, size_t size, const struct __nfct_tuple *t, const int type);
 int __snprintf_conntrack(char *buf, unsigned int len, const struct nf_conntrack *ct, unsigned int type, unsigned int msg_output, unsigned int flags, struct nfct_labelmap *);
 int __snprintf_address(char *buf, unsigned int len, const struct __nfct_tuple *tuple, const char *src_tag, const char *dst_tag);
@@ -44,7 +44,7 @@ int nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple, int
 /*
  * expectation internal prototypes
  */
-int __build_expect(struct nfnl_subsys_handle *ssh, struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_expect *exp);
+int __build_expect(struct nfnlhdr *req, size_t size, uint16_t type, uint16_t flags, const struct nf_expect *exp);
 int __expect_callback(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data);
 int __cmp_expect(const struct nf_expect *exp1, const struct nf_expect *exp2, unsigned int flags);
 int __snprintf_expect(char *buf, unsigned int len, const struct nf_expect *exp, unsigned int type, unsigned int msg_output, unsigned int flags);
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index a96f1016ad0c..f0e038bc43ce 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -781,7 +781,7 @@ int nfct_build_conntrack(struct nfnl_subsys_handle *ssh,
 
 	memset(req, 0, size);
 
-	return __build_conntrack(ssh, req, size, type, flags, ct);
+	return __build_conntrack(req, size, type, flags, ct);
 }
 
 static void nfct_fill_hdr(struct nfnlhdr *req, uint16_t type, uint16_t flags,
@@ -803,14 +803,12 @@ static void nfct_fill_hdr(struct nfnlhdr *req, uint16_t type, uint16_t flags,
 }
 
 static int
-__build_query_ct(struct nfnl_subsys_handle *ssh,
-		 const enum nf_conntrack_query qt,
+__build_query_ct(const enum nf_conntrack_query qt,
 		 const void *data, void *buffer, unsigned int size)
 {
 	struct nfnlhdr *req = buffer;
 	const uint32_t *family = data;
 
-	assert(ssh != NULL);
 	assert(data != NULL);
 	assert(req != NULL);
 
@@ -818,16 +816,16 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 
 	switch(qt) {
 	case NFCT_Q_CREATE:
-		__build_conntrack(ssh, req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL, data);
+		__build_conntrack(req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL, data);
 		break;
 	case NFCT_Q_UPDATE:
-		__build_conntrack(ssh, req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_ACK, data);
+		__build_conntrack(req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_DESTROY:
-		__build_conntrack(ssh, req, size, IPCTNL_MSG_CT_DELETE, NLM_F_REQUEST|NLM_F_ACK, data);
+		__build_conntrack(req, size, IPCTNL_MSG_CT_DELETE, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_GET:
-		__build_conntrack(ssh, req, size, IPCTNL_MSG_CT_GET, NLM_F_REQUEST|NLM_F_ACK, data);
+		__build_conntrack(req, size, IPCTNL_MSG_CT_GET, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_FLUSH:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_DELETE, NLM_F_ACK, *family,
@@ -847,7 +845,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 			      *family, NFNETLINK_V0);
 		break;
 	case NFCT_Q_CREATE_UPDATE:
-		__build_conntrack(ssh, req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK, data);
+		__build_conntrack(req, size, IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_DUMP_FILTER:
 		nfct_fill_hdr(req, IPCTNL_MSG_CT_GET, NLM_F_DUMP, AF_UNSPEC,
@@ -910,7 +908,7 @@ int nfct_build_query(struct nfnl_subsys_handle *ssh,
 		     void *buffer,
 		     unsigned int size)
 {
-	return __build_query_ct(ssh, qt, data, buffer, size);
+	return __build_query_ct(qt, data, buffer, size);
 }
 
 static int __parse_message_type(const struct nlmsghdr *nlh)
@@ -1003,7 +1001,7 @@ int nfct_query(struct nfct_handle *h,
 	assert(h != NULL);
 	assert(data != NULL);
 
-	if (__build_query_ct(h->nfnlssh_ct, qt, data, &u.req, size) == -1)
+	if (__build_query_ct(qt, data, &u.req, size) == -1)
 		return -1;
 
 	return nfnl_query(h->nfnlh, &u.req.nlh);
@@ -1035,7 +1033,7 @@ int nfct_send(struct nfct_handle *h,
 	assert(h != NULL);
 	assert(data != NULL);
 
-	if (__build_query_ct(h->nfnlssh_ct, qt, data, &u.req, size) == -1)
+	if (__build_query_ct(qt, data, &u.req, size) == -1)
 		return -1;
 
 	return nfnl_send(h->nfnlh, &u.req.nlh);
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index f80cfc12d5e3..e8a595a2037e 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -10,8 +10,7 @@
 #include "internal/internal.h"
 #include <libmnl/libmnl.h>
 
-int __build_conntrack(struct nfnl_subsys_handle *ssh,
-		      struct nfnlhdr *req,
+int __build_conntrack(struct nfnlhdr *req,
 		      size_t size,
 		      uint16_t type,
 		      uint16_t flags,
diff --git a/src/expect/api.c b/src/expect/api.c
index b100c72ded50..5cdd33503519 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -515,7 +515,7 @@ int nfexp_build_expect(struct nfnl_subsys_handle *ssh,
 
 	memset(req, 0, size);
 
-	return __build_expect(ssh, req, size, type, flags, exp);
+	return __build_expect(req, size, type, flags, exp);
 }
 
 static void nfexp_fill_hdr(struct nfnlhdr *req, uint16_t type, uint16_t flags,
@@ -537,14 +537,12 @@ static void nfexp_fill_hdr(struct nfnlhdr *req, uint16_t type, uint16_t flags,
 }
 
 static int
-__build_query_exp(struct nfnl_subsys_handle *ssh,
-		  const enum nf_conntrack_query qt,
+__build_query_exp(const enum nf_conntrack_query qt,
 		  const void *data, void *buffer, unsigned int size)
 {
 	struct nfnlhdr *req = buffer;
 	const uint8_t *family = data;
 
-	assert(ssh != NULL);
 	assert(data != NULL);
 	assert(req != NULL);
 
@@ -552,16 +550,16 @@ __build_query_exp(struct nfnl_subsys_handle *ssh,
 
 	switch(qt) {
 	case NFCT_Q_CREATE:
-		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL, data);
+		__build_expect(req, size, IPCTNL_MSG_EXP_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL, data);
 		break;
 	case NFCT_Q_CREATE_UPDATE:
-		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK, data);
+		__build_expect(req, size, IPCTNL_MSG_EXP_NEW, NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_GET:
-		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_GET, NLM_F_REQUEST|NLM_F_ACK, data);
+		__build_expect(req, size, IPCTNL_MSG_EXP_GET, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_DESTROY:
-		__build_expect(ssh, req, size, IPCTNL_MSG_EXP_DELETE, NLM_F_REQUEST|NLM_F_ACK, data);
+		__build_expect(req, size, IPCTNL_MSG_EXP_DELETE, NLM_F_REQUEST|NLM_F_ACK, data);
 		break;
 	case NFCT_Q_FLUSH:
 		nfexp_fill_hdr(req, IPCTNL_MSG_EXP_DELETE, NLM_F_ACK, *family,
@@ -614,7 +612,7 @@ int nfexp_build_query(struct nfnl_subsys_handle *ssh,
 		      void *buffer,
 		      unsigned int size)
 {
-	return __build_query_exp(ssh, qt, data, buffer, size);
+	return __build_query_exp(qt, data, buffer, size);
 }
 
 static int __parse_expect_message_type(const struct nlmsghdr *nlh)
@@ -707,7 +705,7 @@ int nfexp_query(struct nfct_handle *h,
 	assert(h != NULL);
 	assert(data != NULL);
 
-	if (__build_query_exp(h->nfnlssh_exp, qt, data, &u.req, size) == -1)
+	if (__build_query_exp(qt, data, &u.req, size) == -1)
 		return -1;
 
 	return nfnl_query(h->nfnlh, &u.req.nlh);
@@ -739,7 +737,7 @@ int nfexp_send(struct nfct_handle *h,
 	assert(h != NULL);
 	assert(data != NULL);
 
-	if (__build_query_exp(h->nfnlssh_exp, qt, data, &u.req, size) == -1)
+	if (__build_query_exp(qt, data, &u.req, size) == -1)
 		return -1;
 
 	return nfnl_send(h->nfnlh, &u.req.nlh);
diff --git a/src/expect/build.c b/src/expect/build.c
index 1807adce26f6..77a9dd373df0 100644
--- a/src/expect/build.c
+++ b/src/expect/build.c
@@ -10,8 +10,7 @@
 #include "internal/internal.h"
 #include <libmnl/libmnl.h>
 
-int __build_expect(struct nfnl_subsys_handle *ssh,
-		   struct nfnlhdr *req,
+int __build_expect(struct nfnlhdr *req,
 		   size_t size,
 		   uint16_t type,
 		   uint16_t flags,
-- 
2.30.2

