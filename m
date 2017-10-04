From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl,v2 2/4] expr: no need to nul-terminate buffer from expression ->snprintf indirection
Date: Wed,  4 Oct 2017 14:23:21 +0200
Message-ID: <1507119803-15127-2-git-send-email-pablo@netfilter.org>
References: <1507119803-15127-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751699AbdJDMXb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 08:23:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 054921DA084
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6214DA86E
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 832A4DA86E
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:27 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4328440584D0
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:23:27 +0200 (CEST)
In-Reply-To: <1507119803-15127-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

->snprintf() is always called via nftnl_expr_snprintf() wrapper, which
is already dealing with this corner case for us.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/bitwise.c   | 3 ---
 src/expr/byteorder.c | 3 ---
 src/expr/cmp.c       | 3 ---
 src/expr/counter.c   | 3 ---
 src/expr/ct.c        | 3 ---
 src/expr/dup.c       | 3 ---
 src/expr/dynset.c    | 3 ---
 src/expr/exthdr.c    | 3 ---
 src/expr/fib.c       | 3 ---
 src/expr/fwd.c       | 3 ---
 src/expr/hash.c      | 3 ---
 src/expr/immediate.c | 3 ---
 src/expr/limit.c     | 3 ---
 src/expr/log.c       | 3 ---
 src/expr/lookup.c    | 3 ---
 src/expr/masq.c      | 3 ---
 src/expr/match.c     | 3 ---
 src/expr/meta.c      | 3 ---
 src/expr/nat.c       | 3 ---
 src/expr/numgen.c    | 3 ---
 src/expr/objref.c    | 3 ---
 src/expr/payload.c   | 3 ---
 src/expr/queue.c     | 3 ---
 src/expr/quota.c     | 3 ---
 src/expr/range.c     | 3 ---
 src/expr/redir.c     | 3 ---
 src/expr/reject.c    | 3 ---
 src/expr/rt.c        | 3 ---
 src/expr/target.c    | 3 ---
 29 files changed, 87 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index ff9ade4d86d0..a89734b5f2d4 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -257,9 +257,6 @@ static int
 nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
 			    uint32_t flags, const struct nftnl_expr *e)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_bitwise_snprintf_default(buf, size, e);
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 4bb95b497701..47c04cfea69f 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -272,9 +272,6 @@ static int
 nftnl_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_byteorder_snprintf_default(buf, size, e);
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 7bafaec573e7..b26d0eb08bb2 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -246,9 +246,6 @@ static int
 nftnl_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
 			uint32_t flags, const struct nftnl_expr *e)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_cmp_snprintf_default(buf, size, e);
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 5c196d451843..21901e892471 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -164,9 +164,6 @@ static int nftnl_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_counter_snprintf_default(buf, len, e);
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 021a27795a69..6f87a72487ae 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -317,9 +317,6 @@ static int
 nftnl_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_ct_snprintf_default(buf, len, e);
