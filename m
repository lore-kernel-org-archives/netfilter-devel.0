From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH libnftnl] src: Buffer is null terminated.
Date: Wed, 20 Sep 2017 21:53:09 +0530
Message-ID: <20170920162309.5852-2-rvarsha016@gmail.com>
References: <20170920162309.5852-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33775 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbdITQYH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 12:24:07 -0400
Received: by mail-pf0-f195.google.com with SMTP id h4so1386125pfk.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2017 09:24:06 -0700 (PDT)
In-Reply-To: <20170920162309.5852-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In _snprintf() functions definition the buffer is null terminated.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 src/chain.c          | 13 +++++++++++--
 src/common.c         |  6 ++++++
 src/expr.c           |  3 +++
 src/expr/bitwise.c   |  3 +++
 src/expr/byteorder.c |  3 +++
 src/expr/cmp.c       |  3 +++
 src/expr/counter.c   |  3 +++
 src/expr/ct.c        |  3 +++
 src/expr/data_reg.c  |  3 +++
 src/expr/dup.c       |  3 +++
 src/expr/dynset.c    |  2 ++
 src/expr/exthdr.c    |  3 +++
 src/expr/fib.c       |  3 +++
 src/expr/fwd.c       |  3 +++
 src/expr/hash.c      |  3 +++
 src/expr/immediate.c |  3 +++
 src/expr/limit.c     |  3 +++
 src/expr/log.c       |  3 +++
 src/expr/lookup.c    |  2 ++
 src/expr/masq.c      |  3 +++
 src/expr/match.c     |  3 +++
 src/expr/meta.c      |  3 +++
 src/expr/nat.c       |  3 +++
 src/expr/numgen.c    |  3 +++
 src/expr/objref.c    |  3 +++
 src/expr/payload.c   |  3 +++
 src/expr/queue.c     |  2 ++
 src/expr/quota.c     |  3 +++
 src/expr/range.c     |  3 +++
 src/expr/redir.c     |  3 +++
 src/expr/reject.c    |  3 +++
 src/expr/rt.c        |  3 +++
 src/expr/target.c    |  3 +++
 src/gen.c            | 11 ++++++++++-
 src/obj/counter.c    |  3 +++
 src/obj/ct_helper.c  |  3 +++
 src/obj/limit.c      |  3 +++
 src/obj/quota.c      |  3 +++
 src/object.c         |  9 +++++++++
 src/rule.c           |  9 +++++++++
 src/ruleset.c        |  9 +++++++++
 src/set.c            |  9 +++++++++
 src/set_elem.c       |  8 ++++++++
 src/table.c          |  9 +++++++++
 44 files changed, 182 insertions(+), 3 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 44c2613..46189ef 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -827,6 +827,9 @@ static int nftnl_chain_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
