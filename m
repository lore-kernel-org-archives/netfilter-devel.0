From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 5/7] set_elem: add NFTNL_SET_ELEM_OBJREF attribute
Date: Fri,  9 Dec 2016 14:31:57 +0100
Message-ID: <1481290319-10156-5-git-send-email-pablo@netfilter.org>
References: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35558 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753299AbcLINcM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 08:32:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B2D096EC9
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AFA9DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B461524C5
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Dec 2016 14:32:05 +0100 (CET)
In-Reply-To: <1481290319-10156-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new attribute allows us to attach stateful objects to elements for
map lookups. This new attribute identifies the object through its name.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/set.h |  1 +
 include/set_elem.h     |  1 +
 src/set_elem.c         | 27 +++++++++++++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 0c978d916e4e..4c59ab27946f 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -96,6 +96,7 @@ enum {
 	NFTNL_SET_ELEM_EXPIRATION,
 	NFTNL_SET_ELEM_USERDATA,
 	NFTNL_SET_ELEM_EXPR,
+	NFTNL_SET_ELEM_OBJREF,
 };
 
 struct nftnl_set_elem;
diff --git a/include/set_elem.h b/include/set_elem.h
index 60cecc939016..d6244e60873a 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -12,6 +12,7 @@ struct nftnl_set_elem {
 	uint32_t		flags;
 	uint64_t		timeout;
 	uint64_t		expiration;
+	const char		*objref;
 	struct {
 		void		*data;
 		uint32_t	len;
diff --git a/src/set_elem.c b/src/set_elem.c
index 083c597e2f8e..fa8747641ee0 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -50,6 +50,9 @@ void nftnl_set_elem_free(struct nftnl_set_elem *s)
 	if (s->flags & (1 << NFTNL_SET_ELEM_USERDATA))
 		xfree(s->user.data);
 
+	if (s->flags & (1 << NFTNL_SET_ELEM_OBJREF))
+		xfree(s->objref);
+
 	xfree(s);
 }
 EXPORT_SYMBOL_ALIAS(nftnl_set_elem_free, nft_set_elem_free);
@@ -82,6 +85,9 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 	case NFTNL_SET_ELEM_EXPR:
 		nftnl_expr_free(s->expr);
 		break;
+	case NFTNL_SET_ELEM_OBJREF:
+		xfree(s->objref);
+		break;
 	default:
 		return;
 	}
@@ -129,6 +135,14 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		memcpy(s->user.data, data, data_len);
 		s->user.len = data_len;
 		break;
+	case NFTNL_SET_ELEM_OBJREF:
+		if (s->flags & (1 << NFTNL_SET_ELEM_OBJREF))
+			xfree(s->objref);
+
+		s->objref = strdup(data);
+		if (!s->objref)
+			return -1;
+		break;
 	}
 	s->flags |= (1 << attr);
 	return -1;
@@ -185,6 +199,9 @@ const void *nftnl_set_elem_get(struct nftnl_set_elem *s, uint16_t attr, uint32_t
 		return s->user.data;
 	case NFTNL_SET_ELEM_EXPR:
 		return s->expr;
+	case NFTNL_SET_ELEM_OBJREF:
+		*data_len = strlen(s->objref) + 1;
+		return s->objref;
 	}
 	return NULL;
 }
@@ -271,6 +288,8 @@ void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 	}
 	if (e->flags & (1 << NFTNL_SET_ELEM_USERDATA))
 		mnl_attr_put(nlh, NFTA_SET_ELEM_USERDATA, e->user.len, e->user.data);
+	if (e->flags & (1 << NFTNL_SET_ELEM_OBJREF))
+		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_OBJREF, e->objref);
 }
 
 static void nftnl_set_elem_nlmsg_build_def(struct nlmsghdr *nlh,
@@ -423,6 +442,14 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 		memcpy(e->user.data, udata, e->user.len);
 		e->flags |= (1 << NFTNL_RULE_USERDATA);
 	}
+	if (tb[NFTA_SET_ELEM_OBJREF]) {
+		e->objref = strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_OBJREF]));
+		if (e->objref == NULL) {
+			ret = -1;
+			goto out_set_elem;
+		}
+		e->flags |= (1 << NFTNL_SET_ELEM_OBJREF);
+	}
 
 	/* Add this new element to this set */
 	list_add_tail(&e->head, &s->element_list);
-- 
2.1.4