diff --git a/src/expr/dup.c b/src/expr/dup.c
index e2171f4ef1fb..ed8e6208cfab 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -170,9 +170,6 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 static int nftnl_expr_dup_snprintf(char *buf, size_t len, uint32_t type,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_dup_snprintf_default(buf, len, e, flags);
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 2755d492e085..160d0e15c151 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -314,9 +314,6 @@ static int
 nftnl_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_dynset_snprintf_default(buf, size, e);
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 11766fafc027..75cafbc113f7 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -339,9 +339,6 @@ static int
 nftnl_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_exthdr_snprintf_default(buf, len, e);
diff --git a/src/expr/fib.c b/src/expr/fib.c
index cbadeef7ce49..b922b26681e7 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -236,9 +236,6 @@ static int
 nftnl_expr_fib_snprintf(char *buf, size_t len, uint32_t type,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_fib_snprintf_default(buf, len, e);
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 38923df64760..1312ea10b07c 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -147,9 +147,6 @@ static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
 static int nftnl_expr_fwd_snprintf(char *buf, size_t len, uint32_t type,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_fwd_snprintf_default(buf, len, e, flags);
diff --git a/src/expr/hash.c b/src/expr/hash.c
index 066c790d5b50..fcc4fa5c0516 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -288,9 +288,6 @@ static int
 nftnl_expr_hash_snprintf(char *buf, size_t len, uint32_t type,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_hash_snprintf_default(buf, len, e);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index aba84ea0823e..b0570bd539a4 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -262,9 +262,6 @@ static int
 nftnl_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_immediate_snprintf_default(buf, len, e, flags);
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 8e1f02abb617..856ab1839b0a 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -243,9 +243,6 @@ static int
 nftnl_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_limit_snprintf_default(buf, len, e);
diff --git a/src/expr/log.c b/src/expr/log.c
index 161327b4b5f2..86d965136cd4 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -301,9 +301,6 @@ static int
 nftnl_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 			uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_log_snprintf_default(buf, len, e);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 32220a30dbce..5fcb81f3a7a2 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -242,9 +242,6 @@ static int
 nftnl_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_lookup_snprintf_default(buf, size, e);
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 1c75ee9cdd53..7c235d3b0bdc 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -190,9 +190,6 @@ static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
 static int nftnl_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
 				    uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_masq_snprintf_default(buf, len, e);
diff --git a/src/expr/match.c b/src/expr/match.c
index af659b3821c8..dd09e1e85192 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -200,9 +200,6 @@ nftnl_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nftnl_expr_match *match = nftnl_expr_data(e);
 
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
diff --git a/src/expr/meta.c b/src/expr/meta.c
index b5c27e66dc51..2c758412bf2e 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -252,9 +252,6 @@ static int
 nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_meta_snprintf_default(buf, len, e);
diff --git a/src/expr/nat.c b/src/expr/nat.c
index 350633fd5e0a..92713033a6e7 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -339,9 +339,6 @@ static int
 nftnl_expr_nat_snprintf(char *buf, size_t size, uint32_t type,
 			uint32_t flags, const struct nftnl_expr *e)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_nat_snprintf_default(buf, size, e);
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 9b5b1b789206..1369b01d9401 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -224,9 +224,6 @@ static int
 nftnl_expr_ng_snprintf(char *buf, size_t len, uint32_t type,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_ng_snprintf_default(buf, len, e);
diff --git a/src/expr/objref.c b/src/expr/objref.c
index b4b3383e8a7c..4cfa3cbfbd2b 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -236,9 +236,6 @@ static int nftnl_expr_objref_snprintf(char *buf, size_t len, uint32_t type,
 				      uint32_t flags,
 				      const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_objref_snprintf_default(buf, len, e);
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 897fc7746166..91e1587ff239 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -290,9 +290,6 @@ nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		if (payload->sreg)
diff --git a/src/expr/queue.c b/src/expr/queue.c
index e0fb785a490b..a392a271a6fb 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -235,9 +235,6 @@ static int
 nftnl_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_queue_snprintf_default(buf, len, e);
diff --git a/src/expr/quota.c b/src/expr/quota.c
index c247b0a03341..667e6e17c28c 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -183,9 +183,6 @@ static int nftnl_expr_quota_snprintf(char *buf, size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_quota_snprintf_default(buf, len, e);
diff --git a/src/expr/range.c b/src/expr/range.c
index c7bb7c7f3d7a..b2789ffaada3 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -263,9 +263,6 @@ static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
 static int nftnl_expr_range_snprintf(char *buf, size_t size, uint32_t type,
 				     uint32_t flags, const struct nftnl_expr *e)
 {
-	if (size)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_range_snprintf_default(buf, size, e);
diff --git a/src/expr/redir.c b/src/expr/redir.c
index 9fb634afaa19..b2aa3453870a 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -204,9 +204,6 @@ static int
 nftnl_expr_redir_snprintf(char *buf, size_t len, uint32_t type,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_redir_snprintf_default(buf, len, e);
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 1e6fdf5c5ba0..11d8b20096ae 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -164,9 +164,6 @@ static int
 nftnl_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_reject_snprintf_default(buf, len, e);
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 10cb1e27ce68..62c01a0be0f5 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -203,9 +203,6 @@ static int
 nftnl_expr_rt_snprintf(char *buf, size_t len, uint32_t type,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_rt_snprintf_default(buf, len, e);
diff --git a/src/expr/target.c b/src/expr/target.c
index 3c58b03d20dd..ed4bf7df6328 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -200,9 +200,6 @@ nftnl_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nftnl_expr_target *target = nftnl_expr_data(e);
 
-	if (len)
-		buf[0] = '\0';
-
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
-- 
2.1.4