+	if (size)
+		buf[0] = '\0';
+
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
@@ -853,14 +856,20 @@ static int nftnl_chain_cmd_snprintf(char *buf, size_t size,
 int nftnl_chain_snprintf(char *buf, size_t size, const struct nftnl_chain *c,
 			 uint32_t type, uint32_t flags)
 {
-	return nftnl_chain_cmd_snprintf(buf, size, c, nftnl_flag2cmd(flags), type,
-				      flags);
+	if (size)
+		buf[0] = '\0';
+
+	return nftnl_chain_cmd_snprintf(buf, size, c, nftnl_flag2cmd(flags),
+					type, flags);
 }
 EXPORT_SYMBOL(nftnl_chain_snprintf);
 
 static int nftnl_chain_do_snprintf(char *buf, size_t size, const void *c,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_chain_snprintf(buf, size, c, type, flags);
 }
 
diff --git a/src/common.c b/src/common.c
index a95883c..ba5a49f 100644
--- a/src/common.c
+++ b/src/common.c
@@ -94,6 +94,9 @@ EXPORT_SYMBOL(nftnl_parse_perror);
 int nftnl_cmd_header_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t type,
 			    uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	NFTNL_BUF_INIT(b, buf, size);
 
 	if (cmd == NFTNL_CMD_UNSPEC)
@@ -135,6 +138,9 @@ int nftnl_cmd_header_fprintf(FILE *fp, uint32_t cmd, uint32_t type,
 int nftnl_cmd_footer_snprintf(char *buf, size_t size, uint32_t cmd, uint32_t type,
 			    uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	NFTNL_BUF_INIT(b, buf, size);
 
 	if (cmd == NFTNL_CMD_UNSPEC)
diff --git a/src/expr.c b/src/expr.c
index 475ef6b..7438dc1 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -281,6 +281,9 @@ int nftnl_expr_snprintf(char *buf, size_t size, const struct nftnl_expr *expr,
 	int ret;
 	unsigned int offset = 0, remain = size;
 
+	if (size)
+		buf[0] = '\0';
+
 	if (!expr->ops->snprintf)
 		return 0;
 
diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index 865aaf0..2797d33 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -257,6 +257,9 @@ static int
 nftnl_expr_bitwise_snprintf(char *buf, size_t size, uint32_t type,
 			    uint32_t flags, const struct nftnl_expr *e)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_bitwise_snprintf_default(buf, size, e);
diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
index 47c04cf..4bb95b4 100644
--- a/src/expr/byteorder.c
+++ b/src/expr/byteorder.c
@@ -272,6 +272,9 @@ static int
 nftnl_expr_byteorder_snprintf(char *buf, size_t size, uint32_t type,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_byteorder_snprintf_default(buf, size, e);
diff --git a/src/expr/cmp.c b/src/expr/cmp.c
index 8156d69..1276a0c 100644
--- a/src/expr/cmp.c
+++ b/src/expr/cmp.c
@@ -246,6 +246,9 @@ static int
 nftnl_expr_cmp_snprintf(char *buf, size_t size, uint32_t type,
 			uint32_t flags, const struct nftnl_expr *e)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_cmp_snprintf_default(buf, size, e);
diff --git a/src/expr/counter.c b/src/expr/counter.c
index 21901e8..5c196d4 100644
--- a/src/expr/counter.c
+++ b/src/expr/counter.c
@@ -164,6 +164,9 @@ static int nftnl_expr_counter_snprintf(char *buf, size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_counter_snprintf_default(buf, len, e);
diff --git a/src/expr/ct.c b/src/expr/ct.c
index 82aad58..8ed3cf4 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -317,6 +317,9 @@ static int
 nftnl_expr_ct_snprintf(char *buf, size_t len, uint32_t type,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_ct_snprintf_default(buf, len, e);
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 3abe0df..85b356e 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -194,6 +194,9 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    uint32_t output_format, uint32_t flags,
 			    int reg_type)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch(reg_type) {
 	case DATA_VALUE:
 		switch(output_format) {
diff --git a/src/expr/dup.c b/src/expr/dup.c
index ed8e620..e2171f4 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -170,6 +170,9 @@ static int nftnl_expr_dup_snprintf_default(char *buf, size_t len,
 static int nftnl_expr_dup_snprintf(char *buf, size_t len, uint32_t type,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_dup_snprintf_default(buf, len, e, flags);
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 68fa14e..2d14238 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -314,6 +314,8 @@ static int
 nftnl_expr_dynset_snprintf(char *buf, size_t size, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
+	if (size)
+		buf[0] = '\0';
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/exthdr.c b/src/expr/exthdr.c
index 75cafbc..11766fa 100644
--- a/src/expr/exthdr.c
+++ b/src/expr/exthdr.c
@@ -339,6 +339,9 @@ static int
 nftnl_expr_exthdr_snprintf(char *buf, size_t len, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_exthdr_snprintf_default(buf, len, e);
diff --git a/src/expr/fib.c b/src/expr/fib.c
index b922b26..cbadeef 100644
--- a/src/expr/fib.c
+++ b/src/expr/fib.c
@@ -236,6 +236,9 @@ static int
 nftnl_expr_fib_snprintf(char *buf, size_t len, uint32_t type,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_fib_snprintf_default(buf, len, e);
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index 1312ea1..38923df 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -147,6 +147,9 @@ static int nftnl_expr_fwd_snprintf_default(char *buf, size_t len,
 static int nftnl_expr_fwd_snprintf(char *buf, size_t len, uint32_t type,
 				   uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_fwd_snprintf_default(buf, len, e, flags);
diff --git a/src/expr/hash.c b/src/expr/hash.c
index fcc4fa5..066c790 100644
--- a/src/expr/hash.c
+++ b/src/expr/hash.c
@@ -288,6 +288,9 @@ static int
 nftnl_expr_hash_snprintf(char *buf, size_t len, uint32_t type,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_hash_snprintf_default(buf, len, e);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index 8a858da..9eb6508 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -262,6 +262,9 @@ static int
 nftnl_expr_immediate_snprintf(char *buf, size_t len, uint32_t type,
 			      uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_immediate_snprintf_default(buf, len, e, flags);
diff --git a/src/expr/limit.c b/src/expr/limit.c
index 856ab18..8e1f02a 100644
--- a/src/expr/limit.c
+++ b/src/expr/limit.c
@@ -243,6 +243,9 @@ static int
 nftnl_expr_limit_snprintf(char *buf, size_t len, uint32_t type,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_limit_snprintf_default(buf, len, e);
diff --git a/src/expr/log.c b/src/expr/log.c
index 86d9651..161327b 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -301,6 +301,9 @@ static int
 nftnl_expr_log_snprintf(char *buf, size_t len, uint32_t type,
 			uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_log_snprintf_default(buf, len, e);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index e5adfd4..5840b47 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -242,6 +242,8 @@ static int
 nftnl_expr_lookup_snprintf(char *buf, size_t size, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
+	if (size)
+		buf[0] = '\0';
 
 	switch(type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/masq.c b/src/expr/masq.c
index 7c235d3..1c75ee9 100644
--- a/src/expr/masq.c
+++ b/src/expr/masq.c
@@ -190,6 +190,9 @@ static int nftnl_expr_masq_snprintf_default(char *buf, size_t len,
 static int nftnl_expr_masq_snprintf(char *buf, size_t len, uint32_t type,
 				    uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_masq_snprintf_default(buf, len, e);
diff --git a/src/expr/match.c b/src/expr/match.c
index dd09e1e..af659b3 100644
--- a/src/expr/match.c
+++ b/src/expr/match.c
@@ -200,6 +200,9 @@ nftnl_expr_match_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nftnl_expr_match *match = nftnl_expr_data(e);
 
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
diff --git a/src/expr/meta.c b/src/expr/meta.c
index 2c75841..b5c27e6 100644
--- a/src/expr/meta.c
+++ b/src/expr/meta.c
@@ -252,6 +252,9 @@ static int
 nftnl_expr_meta_snprintf(char *buf, size_t len, uint32_t type,
 			 uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_meta_snprintf_default(buf, len, e);
diff --git a/src/expr/nat.c b/src/expr/nat.c
index ac189e6..55e6de8 100644
--- a/src/expr/nat.c
+++ b/src/expr/nat.c
@@ -339,6 +339,9 @@ static int
 nftnl_expr_nat_snprintf(char *buf, size_t size, uint32_t type,
 			uint32_t flags, const struct nftnl_expr *e)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_nat_snprintf_default(buf, size, e);
diff --git a/src/expr/numgen.c b/src/expr/numgen.c
index 1369b01..9b5b1b7 100644
--- a/src/expr/numgen.c
+++ b/src/expr/numgen.c
@@ -224,6 +224,9 @@ static int
 nftnl_expr_ng_snprintf(char *buf, size_t len, uint32_t type,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_ng_snprintf_default(buf, len, e);
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 4cfa3cb..b4b3383 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -236,6 +236,9 @@ static int nftnl_expr_objref_snprintf(char *buf, size_t len, uint32_t type,
 				      uint32_t flags,
 				      const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_objref_snprintf_default(buf, len, e);
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 91e1587..897fc77 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -290,6 +290,9 @@ nftnl_expr_payload_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nftnl_expr_payload *payload = nftnl_expr_data(e);
 
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		if (payload->sreg)
diff --git a/src/expr/queue.c b/src/expr/queue.c
index f62db9f..e0fb785 100644
--- a/src/expr/queue.c
+++ b/src/expr/queue.c
@@ -235,6 +235,8 @@ static int
 nftnl_expr_queue_snprintf(char *buf, size_t len, uint32_t type,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
 
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
diff --git a/src/expr/quota.c b/src/expr/quota.c
index 667e6e1..c247b0a 100644
--- a/src/expr/quota.c
+++ b/src/expr/quota.c
@@ -183,6 +183,9 @@ static int nftnl_expr_quota_snprintf(char *buf, size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_quota_snprintf_default(buf, len, e);
diff --git a/src/expr/range.c b/src/expr/range.c
index b2789ff..c7bb7c7 100644
--- a/src/expr/range.c
+++ b/src/expr/range.c
@@ -263,6 +263,9 @@ static int nftnl_expr_range_snprintf_default(char *buf, size_t size,
 static int nftnl_expr_range_snprintf(char *buf, size_t size, uint32_t type,
 				     uint32_t flags, const struct nftnl_expr *e)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_range_snprintf_default(buf, size, e);
diff --git a/src/expr/redir.c b/src/expr/redir.c
index b2aa345..9fb634a 100644
--- a/src/expr/redir.c
+++ b/src/expr/redir.c
@@ -204,6 +204,9 @@ static int
 nftnl_expr_redir_snprintf(char *buf, size_t len, uint32_t type,
 			  uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_redir_snprintf_default(buf, len, e);
diff --git a/src/expr/reject.c b/src/expr/reject.c
index 11d8b20..1e6fdf5 100644
--- a/src/expr/reject.c
+++ b/src/expr/reject.c
@@ -164,6 +164,9 @@ static int
 nftnl_expr_reject_snprintf(char *buf, size_t len, uint32_t type,
 			   uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_reject_snprintf_default(buf, len, e);
diff --git a/src/expr/rt.c b/src/expr/rt.c
index 62c01a0..10cb1e2 100644
--- a/src/expr/rt.c
+++ b/src/expr/rt.c
@@ -203,6 +203,9 @@ static int
 nftnl_expr_rt_snprintf(char *buf, size_t len, uint32_t type,
 		       uint32_t flags, const struct nftnl_expr *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_expr_rt_snprintf_default(buf, len, e);
diff --git a/src/expr/target.c b/src/expr/target.c
index ed4bf7d..3c58b03 100644
--- a/src/expr/target.c
+++ b/src/expr/target.c
@@ -200,6 +200,9 @@ nftnl_expr_target_snprintf(char *buf, size_t len, uint32_t type,
 {
 	struct nftnl_expr_target *target = nftnl_expr_data(e);
 
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return snprintf(buf, len, "name %s rev %u ",
diff --git a/src/gen.c b/src/gen.c
index e1d5280..a03648b 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -168,6 +168,9 @@ static int nftnl_gen_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
+	if (size)
+		buf[0] = '\0';
+
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
@@ -188,7 +191,10 @@ static int nftnl_gen_cmd_snprintf(char *buf, size_t size,
 
 int nftnl_gen_snprintf(char *buf, size_t size, const struct nftnl_gen *gen,
 		       uint32_t type, uint32_t flags)
-{;
+{
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_gen_cmd_snprintf(buf, size, gen, nftnl_flag2cmd(flags), type,
 				    flags);
 }
@@ -197,6 +203,9 @@ EXPORT_SYMBOL(nftnl_gen_snprintf);
 static int nftnl_gen_do_snprintf(char *buf, size_t size, const void *gen,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf = '\0';
+
 	return nftnl_gen_snprintf(buf, size, gen, type, flags);
 }
 
diff --git a/src/obj/counter.c b/src/obj/counter.c
index beadc93..332bb2b 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -158,6 +158,9 @@ static int nftnl_obj_counter_snprintf(char *buf, size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_obj *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_obj_counter_snprintf_default(buf, len, e);
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index d6d3111..62569fe 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -185,6 +185,9 @@ static int nftnl_obj_ct_helper_snprintf(char *buf, size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_obj *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_obj_ct_helper_snprintf_default(buf, len, e);
diff --git a/src/obj/limit.c b/src/obj/limit.c
index 8cf0faa..7f8bcf7 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -212,6 +212,9 @@ static int nftnl_obj_limit_snprintf(char *buf, size_t len, uint32_t type,
 				    uint32_t flags,
 				    const struct nftnl_obj *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_obj_limit_snprintf_default(buf, len, e);
diff --git a/src/obj/quota.c b/src/obj/quota.c
index d5757b2..6d36784 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -179,6 +179,9 @@ static int nftnl_obj_quota_snprintf(char *buf, size_t len, uint32_t type,
 				       uint32_t flags,
 				       const struct nftnl_obj *e)
 {
+	if (len)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 		return nftnl_obj_quota_snprintf_default(buf, len, e);
diff --git a/src/object.c b/src/object.c
index d15ec10..8dc83b3 100644
--- a/src/object.c
+++ b/src/object.c
@@ -448,6 +448,9 @@ static int nftnl_obj_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
+	if (size)
+		buf[0] = '\0';
+
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
@@ -474,6 +477,9 @@ static int nftnl_obj_cmd_snprintf(char *buf, size_t size,
 int nftnl_obj_snprintf(char *buf, size_t size, const struct nftnl_obj *obj,
 		       uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_obj_cmd_snprintf(buf, size, obj, nftnl_flag2cmd(flags),
 				      type, flags);
 }
@@ -482,6 +488,9 @@ EXPORT_SYMBOL(nftnl_obj_snprintf);
 static int nftnl_obj_do_snprintf(char *buf, size_t size, const void *obj,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_obj_snprintf(buf, size, obj, type, flags);
 }
 
diff --git a/src/rule.c b/src/rule.c
index 5df8216..04788f4 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -792,6 +792,9 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 	int ret, remain = size, offset = 0;
 	uint32_t inner_flags = flags;
 
+	if (size)
+		buf[0] = '\0';
+
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
@@ -822,6 +825,9 @@ static int nftnl_rule_cmd_snprintf(char *buf, size_t size,
 int nftnl_rule_snprintf(char *buf, size_t size, const struct nftnl_rule *r,
 			uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_rule_cmd_snprintf(buf, size, r, nftnl_flag2cmd(flags), type,
 				     flags);
 }
@@ -830,6 +836,9 @@ EXPORT_SYMBOL(nftnl_rule_snprintf);
 static int nftnl_rule_do_snprintf(char *buf, size_t size, const void *r,
 				  uint32_t cmd, uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_rule_snprintf(buf, size, r, type, flags);
 }
 
diff --git a/src/ruleset.c b/src/ruleset.c
index aa23395..443388f 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -846,6 +846,9 @@ nftnl_ruleset_do_snprintf(char *buf, size_t size, const struct nftnl_ruleset *rs
 	void *prev = NULL;
 	uint32_t inner_flags = flags;
 
+	if (size)
+		buf[0] = '\0';
+
 	/* dont pass events flags to child calls of _snprintf() */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
@@ -919,6 +922,9 @@ static int nftnl_ruleset_cmd_snprintf(char *buf, size_t size,
 				    const struct nftnl_ruleset *r, uint32_t cmd,
 				    uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 	case NFTNL_OUTPUT_JSON:
@@ -933,6 +939,9 @@ static int nftnl_ruleset_cmd_snprintf(char *buf, size_t size,
 int nftnl_ruleset_snprintf(char *buf, size_t size, const struct nftnl_ruleset *r,
 			 uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	switch (type) {
 	case NFTNL_OUTPUT_DEFAULT:
 	case NFTNL_OUTPUT_JSON:
diff --git a/src/set.c b/src/set.c
index 720177b..3147bf2 100644
--- a/src/set.c
+++ b/src/set.c
@@ -895,6 +895,9 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 	if (type == NFTNL_OUTPUT_XML)
 		return 0;
 
+	if (size)
+		buf[0] = '\0';
+
 	/* prevent set_elems to print as events */
 	inner_flags &= ~NFTNL_OF_EVENT_ANY;
 
@@ -925,6 +928,9 @@ static int nftnl_set_cmd_snprintf(char *buf, size_t size,
 int nftnl_set_snprintf(char *buf, size_t size, const struct nftnl_set *s,
 		       uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_set_cmd_snprintf(buf, size, s, nftnl_flag2cmd(flags), type,
 				    flags);
 }
@@ -933,6 +939,9 @@ EXPORT_SYMBOL(nftnl_set_snprintf);
 static int nftnl_set_do_snprintf(char *buf, size_t size, const void *s,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_set_snprintf(buf, size, s, type, flags);
 }
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 40fbf33..9b59744 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -696,6 +696,8 @@ static int nftnl_set_elem_cmd_snprintf(char *buf, size_t size,
 
 	if (type == NFTNL_OUTPUT_XML)
 		return 0;
+	if (size)
+		buf[0] = '\0';
 
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
@@ -724,6 +726,9 @@ int nftnl_set_elem_snprintf(char *buf, size_t size,
 			    const struct nftnl_set_elem *e,
 			    uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_set_elem_cmd_snprintf(buf, size, e, nftnl_flag2cmd(flags),
 					 type, flags);
 }
@@ -733,6 +738,9 @@ static int nftnl_set_elem_do_snprintf(char *buf, size_t size, const void *e,
 				      uint32_t cmd, uint32_t type,
 				      uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_set_elem_snprintf(buf, size, e, type, flags);
 }
 
diff --git a/src/table.c b/src/table.c
index d426bcb..4a0a896 100644
--- a/src/table.c
+++ b/src/table.c
@@ -378,6 +378,9 @@ static int nftnl_table_cmd_snprintf(char *buf, size_t size,
 {
 	int ret, remain = size, offset = 0;
 
+	if (size)
+		buf[0] = '\0';
+
 	ret = nftnl_cmd_header_snprintf(buf + offset, remain, cmd, type, flags);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
@@ -403,6 +406,9 @@ static int nftnl_table_cmd_snprintf(char *buf, size_t size,
 int nftnl_table_snprintf(char *buf, size_t size, const struct nftnl_table *t,
 			 uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_table_cmd_snprintf(buf, size, t, nftnl_flag2cmd(flags), type,
 				      flags);
 }
@@ -411,6 +417,9 @@ EXPORT_SYMBOL(nftnl_table_snprintf);
 static int nftnl_table_do_snprintf(char *buf, size_t size, const void *t,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
 {
+	if (size)
+		buf[0] = '\0';
+
 	return nftnl_table_snprintf(buf, size, t, type, flags);
 }
 
-- 
2.13.5

