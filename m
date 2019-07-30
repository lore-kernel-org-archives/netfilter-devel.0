Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECCC6C0650F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEF7120659
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 14:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730734AbfG3OQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 10:16:32 -0400
Received: from correo.us.es ([193.147.175.20]:53110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730672AbfG3OQc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 10:16:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EC42811ED80
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:16:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC7FB1150CC
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 16:16:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D225F91F4; Tue, 30 Jul 2019 16:16:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 704981150CC;
        Tue, 30 Jul 2019 16:16:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 16:16:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.32.83])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E6E824265A32;
        Tue, 30 Jul 2019 16:16:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, bmastbergen@untangle.com
Subject: [PATCH nft,RFC,PoC 2/2] src: restore typeof datatype when listing set definition
Date:   Tue, 30 Jul 2019 16:16:17 +0200
Message-Id: <20190730141620.2129-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190730141620.2129-1-pablo@netfilter.org>
References: <20190730141620.2129-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a proof-of-concept.

The idea behind this patch is to store the typeof definition
so it can be restored when listing it back.

Better way to do this would be to store the typeof expression
definition in a way that the set->key expression can be rebuilt.

Particularly, the code to print into the buffer is a quick and
dirty hack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/rule.h |  3 +++
 src/mnl.c      | 27 +++++++++++++++++++++++++++
 src/netlink.c  |  9 ++++++++-
 src/rule.c     |  9 +++++++--
 4 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index ee881b9ccd17..15b0fc684726 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -278,6 +278,7 @@ extern struct rule *rule_lookup_by_index(const struct chain *chain,
  * @timeout:	default timeout value
  * @key:	key expression (data type, length))
  * @datatype:	mapping data type
+ * @datatypeof:	data type of expression
  * @datalen:	mapping data len
  * @objtype:	mapping object type
  * @init:	initializer
@@ -295,7 +296,9 @@ struct set {
 	uint32_t		gc_int;
 	uint64_t		timeout;
 	struct expr		*key;
+	const char		*key_str; /* XXX a hack, use struct expr */
 	const struct datatype	*datatype;
+	const struct expr	*datatypeof;
 	unsigned int		datalen;
 	uint32_t		objtype;
 	struct expr		*init;
diff --git a/src/mnl.c b/src/mnl.c
index eab8d5486437..2961bf6181a3 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -843,6 +843,33 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 				 set->automerge))
 		memory_allocation_error();
 
+	/* Set definition uses typeof to define datatype. */
+	if (!(set->key->flags & EXPR_F_CONSTANT)) {
+		struct output_ctx octx = {};
+		char buf[64];
+		int fds[2];
+
+		/* XXX a huge hack here below...
+		 *
+		 * Instead of storing the string, please store the expression
+		 * type and fields, ie. [ payload, desc->name, tmpl->token,
+		 * base, offset ]. This allows us to rebuild the expression
+		 * from the delinearize path. Similarly for other expressions.
+		 * Add new indirection to expr_ops to store a structure in the
+		 * TLV.
+		 */
+		assert(pipe(fds) == 0);
+		octx.output_fp = fdopen(fds[1], "w");
+		expr_print(set->key, &octx);
+		read(fds[0], buf, sizeof(buf));
+		close(fds[0]);
+		close(fds[1]);
+
+		if (!nftnl_udata_put(udbuf, NFTNL_UDATA_SET_MERGE_ELEMENTS + 1,
+				     strlen(buf) + 1, buf))
+			memory_allocation_error();
+	}
+
 	nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf),
 			   nftnl_udata_buf_len(udbuf));
 	nftnl_udata_buf_free(udbuf);
diff --git a/src/netlink.c b/src/netlink.c
index 14b0df410726..1ccc98c3512a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -534,6 +534,8 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 		if (len != sizeof(uint32_t))
 			return -1;
 		break;
+	case NFTNL_UDATA_SET_MERGE_ELEMENTS + 1:
+		break;
 	default:
 		return 0;
 	}
@@ -544,11 +546,12 @@ static int set_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 				    const struct nftnl_set *nls)
 {
-	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1] = {};
+	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1 + 1] = {};
 	uint32_t flags, key, data, data_len, objtype = 0;
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
 	enum byteorder databyteorder = BYTEORDER_INVALID;
 	const struct datatype *keytype, *datatype;
+	const char *key_str = NULL;
 	bool automerge = false;
 	const char *udata;
 	struct set *set;
@@ -569,6 +572,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		GET_U32_UDATA(databyteorder, NFTNL_UDATA_SET_DATABYTEORDER);
 		GET_U32_UDATA(automerge, NFTNL_UDATA_SET_MERGE_ELEMENTS);
 
+		if (ud[NFTNL_UDATA_SET_MERGE_ELEMENTS + 1])
+			key_str = xstrdup(nftnl_udata_get(ud[NFTNL_UDATA_SET_MERGE_ELEMENTS + 1]));
+
 #undef GET_U32_UDATA
 	}
 
@@ -604,6 +610,7 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	set->handle.set.name = xstrdup(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	set->automerge	   = automerge;
 
+	set->key_str = key_str;
 	set->key     = constant_expr_alloc(&netlink_location,
 					   set_datatype_alloc(keytype, keybyteorder),
 					   keybyteorder,
diff --git a/src/rule.c b/src/rule.c
index 293606576044..c21a550c8712 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -465,8 +465,13 @@ static void set_print_declaration(const struct set *set,
 	if (nft_output_handle(octx))
 		nft_print(octx, " # handle %" PRIu64, set->handle.handle.id);
 	nft_print(octx, "%s", opts->nl);
-	nft_print(octx, "%s%stype %s",
-		  opts->tab, opts->tab, set->key->dtype->name);
+	if (set->key_str) {
+		nft_print(octx, "%s%stypeof %s",
+			  opts->tab, opts->tab, set->key_str);
+	} else {
+		nft_print(octx, "%s%stype %s",
+			  opts->tab, opts->tab, set->key->dtype->name);
+	}
 	if (set_is_datamap(set->flags))
 		nft_print(octx, " : %s", set->datatype->name);
 	else if (set_is_objmap(set->flags))
-- 
2.11.0

