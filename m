Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002311624D5
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2025 20:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559887; cv=none; b=nROYNgOEcQCRJ0uRG4ZLD8riE9zE/Td2pYTLobj1Ae9rdBO2TUUfEDpuzszlamc141wFhQAmJViZnfYvLFMK0PLskxQUQ7nVluBqqT11Xt4NU0quyz7nAa+QWpzbUJ/tS37zDFGAlWhFxOi0PtWMswv9oj+6k6iAtvoumFwi+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559887; c=relaxed/simple;
	bh=8DpwtWiXbIn3e5TApudJBNyc6/OTfHMekAFlV0Y5vT8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EK0H35H6eyR3EBI4bc+VxDXHCTpxSNZN6dBZFEBpqWtZX8S6Wp9sdtrCKEGFk1ZyyXS+Pn3Kk/R5/fmyCSYyQcAYoVd3fAoLVgiXT9jDEX2+y45LkwInnO5iA3YYQmBhjc/o5p6MDg2VoqCkLi01BUg+KHYVYuMn/wPFLEE5GBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Pp+/+mP8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Pp+/+mP8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Gm6dxBfAMxprdIZoF+6y/Y4mDmZdK3X33368QybQGdM=; b=Pp+/+mP8i3dHwd9UuFAnNrBG8o
	YlQxY9qN4G9hK9u7z7i1ptSZwlpjcVE/N2Buw8+qVvxVQfd1/CisQNXNl10lVkoSh/uUEADEMFQCa
	FMRrLJOgVyw+NcsdAxQJ3vahcjqeW47lfTSK/xx6R489rPUyna0tuFuWlfx6JxHBiCBDkV2KRs1xS
	jkcqhmILeRFBBVK/qYF1OGLZyYXxX7qP7GrwZfjcYFye41hef8Zx6MyrpD8TRlgqgcn9tu55kjJzO
	6GOHJFRmw8AA03cmn2DFJrePMAnCwgzf9q2G/J5W4c9tfKsc8aexqcSCXG1kV4cslIbSLRx5+RR5h
	7VqAuzVw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v9837-0000000014y-3RSq;
	Wed, 15 Oct 2025 22:24:41 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] utils: Introduce nftnl_parse_str_attr()
Date: Wed, 15 Oct 2025 22:24:36 +0200
Message-ID: <20251015202436.17486-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wrap the common parsing of string attributes into a function. Apart from
slightly reducing code size, this unifies callers in conditional freeing
of the field in case it was set before (missing in twelve spots) and
error checking for failing strdup()-calls (missing in four spots).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/utils.h         |  3 +++
 src/chain.c             | 33 +++++++++------------------------
 src/expr/dynset.c       | 12 +++++-------
 src/expr/flow_offload.c | 12 +++++-------
 src/expr/log.c          | 13 ++++---------
 src/expr/lookup.c       | 12 +++++-------
 src/expr/objref.c       | 18 ++++++++----------
 src/flowtable.c         | 24 ++++++++----------------
 src/object.c            | 14 ++++++--------
 src/rule.c              | 22 ++++++----------------
 src/set.c               | 22 ++++++----------------
 src/set_elem.c          | 38 +++++++++++++-------------------------
 src/table.c             | 11 +++--------
 src/trace.c             | 28 ++++++++++------------------
 src/utils.c             | 15 +++++++++++++++
 15 files changed, 106 insertions(+), 171 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 5a3379fb501e1..10492893e3a16 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -88,4 +88,7 @@ struct nlattr;
 void nftnl_attr_put_ifname(struct nlmsghdr *nlh, const char *ifname);
 char *nftnl_attr_get_ifname(const struct nlattr *attr);
 
+int nftnl_parse_str_attr(const struct nlattr *tb, int attr,
+			 const char **field, uint32_t *flags);
+
 #endif
