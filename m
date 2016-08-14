From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH libnetfilter_conntrack] src: Make the library compile under clang
Date: Sun, 14 Aug 2016 13:59:01 -0700
Message-ID: <1471208341-24673-1-git-send-email-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34517 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbcHNU7L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Aug 2016 16:59:11 -0400
Received: by mail-pa0-f48.google.com with SMTP id fi15so10872527pac.1
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Aug 2016 13:59:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

clang treats "char buffer[size]" inside a union as VLAIS unless |size|
is const:

src/conntrack/api.c:992:8: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
                char buffer[size];
                     ^

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 src/conntrack/api.c | 4 ++--
 src/expect/api.c    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index e4d4acc312bb..bed2e42c8f43 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -955,7 +955,7 @@ int nfct_query(struct nfct_handle *h,
 	       const enum nf_conntrack_query qt,
 	       const void *data)
 {
-	size_t size = 4096;	/* enough for now */
+	const size_t size = 4096;	/* enough for now */
 	union {
 		char buffer[size];
 		struct nfnlhdr req;
@@ -987,7 +987,7 @@ int nfct_send(struct nfct_handle *h,
 	      const enum nf_conntrack_query qt,
 	      const void *data)
 {
-	size_t size = 4096;	/* enough for now */
+	const size_t size = 4096;	/* enough for now */
 	union {
 		char buffer[size];
 		struct nfnlhdr req;
diff --git a/src/expect/api.c b/src/expect/api.c
index 8ff20e2821e3..3f1763038ede 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -669,7 +669,7 @@ int nfexp_query(struct nfct_handle *h,
 	        const enum nf_conntrack_query qt,
 	        const void *data)
 {
-	size_t size = 4096;	/* enough for now */
+	const size_t size = 4096;	/* enough for now */
 	union {
 		char buffer[size];
 		struct nfnlhdr req;
@@ -701,7 +701,7 @@ int nfexp_send(struct nfct_handle *h,
 	       const enum nf_conntrack_query qt,
 	       const void *data)
 {
-	size_t size = 4096;	/* enough for now */
+	const size_t size = 4096;	/* enough for now */
 	union {
 		char buffer[size];
 		struct nfnlhdr req;
-- 
2.8.0.rc3.226.g39d4020

