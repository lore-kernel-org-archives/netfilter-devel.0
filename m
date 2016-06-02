From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 2/2,libnftnl] Check memory allocations in setters
Date: Thu,  2 Jun 2016 12:40:24 +0200
Message-ID: <1464864024-12108-2-git-send-email-carlosfg@riseup.net>
References: <1464864024-12108-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:58668 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbcFBKki (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 06:40:38 -0400
In-Reply-To: <1464864024-12108-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When you set an object attribute the memory is copied, sometimes an
allocations is needed and it must be checked. By now all setters method=
s
returns void, so the policy adopted in case of error is keep the object
unchanged.

What this patch makes:
	* All memory allocations inside setters are checked
	* The object remains unchanged in case of error
	* Unsetters are used if is possible in order to consolidate

Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
---
 src/chain.c          | 26 +++++++++++++++++---------
 src/expr/dynset.c    |  8 +++++++-
 src/expr/immediate.c |  9 ++++++---
 src/expr/log.c       | 12 +++++++++---
 src/expr/lookup.c    |  8 +++++++-
 src/rule.c           | 28 +++++++++++++++++-----------
 src/set.c            | 18 ++++++++++++------
 src/set_elem.c       | 21 +++++++++++++--------
 8 files changed, 88 insertions(+), 42 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 990c576..c4c4ff7 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -168,6 +168,8 @@ static uint32_t nftnl_chain_validate[NFTNL_CHAIN_MA=
X + 1] =3D {
 void nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 			     const void *data, uint32_t data_len)
 {
+	char *newstr;
+
 	if (attr > NFTNL_CHAIN_MAX)
 		return;
=20
@@ -178,10 +180,12 @@ void nftnl_chain_set_data(struct nftnl_chain *c, =
uint16_t attr,
 		strncpy(c->name, data, NFT_CHAIN_MAXNAMELEN);
 		break;
 	case NFTNL_CHAIN_TABLE:
-		if (c->table)
-			xfree(c->table);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		c->table =3D strdup(data);
+		nftnl_chain_unset(c, attr);
+		c->table =3D newstr;
 		break;
 	case NFTNL_CHAIN_HOOKNUM:
 		memcpy(&c->hooknum, data, sizeof(c->hooknum));
@@ -208,16 +212,20 @@ void nftnl_chain_set_data(struct nftnl_chain *c, =
uint16_t attr,
 		c->family =3D *((uint32_t *)data);
 		break;
 	case NFTNL_CHAIN_TYPE:
-		if (c->type)
-			xfree(c->type);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		c->type =3D strdup(data);
+		nftnl_chain_unset(c, attr);
+		c->type =3D newstr;
 		break;
 	case NFTNL_CHAIN_DEV:
-		if (c->dev)
-			xfree(c->dev);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		c->dev =3D strdup(data);
+		nftnl_chain_unset(c, attr);
+		c->dev =3D newstr;
 		break;
 	}
 	c->flags |=3D (1 << attr);
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index c8d97a5..e54d9e9 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -37,6 +37,7 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t =
type,
 			 const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_dynset *dynset =3D nftnl_expr_data(e);
+	char *newstr;
=20
 	switch (type) {
 	case NFTNL_EXPR_DYNSET_SREG_KEY:
@@ -52,7 +53,12 @@ nftnl_expr_dynset_set(struct nftnl_expr *e, uint16_t=
 type,
 		dynset->timeout =3D *((uint64_t *)data);
 		break;
 	case NFTNL_EXPR_DYNSET_SET_NAME:
-		dynset->set_name =3D strdup((const char *)data);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return -1;
+
+		xfree(dynset->set_name);
+		dynset->set_name =3D newstr;
 		break;
 	case NFTNL_EXPR_DYNSET_SET_ID:
 		dynset->set_id =3D *((uint32_t *)data);
diff --git a/src/expr/immediate.c b/src/expr/immediate.c
index eb2ca0f..60e7ae4 100644
--- a/src/expr/immediate.c
+++ b/src/expr/immediate.c
@@ -30,6 +30,7 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint16=
_t type,
 			    const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_immediate *imm =3D nftnl_expr_data(e);
+	char *newstr;
=20
 	switch(type) {
 	case NFTNL_EXPR_IMM_DREG:
@@ -43,10 +44,12 @@ nftnl_expr_immediate_set(struct nftnl_expr *e, uint=
16_t type,
 		imm->data.verdict =3D *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_IMM_CHAIN:
-		if (imm->data.chain)
-			xfree(imm->data.chain);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return -1;
=20
-		imm->data.chain =3D strdup(data);
+		xfree(imm->data.chain);
+		imm->data.chain =3D newstr;
 		break;
 	default:
 		return -1;
diff --git a/src/expr/log.c b/src/expr/log.c
index c3dc0a6..369174f 100644
--- a/src/expr/log.c
+++ b/src/expr/log.c
@@ -34,13 +34,17 @@ static int nftnl_expr_log_set(struct nftnl_expr *e,=
 uint16_t type,
 				 const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_log *log =3D nftnl_expr_data(e);
+	char *newstr;
=20
 	switch(type) {
 	case NFTNL_EXPR_LOG_PREFIX:
-		if (log->prefix)
-			xfree(log->prefix);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return -1;
=20
-		log->prefix =3D strdup(data);
+		if (log->flags & (1 << NFTNL_EXPR_LOG_PREFIX))
+			xfree(log->prefix);
+		log->prefix =3D newstr;
 		break;
 	case NFTNL_EXPR_LOG_GROUP:
 		log->group =3D *((uint16_t *)data);
@@ -60,6 +64,8 @@ static int nftnl_expr_log_set(struct nftnl_expr *e, u=
int16_t type,
 	default:
 		return -1;
 	}
+
+	log->flags |=3D (1 << type);
 	return 0;
 }
=20
diff --git a/src/expr/lookup.c b/src/expr/lookup.c
index ed32ba6..99d1d1b 100644
--- a/src/expr/lookup.c
+++ b/src/expr/lookup.c
@@ -33,6 +33,7 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t =
type,
 			  const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_lookup *lookup =3D nftnl_expr_data(e);
+	char *newstr;
=20
 	switch(type) {
 	case NFTNL_EXPR_LOOKUP_SREG:
@@ -42,7 +43,12 @@ nftnl_expr_lookup_set(struct nftnl_expr *e, uint16_t=
 type,
 		lookup->dreg =3D *((uint32_t *)data);
 		break;
 	case NFTNL_EXPR_LOOKUP_SET:
-		lookup->set_name =3D strdup((const char *)data);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return -1;
+
+		xfree(lookup->set_name);
+		lookup->set_name =3D newstr;
 		break;
 	case NFTNL_EXPR_LOOKUP_SET_ID:
 		lookup->set_id =3D *((uint32_t *)data);
diff --git a/src/rule.c b/src/rule.c
index 3576e32..223a92d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -132,6 +132,9 @@ static uint32_t nftnl_rule_validate[NFTNL_RULE_MAX =
+ 1] =3D {
 void nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 			    const void *data, uint32_t data_len)
 {
+	char *newstr;
+	void *newud;
+
 	if (attr > NFTNL_RULE_MAX)
 		return;
=20
@@ -139,16 +142,20 @@ void nftnl_rule_set_data(struct nftnl_rule *r, ui=
nt16_t attr,
=20
 	switch(attr) {
 	case NFTNL_RULE_TABLE:
-		if (r->table)
-			xfree(r->table);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		r->table =3D strdup(data);
+		nftnl_rule_unset(r, attr);
+		r->table =3D newstr;
 		break;
 	case NFTNL_RULE_CHAIN:
-		if (r->chain)
-			xfree(r->chain);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		r->chain =3D strdup(data);
+		nftnl_rule_unset(r, attr);
+		r->chain =3D newstr;
 		break;
 	case NFTNL_RULE_HANDLE:
 		r->handle =3D *((uint64_t *)data);
@@ -166,13 +173,12 @@ void nftnl_rule_set_data(struct nftnl_rule *r, ui=
nt16_t attr,
 		r->position =3D *((uint64_t *)data);
 		break;
 	case NFTNL_RULE_USERDATA:
-		if (r->user.data !=3D NULL)
-			xfree(r->user.data);
-
-		r->user.data =3D malloc(data_len);
-		if (!r->user.data)
+		newud =3D malloc(data_len);
+		if (!newud)
 			return;
=20
+		nftnl_rule_unset(r, attr);
+		r->user.data =3D newud;
 		memcpy(r->user.data, data, data_len);
 		r->user.len =3D data_len;
 		break;
diff --git a/src/set.c b/src/set.c
index dbea93b..258f771 100644
--- a/src/set.c
+++ b/src/set.c
@@ -116,6 +116,8 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + =
1] =3D {
 void nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void=
 *data,
 			   uint32_t data_len)
 {
+	char *newstr;
+
 	if (attr > NFTNL_SET_MAX)
 		return;
=20
@@ -123,16 +125,20 @@ void nftnl_set_set_data(struct nftnl_set *s, uint=
16_t attr, const void *data,
=20
 	switch(attr) {
 	case NFTNL_SET_TABLE:
-		if (s->table)
-			xfree(s->table);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		s->table =3D strdup(data);
+		nftnl_set_unset(s, attr);
+		s->table =3D newstr;
 		break;
 	case NFTNL_SET_NAME:
-		if (s->name)
-			xfree(s->name);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		s->name =3D strdup(data);
+		nftnl_set_unset(s, attr);
+		s->name =3D newstr;
 		break;
 	case NFTNL_SET_FLAGS:
 		s->set_flags =3D *((uint32_t *)data);
diff --git a/src/set_elem.c b/src/set_elem.c
index 47ad6f4..1b8d7e6 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -102,6 +102,9 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_elem_unset, nft_set_e=
lem_attr_unset);
 void nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 			   const void *data, uint32_t data_len)
 {
+	char *newstr;
+	void *newud;
+
 	switch(attr) {
 	case NFTNL_SET_ELEM_FLAGS:
 		s->set_elem_flags =3D *((uint32_t *)data);
@@ -114,10 +117,12 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s,=
 uint16_t attr,
 		s->data.verdict =3D *((uint32_t *)data);
 		break;
 	case NFTNL_SET_ELEM_CHAIN:	/* NFTA_SET_ELEM_DATA */
-		if (s->data.chain)
-			xfree(s->data.chain);
+		newstr =3D strdup(data);
+		if (!newstr)
+			return;
=20
-		s->data.chain =3D strdup(data);
+		nftnl_set_elem_unset(s, attr);
+		s->data.chain =3D newstr;
 		break;
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
 		memcpy(s->data.val, data, data_len);
@@ -127,12 +132,12 @@ void nftnl_set_elem_set(struct nftnl_set_elem *s,=
 uint16_t attr,
 		s->timeout =3D *((uint64_t *)data);
 		break;
 	case NFTNL_SET_ELEM_USERDATA: /* NFTA_SET_ELEM_USERDATA */
-		if (s->user.data !=3D NULL)
-			xfree(s->user.data);
-
-		s->user.data =3D malloc(data_len);
-		if (!s->user.data)
+		newud =3D malloc(data_len);
+		if (!newud)
 			return;
+
+		nftnl_set_elem_unset(s, attr);
+		s->user.data =3D newud;
 		memcpy(s->user.data, data, data_len);
 		s->user.len =3D data_len;
 		break;
--=20
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