diff --git a/src/chain.c b/src/chain.c
index 8396114439ff7..8433f7db41263 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -675,22 +675,12 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_chain_parse_attr_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_CHAIN_NAME]) {
-		if (c->flags & (1 << NFTNL_CHAIN_NAME))
-			xfree(c->name);
-		c->name = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_NAME]));
-		if (!c->name)
-			return -1;
-		c->flags |= (1 << NFTNL_CHAIN_NAME);
-	}
-	if (tb[NFTA_CHAIN_TABLE]) {
-		if (c->flags & (1 << NFTNL_CHAIN_TABLE))
-			xfree(c->table);
-		c->table = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TABLE]));
-		if (!c->table)
-			return -1;
-		c->flags |= (1 << NFTNL_CHAIN_TABLE);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_CHAIN_NAME], NFTNL_CHAIN_NAME,
+				 &c->name, &c->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_CHAIN_TABLE], NFTNL_CHAIN_TABLE,
+				 &c->table, &c->flags) < 0)
+		return -1;
 	if (tb[NFTA_CHAIN_HOOK]) {
 		ret = nftnl_chain_parse_hook(tb[NFTA_CHAIN_HOOK], c);
 		if (ret < 0)
@@ -713,14 +703,9 @@ int nftnl_chain_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_chain *c)
 		c->handle = be64toh(mnl_attr_get_u64(tb[NFTA_CHAIN_HANDLE]));
 		c->flags |= (1 << NFTNL_CHAIN_HANDLE);
 	}
-	if (tb[NFTA_CHAIN_TYPE]) {
-		if (c->flags & (1 << NFTNL_CHAIN_TYPE))
-			xfree(c->type);
-		c->type = strdup(mnl_attr_get_str(tb[NFTA_CHAIN_TYPE]));
-		if (!c->type)
-			return -1;
-		c->flags |= (1 << NFTNL_CHAIN_TYPE);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_CHAIN_TYPE], NFTNL_CHAIN_TYPE,
+				 &c->type, &c->flags) < 0)
+		return -1;
 	if (tb[NFTA_CHAIN_FLAGS]) {
 		c->chain_flags = ntohl(mnl_attr_get_u32(tb[NFTA_CHAIN_FLAGS]));
 		c->flags |= (1 << NFTNL_CHAIN_FLAGS);
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 40f9136ab73a2..dc74fbbe75b3c 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -245,13 +245,11 @@ nftnl_expr_dynset_parse(struct nftnl_expr *e, struct nlattr *attr)
 		dynset->timeout = be64toh(mnl_attr_get_u64(tb[NFTA_DYNSET_TIMEOUT]));
 		e->flags |= (1 << NFTNL_EXPR_DYNSET_TIMEOUT);
 	}
-	if (tb[NFTA_DYNSET_SET_NAME]) {
-		dynset->set_name =
-			strdup(mnl_attr_get_str(tb[NFTA_DYNSET_SET_NAME]));
-		if (!dynset->set_name)
-			return -1;
-		e->flags |= (1 << NFTNL_EXPR_DYNSET_SET_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_DYNSET_SET_NAME],
+				 NFTNL_EXPR_DYNSET_SET_NAME,
+				 (const char **)&dynset->set_name,
+				 &e->flags) < 0)
+		return -1;
 	if (tb[NFTA_DYNSET_SET_ID]) {
 		dynset->set_id = ntohl(mnl_attr_get_u32(tb[NFTA_DYNSET_SET_ID]));
 		e->flags |= (1 << NFTNL_EXPR_DYNSET_SET_ID);
diff --git a/src/expr/flow_offload.c b/src/expr/flow_offload.c
index 5f209a63fa960..ce22ec419a944 100644
--- a/src/expr/flow_offload.c
+++ b/src/expr/flow_offload.c
@@ -79,13 +79,11 @@ static int nftnl_expr_flow_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_flow_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_FLOW_TABLE_NAME]) {
-		flow->table_name =
-			strdup(mnl_attr_get_str(tb[NFTA_FLOW_TABLE_NAME]));
-		if (!flow->table_name)
-			return -1;
-		e->flags |= (1 << NFTNL_EXPR_FLOW_TABLE_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_FLOW_TABLE_NAME],
+				 NFTNL_EXPR_FLOW_TABLE_NAME,
+				 (const char **)&flow->table_name,
+				 &e->flags) < 0)
+		return -1;
 
 	return ret;
 }
