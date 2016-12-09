From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 6/7] expr: objref: add support for stateful object maps
Date: Fri,  9 Dec 2016 14:31:58 +0100
Message-ID: <1481290319-10156-6-git-send-email-pablo@netfilter.org>
References: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753934AbcLINcO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 08:32:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A48396ECE
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A49C524C0
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F959524C0
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:06 +0100 (CET)
In-Reply-To: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the NFT_SET_OBJECT flag is set, then this set stores a mapping
between any random user-defined arbitrary key and one stateful object.
Very useful for performance lookups.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h |  3 +++
 src/expr/objref.c       | 72 +++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index f6ea69dfacae..ee0784928550 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -237,6 +237,9 @@ enum {
 enum {
 	NFTNL_EXPR_OBJREF_IMM_TYPE	= NFTNL_EXPR_BASE,
 	NFTNL_EXPR_OBJREF_IMM_NAME,
+	NFTNL_EXPR_OBJREF_SET_SREG,
+	NFTNL_EXPR_OBJREF_SET_NAME,
+	NFTNL_EXPR_OBJREF_SET_ID,
 };
 
 /*
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 01bea7b8b4b1..4cfa3cbfbd2b 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -25,6 +25,11 @@ struct nftnl_expr_objref {
 		uint32_t	type;
 		const char	*name;
 	} imm;
+	struct {
+		uint32_t	sreg;
+		const char	*name;
+		uint32_t	id;
+	} set;
 };
 
 static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
@@ -41,6 +46,17 @@ static int nftnl_expr_objref_set(struct nftnl_expr *e, uint16_t type,
 		if (!objref->imm.name)
 			return -1;
 		break;
+	case NFTNL_EXPR_OBJREF_SET_SREG:
+		objref->set.sreg = *((uint32_t *)data);
+		break;
+	case NFTNL_EXPR_OBJREF_SET_NAME:
+		objref->set.name = strdup(data);
+		if (!objref->set.name)
+			return -1;
+		break;
+	case NFTNL_EXPR_OBJREF_SET_ID:
+		objref->set.id = *((uint32_t *)data);
+		break;
 	default:
 		return -1;
 	}
@@ -59,6 +75,15 @@ static const void *nftnl_expr_objref_get(const struct nftnl_expr *e,
 	case NFTNL_EXPR_OBJREF_IMM_NAME:
 		*data_len = strlen(objref->imm.name) + 1;
 		return objref->imm.name;
+	case NFTNL_EXPR_OBJREF_SET_SREG:
+		*data_len = sizeof(objref->set.sreg);
+		return &objref->set.sreg;
+	case NFTNL_EXPR_OBJREF_SET_NAME:
+		*data_len = strlen(objref->set.name) + 1;
+		return objref->set.name;
+	case NFTNL_EXPR_OBJREF_SET_ID:
+		*data_len = sizeof(objref->set.id);
+		return &objref->set.id;
 	}
 	return NULL;
 }
@@ -77,9 +102,15 @@ static int nftnl_expr_objref_cb(const struct nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_OBJREF_IMM_NAME:
+	case NFTA_OBJREF_SET_NAME:
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	case NFTA_OBJREF_SET_SREG:
+	case NFTA_OBJREF_SET_ID:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -96,6 +127,14 @@ static void nftnl_expr_objref_build(struct nlmsghdr *nlh,
 				 htonl(objref->imm.type));
 	if (e->flags & (1 << NFTNL_EXPR_OBJREF_IMM_NAME))
 		mnl_attr_put_str(nlh, NFTA_OBJREF_IMM_NAME, objref->imm.name);
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_SREG))
+		mnl_attr_put_u32(nlh, NFTA_OBJREF_SET_SREG,
+				 htonl(objref->set.sreg));
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_NAME))
+		mnl_attr_put_str(nlh, NFTA_OBJREF_SET_NAME, objref->set.name);
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_ID))
+		mnl_attr_put_u32(nlh, NFTA_OBJREF_SET_ID,
+				 htonl(objref->set.id));
 }
 
 static int nftnl_expr_objref_parse(struct nftnl_expr *e, struct nlattr *attr)
@@ -116,6 +155,21 @@ static int nftnl_expr_objref_parse(struct nftnl_expr *e, struct nlattr *attr)
 			strdup(mnl_attr_get_str(tb[NFTA_OBJREF_IMM_NAME]));
 		e->flags |= (1 << NFTNL_EXPR_OBJREF_IMM_NAME);
 	}
+	if (tb[NFTA_OBJREF_SET_SREG]) {
+		objref->set.sreg =
+			ntohl(mnl_attr_get_u32(tb[NFTA_OBJREF_SET_SREG]));
+		e->flags |= (1 << NFTNL_EXPR_OBJREF_SET_SREG);
+	}
+	if (tb[NFTA_OBJREF_SET_NAME]) {
+		objref->set.name =
+			strdup(mnl_attr_get_str(tb[NFTA_OBJREF_SET_NAME]));
+		e->flags |= (1 << NFTNL_EXPR_OBJREF_SET_NAME);
+	}
+	if (tb[NFTA_OBJREF_SET_ID]) {
+		objref->set.id =
+			ntohl(mnl_attr_get_u32(tb[NFTA_OBJREF_SET_ID]));
+		e->flags |= (1 << NFTNL_EXPR_OBJREF_SET_ID);
+	}
 
 	return 0;
 }
@@ -157,6 +211,10 @@ static int nftnl_expr_objref_export(char *buf, size_t size,
 		nftnl_buf_u32(&b, type, objref->imm.type, BYTES);
 	if (e->flags & (1 << NFTNL_EXPR_OBJREF_IMM_NAME))
 		nftnl_buf_str(&b, type, objref->imm.name, NAME);
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_SREG))
+		nftnl_buf_u32(&b, type, objref->set.sreg, SREG);
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_NAME))
+		nftnl_buf_str(&b, type, objref->set.name, SET);
 
 	return nftnl_buf_done(&b);
 }
@@ -166,8 +224,12 @@ static int nftnl_expr_objref_snprintf_default(char *buf, size_t len,
 {
 	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
 
-	return snprintf(buf, len, "type %u name %s ",
-			objref->imm.type, objref->imm.name);
+	if (e->flags & (1 << NFTNL_EXPR_OBJREF_SET_SREG))
+		return snprintf(buf, len, "sreg %u set %s id %u ",
+				objref->set.sreg, objref->set.name, objref->set.id);
+	else
+		return snprintf(buf, len, "type %u name %s ",
+				objref->imm.type, objref->imm.name);
 }
 
 static int nftnl_expr_objref_snprintf(char *buf, size_t len, uint32_t type,
@@ -197,6 +259,12 @@ static bool nftnl_expr_objref_cmp(const struct nftnl_expr *e1,
 		eq &= (c1->imm.type == c2->imm.type);
 	if (e1->flags & (1 << NFTNL_EXPR_OBJREF_IMM_NAME))
 		eq &= !strcmp(c1->imm.name, c2->imm.name);
+	if (e1->flags & (1 << NFTNL_EXPR_OBJREF_SET_SREG))
+		eq &= (c1->set.sreg == c2->set.sreg);
+	if (e1->flags & (1 << NFTNL_EXPR_OBJREF_SET_NAME))
+		eq &= !strcmp(c1->set.name, c2->set.name);
+	if (e1->flags & (1 << NFTNL_EXPR_OBJREF_SET_ID))
+		eq &= (c1->set.id == c2->set.id);
 
 	return eq;
 }
-- 
2.1.4

