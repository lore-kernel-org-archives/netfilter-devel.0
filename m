From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: Re: [PATCH 3/3] libnetfilter-conntrack byte alignment
Date: Mon, 16 Jun 2008 21:32:49 +0100
Message-ID: <1213648369.29727.13.camel@pumper.lan.luxnet.ch>
References: <1212488483.29489.42.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59039 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753603AbYFPUcw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:32:52 -0400
In-Reply-To: <1212488483.29489.42.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use union of char buffer and message header to ensure proper byte
alignment.

Signed-off-by: Fabian Hugelshofer <hugelshofer2006@gmx.ch>

diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index b1347dc..58efd32 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -563,16 +563,18 @@ int nfct_query(struct nfct_handle *h,
 	       const void *data)
 {
 	size_t size = 4096;	/* enough for now */
-	char buffer[4096];
-	struct nfnlhdr *req = (struct nfnlhdr *) buffer;
+	union {
+		char buffer[size];
+		struct nfnlhdr req;
+	} u;
 
 	assert(h != NULL);
 	assert(data != NULL);
 
-	if (nfct_build_query(h->nfnlssh_ct, qt, data, req, size) == -1)
+	if (nfct_build_query(h->nfnlssh_ct, qt, data, &u.req, size) == -1)
 		return -1;
 
-	return nfnl_query(h->nfnlh, &req->nlh);
+	return nfnl_query(h->nfnlh, &u.req.nlh);
 }
 
 /**
@@ -593,16 +595,18 @@ int nfct_send(struct nfct_handle *h,
 	      const void *data)
 {
 	size_t size = 4096;	/* enough for now */
-	char buffer[4096];
-	struct nfnlhdr *req = (struct nfnlhdr *) buffer;
+	union {
+		char buffer[size];
+		struct nfnlhdr req;
+	} u;
 
 	assert(h != NULL);
 	assert(data != NULL);
 
-	if (nfct_build_query(h->nfnlssh_ct, qt, data, req, size) == -1)
+	if (nfct_build_query(h->nfnlssh_ct, qt, data, &u.req, size) == -1)
 		return -1;
 
-	return nfnl_send(h->nfnlh, &req->nlh);
+	return nfnl_send(h->nfnlh, &u.req.nlh);
 }
 
 
diff --git a/src/expect/api.c b/src/expect/api.c
index eefc294..ab804ca 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -507,16 +507,18 @@ int nfexp_query(struct nfct_handle *h,
 	        const void *data)
 {
 	size_t size = 4096;	/* enough for now */
-	char buffer[4096];
-	struct nfnlhdr *req = (struct nfnlhdr *) buffer;
+	union {
+		char buffer[size];
+		struct nfnlhdr req;
+	} u;
 
 	assert(h != NULL);
 	assert(data != NULL);
 
-	if (nfexp_build_query(h->nfnlssh_exp, qt, data, req, size) == -1)
+	if (nfexp_build_query(h->nfnlssh_exp, qt, data, &u.req, size) == -1)
 		return -1;
 
-	return nfnl_query(h->nfnlh, &req->nlh);
+	return nfnl_query(h->nfnlh, &u.req.nlh);
 }
 
 /**