diff --git a/src/expr/log.c b/src/expr/log.c
index d4b53e6c744de..ead243799863c 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -147,15 +147,10 @@ nftnl_expr_log_parse(struct nftnl_expr *e, struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_expr_log_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_LOG_PREFIX]) {
-		if (log->prefix)
-			xfree(log->prefix);
-
-		log->prefix = strdup(mnl_attr_get_str(tb[NFTA_LOG_PREFIX]));
-		if (!log->prefix)
-			return -1;
-		e->flags |= (1 << NFTNL_EXPR_LOG_PREFIX);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_LOG_PREFIX],
+				 NFTNL_EXPR_LOG_PREFIX,
+				 &log->prefix, &e->flags) < 0)
+		return -1;
 	if (tb[NFTA_LOG_GROUP]) {
 		log->group = ntohs(mnl_attr_get_u16(tb[NFTA_LOG_GROUP]));
 		e->flags |= (1 << NFTNL_EXPR_LOG_GROUP);
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index 7f85ecca008f5..4f76c5b71bb2b 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -141,13 +141,11 @@ nftnl_expr_lookup_parse(struct nftnl_expr *e, struct nlattr *attr)
 		lookup->dreg = ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_DREG]));
 		e->flags |= (1 << NFTNL_EXPR_LOOKUP_DREG);
 	}
-	if (tb[NFTA_LOOKUP_SET]) {
-		lookup->set_name =
-			strdup(mnl_attr_get_str(tb[NFTA_LOOKUP_SET]));
-		if (!lookup->set_name)
-			return -1;
-		e->flags |= (1 << NFTNL_EXPR_LOOKUP_SET);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_LOOKUP_SET],
+				 NFTNL_EXPR_LOOKUP_SET,
+				 (const char **)&lookup->set_name,
+				 &e->flags) < 0)
+		return -1;
 	if (tb[NFTA_LOOKUP_SET_ID]) {
 		lookup->set_id =
 			ntohl(mnl_attr_get_u32(tb[NFTA_LOOKUP_SET_ID]));
diff --git a/src/expr/objref.c b/src/expr/objref.c
index 5fe09c242ef48..1b27e94a6fa2c 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -144,21 +144,19 @@ static int nftnl_expr_objref_parse(struct nftnl_expr *e, struct nlattr *attr)
 			ntohl(mnl_attr_get_u32(tb[NFTA_OBJREF_IMM_TYPE]));
 		e->flags |= (1 << NFTNL_EXPR_OBJREF_IMM_TYPE);
 	}
-	if (tb[NFTA_OBJREF_IMM_NAME]) {
-		objref->imm.name =
-			strdup(mnl_attr_get_str(tb[NFTA_OBJREF_IMM_NAME]));
-		e->flags |= (1 << NFTNL_EXPR_OBJREF_IMM_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_OBJREF_IMM_NAME],
+				 NFTNL_EXPR_OBJREF_IMM_NAME,
+				 &objref->imm.name, &e->flags) < 0)
+		return -1;
 	if (tb[NFTA_OBJREF_SET_SREG]) {
 		objref->set.sreg =
 			ntohl(mnl_attr_get_u32(tb[NFTA_OBJREF_SET_SREG]));
 		e->flags |= (1 << NFTNL_EXPR_OBJREF_SET_SREG);
 	}
