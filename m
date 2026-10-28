Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199459;
	b=5KKJrmU2AuuEvd5JTIVDzFg3Qr7c3z31pH1qnNucCZFuneOoqbeXct3EONSJO+7nU4Sd
	 krlauvFfGC7ttxuzpN0WOEtx2IQV8zneNk4XonEHVB5OcyYfsHGQU4aAkgM6jHg8SQpDk
	 Q9L7t3nQJCAr6xizW5Pys5j0VZVBK2vPshNO10j5NIPSdbI7g7Jt9BtF+NXFub1f9CN+M
	 rYPJ99zl+CkXBmm06sJFI+pxtFyoDEJqJ6vmaKMn6CWVTywgga9aeNR4F/uaoyo84vCn4
	 3f/xUcibcOv074idZNbhftJHov91ji9o8xicH6tcqawD8VDm2TAMgbFHKFln80kqlAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199459;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Gt8gZEYO/DFnGhbRA5AtRJNTkHPqqzRy0eCeLnhyd+4=;
	b=LiOz95KjgHlHl+ISdhEnPKmuY/KSdarNh6BNpYcpMcyoLYgm0MUmgllaMAV1mlWAt5uK
	 GebWdzBAHRYetomTl+jWcjYgaIeh7rFp9wX1AjK/YW/J+y09Lh5/o8bJZCdBrG2RMiJoD
	 jtN0X2f+xQ8UPWz3wMfBzye4OPSzeBi0oJRW6LAAB+xhcOdFBEjFZ5/mdiI3FPF91LdSu
	 hD5dh2gfx9j1sOe82JFzVi4V/pLFsmvTrNFm2WFMoTsCZFxpKwwiySarntDqU5+04ZqTz
	 qz7Unh57YmCizrzWEzxvHvdPmfObPgivgTEvxgNld3S2T03Qi+QjB1XHpuki4hsHvSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6678D606A32C
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6678D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E3B45609D0; Wed, 28 Oct 2026 15:57:36 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 12/12] src: remove all remaining MNL_STRING users
Date: Wed, 28 Oct 2026 15:56:32 +0100
Message-ID: <20261028145632.7089-13-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>
References: <20261028145632.7089-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch everything over to MNL_NUL_STRING and mnl_attr_put_strz.

The kernel always emits NLA_STRING attributes with the trailing
0 (strlen() + 1), so this is safe for kernel-originating data.

For non-kernel-originating data, the lack of the NUL check means
greater care needs to be taken on parser side, plain strlen, strdup,
etc is illegal, a known source of bugs.

We already used mnl_attr_put_strz() almost everywhere, this
converts the rest.

No bug report behing this, its related to other LLM findings where
we did strlen/strdup on unchecked MNL_STRING attribute, see
"src: move several MNL_STRING types to MNL_NUL_STRING".

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 examples/nft-compat-get.c | 2 +-
 src/chain.c               | 2 +-
 src/expr/dynset.c         | 2 +-
 src/expr/flow_offload.c   | 2 +-
 src/expr/log.c            | 2 +-
 src/expr/lookup.c         | 2 +-
 src/expr/objref.c         | 6 +++---
 src/flowtable.c           | 2 +-
 src/obj/ct_helper.c       | 4 ++--
 src/obj/secmark.c         | 4 ++--
 src/object.c              | 2 +-
 src/rule.c                | 2 +-
 src/set_elem.c            | 2 +-
 src/table.c               | 2 +-
 src/trace.c               | 4 ++--
 15 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/examples/nft-compat-get.c b/examples/nft-compat-get.c
index fd308db9c460..8d7a2dbc54cc 100644
--- a/examples/nft-compat-get.c
+++ b/examples/nft-compat-get.c
@@ -25,7 +25,7 @@ static int data_attr_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_COMPAT_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0) {
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
 		}
diff --git a/src/chain.c b/src/chain.c
index c72505c22e17..34fa295552a1 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -530,7 +530,7 @@ static int nftnl_chain_parse_attr_cb(const struct nlattr *attr, void *data)
 	case NFTA_CHAIN_NAME:
 	case NFTA_CHAIN_TABLE:
 	case NFTA_CHAIN_TYPE:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_CHAIN_HOOK:
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index f513b3736b43..1f99a82efd30 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -131,7 +131,7 @@ static int nftnl_expr_dynset_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_DYNSET_SET_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_DYNSET_EXPR:
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index f9a999bd4843..1b6724b64cb1 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -53,7 +53,7 @@ static int nftnl_expr_flow_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_FLOW_TABLE_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	}
diff --git a/src/expr/log.c b/src/expr/log.c
index f8456bcce4bf..3af15e9232b3 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -100,7 +100,7 @@ static int nftnl_expr_log_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_LOG_PREFIX:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_LOG_GROUP:
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index c6a36a68d0b0..7d1ff1823071 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -96,7 +96,7 @@ static int nftnl_expr_lookup_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_LOOKUP_SET:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	}
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 481103e7883c..415444e95d6c 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -98,7 +98,7 @@ static int nftnl_expr_objref_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFTA_OBJREF_IMM_NAME:
 	case NFTA_OBJREF_SET_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_OBJREF_SET_SREG:
@@ -121,12 +121,12 @@ static void nftnl_expr_objref_build(struct nlmsghdr *nlh,
 		mnl_attr_put_u32(nlh, NFTA_OBJREF_IMM_TYPE,
 				 htonl(objref->imm.type));
 	if (e->flags & (1 << NFTNL_EXPR_OBJREF_IMM_NAME))
-		mnl_attr_put_str(nlh, NFTA_OBJREF_IMM_NAME, objref->imm.name);
+		mnl_attr_put_strz(nlh, NFTA_OBJREF_IMM_NAME, objref->imm.name);
 	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_SREG))
 		mnl_attr_put_u32(nlh, NFTA_OBJREF_SET_SREG,
 				 htonl(objref->set.sreg));
 	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_NAME))
-		mnl_attr_put_str(nlh, NFTA_OBJREF_SET_NAME, objref->set.name);
+		mnl_attr_put_strz(nlh, NFTA_OBJREF_SET_NAME, objref->set.name);
 	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_ID))
 		mnl_attr_put_u32(nlh, NFTA_OBJREF_SET_ID,
 				 htonl(objref->set.id));
diff --git a/src/flowtable.c b/src/flowtable.c
index 2adb478ee94a..fa9cf5a4100b 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -326,7 +326,7 @@ static int nftnl_flowtable_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_FLOWTABLE_NAME:
 	case NFTA_FLOWTABLE_TABLE:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_FLOWTABLE_HOOK:
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index 6e16f083f2f2..f11595a394b6 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -67,7 +67,7 @@ static int nftnl_obj_ct_helper_cb(const struct nlattr *attr, void *data)
 
 	switch (type) {
 	case NFTA_CT_HELPER_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		if (mnl_attr_get_payload_len(attr) >= sizeof(helper->name))
 			abi_breakage();
@@ -92,7 +92,7 @@ nftnl_obj_ct_helper_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
 
 	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_NAME))
-		mnl_attr_put_str(nlh, NFTA_CT_HELPER_NAME, helper->name);
+		mnl_attr_put_strz(nlh, NFTA_CT_HELPER_NAME, helper->name);
 	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_L3PROTO))
 		mnl_attr_put_u16(nlh, NFTA_CT_HELPER_L3PROTO, htons(helper->l3proto));
 	if (e->flags & (1 << NFTNL_OBJ_CT_HELPER_L4PROTO))
diff --git a/src/obj/secmark.c b/src/obj/secmark.c
index 25b04e206eef..de74d59a5c64 100644
--- a/src/obj/secmark.c
+++ b/src/obj/secmark.c
@@ -54,7 +54,7 @@ static int nftnl_obj_secmark_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_SECMARK_CTX:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		if (mnl_attr_get_payload_len(attr) >= sizeof(secmark->ctx))
 			abi_breakage();
@@ -71,7 +71,7 @@ nftnl_obj_secmark_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
 	struct nftnl_obj_secmark *secmark = nftnl_obj_data(e);
 
 	if (e->flags & (1 << NFTNL_OBJ_SECMARK_CTX))
-		mnl_attr_put_str(nlh, NFTA_SECMARK_CTX, secmark->ctx);
+		mnl_attr_put_strz(nlh, NFTA_SECMARK_CTX, secmark->ctx);
 }
 
 static int
diff --git a/src/object.c b/src/object.c
index d35e050b9d83..4f2087752f67 100644
--- a/src/object.c
+++ b/src/object.c
@@ -315,7 +315,7 @@ static int nftnl_obj_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_OBJ_TABLE:
 	case NFTA_OBJ_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_OBJ_HANDLE:
diff --git a/src/rule.c b/src/rule.c
index c7bf6f3b14ad..28aa8df57795 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -324,7 +324,7 @@ static int nftnl_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_RULE_TABLE:
 	case NFTA_RULE_CHAIN:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_RULE_HANDLE:
diff --git a/src/set_elem.c b/src/set_elem.c
index 0170d0ccefd1..14ff6f580fe4 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -595,7 +595,7 @@ nftnl_set_elem_list_parse_attr_cb(const struct nlattr *attr, void *data)
 	switch(type) {
 	case NFTA_SET_ELEM_LIST_TABLE:
 	case NFTA_SET_ELEM_LIST_SET:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_SET_ELEM_LIST_ELEMENTS:
diff --git a/src/table.c b/src/table.c
index 03aee30db9ec..22786879651a 100644
--- a/src/table.c
+++ b/src/table.c
@@ -243,7 +243,7 @@ static int nftnl_table_parse_attr_cb(const struct nlattr *attr, void *data)
 
 	switch(type) {
 	case NFTA_TABLE_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_TABLE_HANDLE:
diff --git a/src/trace.c b/src/trace.c
index 61a94a307fee..fac1b366c0f4 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -118,7 +118,7 @@ static int nftnl_trace_parse_attr_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFTA_TRACE_CHAIN:
 	case NFTA_TRACE_TABLE:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_TRACE_RULE_HANDLE:
@@ -308,7 +308,7 @@ static int nftnl_trace_parse_verdict_cb(const struct nlattr *attr, void *data)
 		tb[type] = attr;
 		break;
 	case NFTA_VERDICT_CHAIN:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		tb[type] = attr;
 		break;
-- 
2.55.0