-	if (tb[NFTA_OBJREF_SET_NAME]) {
-		objref->set.name =
-			strdup(mnl_attr_get_str(tb[NFTA_OBJREF_SET_NAME]));
-		e->flags |= (1 << NFTNL_EXPR_OBJREF_SET_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_OBJREF_SET_NAME],
+				 NFTNL_EXPR_OBJREF_SET_NAME,
+				 &objref->set.name, &e->flags) < 0)
+		return -1;
 	if (tb[NFTA_OBJREF_SET_ID]) {
 		objref->set.id =
 			ntohl(mnl_attr_get_u32(tb[NFTA_OBJREF_SET_ID]));
diff --git a/src/flowtable.c b/src/flowtable.c
index 59991d694f602..27af51c688745 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -408,22 +408,14 @@ int nftnl_flowtable_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_flowtab
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_flowtable_parse_attr_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_FLOWTABLE_NAME]) {
-		if (c->flags & (1 << NFTNL_FLOWTABLE_NAME))
-			xfree(c->name);
-		c->name = strdup(mnl_attr_get_str(tb[NFTA_FLOWTABLE_NAME]));
-		if (!c->name)
-			return -1;
-		c->flags |= (1 << NFTNL_FLOWTABLE_NAME);
-	}
-	if (tb[NFTA_FLOWTABLE_TABLE]) {
-		if (c->flags & (1 << NFTNL_FLOWTABLE_TABLE))
-			xfree(c->table);
-		c->table = strdup(mnl_attr_get_str(tb[NFTA_FLOWTABLE_TABLE]));
-		if (!c->table)
-			return -1;
-		c->flags |= (1 << NFTNL_FLOWTABLE_TABLE);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_FLOWTABLE_NAME],
+				 NFTNL_FLOWTABLE_NAME,
+				 &c->name, &c->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_FLOWTABLE_TABLE],
+				 NFTNL_FLOWTABLE_TABLE,
+				 &c->table, &c->flags) < 0)
+		return -1;
 	if (tb[NFTA_FLOWTABLE_HOOK]) {
 		ret = nftnl_flowtable_parse_hook(tb[NFTA_FLOWTABLE_HOOK], c);
 		if (ret < 0)
diff --git a/src/object.c b/src/object.c
index 275a202e63081..3d358ccf051cb 100644
--- a/src/object.c
+++ b/src/object.c
@@ -344,14 +344,12 @@ int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_obj_parse_attr_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_OBJ_TABLE]) {
-		obj->table = strdup(mnl_attr_get_str(tb[NFTA_OBJ_TABLE]));
-		obj->flags |= (1 << NFTNL_OBJ_TABLE);
-	}
-	if (tb[NFTA_OBJ_NAME]) {
-		obj->name = strdup(mnl_attr_get_str(tb[NFTA_OBJ_NAME]));
-		obj->flags |= (1 << NFTNL_OBJ_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_OBJ_TABLE], NFTNL_OBJ_TABLE,
+				 &obj->table, &obj->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_OBJ_NAME], NFTNL_OBJ_NAME,
+				 &obj->name, &obj->flags) < 0)
+		return -1;
 	if (tb[NFTA_OBJ_TYPE]) {
 		uint32_t type = ntohl(mnl_attr_get_u32(tb[NFTA_OBJ_TYPE]));
 
diff --git a/src/rule.c b/src/rule.c
index 3948a74098fe7..cd3041e5a399a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -431,22 +431,12 @@ int nftnl_rule_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_rule *r)
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_rule_parse_attr_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_RULE_TABLE]) {
-		if (r->flags & (1 << NFTNL_RULE_TABLE))
-			xfree(r->table);
-		r->table = strdup(mnl_attr_get_str(tb[NFTA_RULE_TABLE]));
-		if (!r->table)
-			return -1;
-		r->flags |= (1 << NFTNL_RULE_TABLE);
-	}
-	if (tb[NFTA_RULE_CHAIN]) {
-		if (r->flags & (1 << NFTNL_RULE_CHAIN))
-			xfree(r->chain);
-		r->chain = strdup(mnl_attr_get_str(tb[NFTA_RULE_CHAIN]));
-		if (!r->chain)
-			return -1;
-		r->flags |= (1 << NFTNL_RULE_CHAIN);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_RULE_TABLE], NFTNL_RULE_TABLE,
+				 &r->table, &r->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_RULE_CHAIN], NFTNL_RULE_CHAIN,
+				 &r->chain, &r->flags) < 0)
+		return -1;
 	if (tb[NFTA_RULE_HANDLE]) {
 		r->handle = be64toh(mnl_attr_get_u64(tb[NFTA_RULE_HANDLE]));
 		r->flags |= (1 << NFTNL_RULE_HANDLE);
diff --git a/src/set.c b/src/set.c
index 412bdac627d31..54674bca709fd 100644
--- a/src/set.c
+++ b/src/set.c
@@ -657,22 +657,12 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_set_parse_attr_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_SET_TABLE]) {
-		if (s->flags & (1 << NFTNL_SET_TABLE))
-			xfree(s->table);
-		s->table = strdup(mnl_attr_get_str(tb[NFTA_SET_TABLE]));
-		if (!s->table)
-			return -1;
-		s->flags |= (1 << NFTNL_SET_TABLE);
-	}
-	if (tb[NFTA_SET_NAME]) {
-		if (s->flags & (1 << NFTNL_SET_NAME))
-			xfree(s->name);
-		s->name = strdup(mnl_attr_get_str(tb[NFTA_SET_NAME]));
-		if (!s->name)
-			return -1;
-		s->flags |= (1 << NFTNL_SET_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_SET_TABLE], NFTNL_SET_TABLE,
+				 &s->table, &s->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_SET_NAME], NFTNL_SET_NAME,
+				 &s->name, &s->flags) < 0)
+		return -1;
 	if (tb[NFTA_SET_HANDLE]) {
 		s->handle = be64toh(mnl_attr_get_u64(tb[NFTA_SET_HANDLE]));
 		s->flags |= (1 << NFTNL_SET_HANDLE);
diff --git a/src/set_elem.c b/src/set_elem.c
index 848adf1d179bf..05220e7933242 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -576,13 +576,11 @@ static int nftnl_set_elems_parse2(struct nftnl_set *s, const struct nlattr *nest
 		memcpy(e->user.data, udata, e->user.len);
 		e->flags |= (1 << NFTNL_RULE_USERDATA);
 	}
-	if (tb[NFTA_SET_ELEM_OBJREF]) {
-		e->objref = strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_OBJREF]));
-		if (e->objref == NULL) {
-			ret = -1;
-			goto out_set_elem;
-		}
-		e->flags |= (1 << NFTNL_SET_ELEM_OBJREF);
+	if (nftnl_parse_str_attr(tb[NFTA_SET_ELEM_OBJREF],
+				 NFTNL_SET_ELEM_OBJREF,
+				 &e->objref, &e->flags) < 0) {
+		ret = -1;
+		goto out_set_elem;
 	}
 
 	/* Add this new element to this set */
@@ -646,24 +644,14 @@ int nftnl_set_elems_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 			   nftnl_set_elem_list_parse_attr_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_SET_ELEM_LIST_TABLE]) {
-		if (s->flags & (1 << NFTNL_SET_TABLE))
-			xfree(s->table);
-		s->table =
-			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_TABLE]));
-		if (!s->table)
-			return -1;
-		s->flags |= (1 << NFTNL_SET_TABLE);
-	}
-	if (tb[NFTA_SET_ELEM_LIST_SET]) {
-		if (s->flags & (1 << NFTNL_SET_NAME))
-			xfree(s->name);
-		s->name =
-			strdup(mnl_attr_get_str(tb[NFTA_SET_ELEM_LIST_SET]));
-		if (!s->name)
-			return -1;
-		s->flags |= (1 << NFTNL_SET_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_SET_ELEM_LIST_TABLE],
+				 NFTNL_SET_TABLE,
+				 &s->table, &s->flags) < 0)
+		return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_SET_ELEM_LIST_SET],
+				 NFTNL_SET_NAME,
+				 &s->name, &s->flags) < 0)
+		return -1;
 	if (tb[NFTA_SET_ELEM_LIST_SET_ID]) {
 		s->id = ntohl(mnl_attr_get_u32(tb[NFTA_SET_ELEM_LIST_SET_ID]));
 		s->flags |= (1 << NFTNL_SET_ID);
diff --git a/src/table.c b/src/table.c
index 9870dcafb4ef6..61382838ae1c5 100644
--- a/src/table.c
+++ b/src/table.c
@@ -285,14 +285,9 @@ int nftnl_table_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_table *t)
 	if (mnl_attr_parse(nlh, sizeof(*nfg), nftnl_table_parse_attr_cb, tb) < 0)
 		return -1;
 
-	if (tb[NFTA_TABLE_NAME]) {
-		if (t->flags & (1 << NFTNL_TABLE_NAME))
-			xfree(t->name);
-		t->name = strdup(mnl_attr_get_str(tb[NFTA_TABLE_NAME]));
-		if (!t->name)
-			return -1;
-		t->flags |= (1 << NFTNL_TABLE_NAME);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_TABLE_NAME], NFTNL_TABLE_NAME,
+				 &t->name, &t->flags) < 0)
+		return -1;
 	if (tb[NFTA_TABLE_FLAGS]) {
 		t->table_flags = ntohl(mnl_attr_get_u32(tb[NFTA_TABLE_FLAGS]));
 		t->flags |= (1 << NFTNL_TABLE_FLAGS);
diff --git a/src/trace.c b/src/trace.c
index d67e114082665..5dc4cfabc4a82 100644
--- a/src/trace.c
+++ b/src/trace.c
@@ -336,11 +336,11 @@ static int nftnl_trace_parse_verdict(const struct nlattr *attr,
 	case NFT_JUMP:
 		if (!tb[NFTA_VERDICT_CHAIN])
 			abi_breakage();
-		t->jump_target = strdup(mnl_attr_get_str(tb[NFTA_VERDICT_CHAIN]));
-		if (!t->jump_target)
+		if (nftnl_parse_str_attr(tb[NFTA_VERDICT_CHAIN],
+					 NFTNL_TRACE_JUMP_TARGET,
+					 (const char **)&t->jump_target,
+					 &t->flags) < 0)
 			return -1;
-
-		t->flags |= (1 << NFTNL_TRACE_JUMP_TARGET);
 		break;
 	}
 	return 0;
@@ -370,21 +370,13 @@ int nftnl_trace_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_trace *t)
 	t->id = ntohl(mnl_attr_get_u32(tb[NFTA_TRACE_ID]));
 	t->flags |= (1 << NFTNL_TRACE_ID);
 
-	if (tb[NFTA_TRACE_TABLE]) {
-		t->table = strdup(mnl_attr_get_str(tb[NFTA_TRACE_TABLE]));
-		if (!t->table)
-			return -1;
-
-		t->flags |= (1 << NFTNL_TRACE_TABLE);
-	}
-
-	if (tb[NFTA_TRACE_CHAIN]) {
-		t->chain = strdup(mnl_attr_get_str(tb[NFTA_TRACE_CHAIN]));
-		if (!t->chain)
-			return -1;
+	if (nftnl_parse_str_attr(tb[NFTA_TRACE_TABLE], NFTNL_TRACE_TABLE,
+				 (const char **)&t->table, &t->flags) < 0)
+		return -1;
 
-		t->flags |= (1 << NFTNL_TRACE_CHAIN);
-	}
+	if (nftnl_parse_str_attr(tb[NFTA_TRACE_CHAIN], NFTNL_TRACE_CHAIN,
+				 (const char **)&t->chain, &t->flags) < 0)
+		return -1;
 
 	if (tb[NFTA_TRACE_IIFTYPE]) {
 		t->iiftype = ntohs(mnl_attr_get_u16(tb[NFTA_TRACE_IIFTYPE]));
diff --git a/src/utils.c b/src/utils.c
index d73c5f6175802..bbe44b4d532dc 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -192,3 +192,18 @@ char *nftnl_attr_get_ifname(const struct nlattr *attr)
 		return NULL;
 	}
 }
+
+int nftnl_parse_str_attr(const struct nlattr *tb, int attr,
+			 const char **field, uint32_t *flags)
+{
+	if (!tb)
+		return 0;
+
+	if (*flags & (1 << attr))
+		xfree(*field);
+	*field = strdup(mnl_attr_get_str(tb));
+	if (!*field)
+		return -1;
+	*flags |= (1 << attr);
+	return 0;
+}
-- 
2.51.0

