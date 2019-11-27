Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B1FC432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 18:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DAA20862
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 18:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfK0SaG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 13:30:06 -0500
Received: from correo.us.es ([193.147.175.20]:43564 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfK0SaG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 13:30:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 114D211D90B
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2019 19:30:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7594DA70A
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2019 19:30:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DB28ADA702; Wed, 27 Nov 2019 19:30:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 730D2DA70A;
        Wed, 27 Nov 2019 19:29:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Nov 2019 19:29:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4A6D142EE38E;
        Wed, 27 Nov 2019 19:29:58 +0100 (CET)
Date:   Wed, 27 Nov 2019 19:29:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 3/8] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20191127182959.cgdjcuzljndbahn5@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
 <5e7c454e030a8ad581a12d88881f96374e96da68.1574428269.git.sbrivio@redhat.com>
 <20191127092945.kp25vjfwxcrbjapx@salvia>
 <20191127120249.292d4a69@elisabeth>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6y373lilnraotfkm"
Content-Disposition: inline
In-Reply-To: <20191127120249.292d4a69@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--6y373lilnraotfkm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stefano,

On Wed, Nov 27, 2019 at 12:02:49PM +0100, Stefano Brivio wrote:
> On Wed, 27 Nov 2019 10:29:45 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > On Fri, Nov 22, 2019 at 02:40:02PM +0100, Stefano Brivio wrote:
[...]
> > I think you also need to check if the object is active in the next
> > generation via nft_genmask_next() and nft_set_elem_active(), otherwise
> > ignore it.
> 
> I guess I should actually do this in nft_pipapo_get(), also because we
> don't want to return inactive elements when userspace "gets" them.

OK. Just a side note: nft_pipapo_get() is also used to get an
interval, that needs current generation. From the insert path, one
need to check the next generation.

[...]
> > > +		return -EEXIST;
> > > +	}
> > > +
> > > +	if (!nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) ||
> > > +	    !(*nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)) {
> > > +		priv->start_elem = e;
> > > +		*ext2 = &e->ext;
> > > +		memcpy(priv->start_data, data, priv->width);
> > > +		return 0;
> > > +	}
> > > +
> > > +	if (!priv->start_elem)
> > > +		return -EINVAL;  
> > 
> > I'm working on a sketch patch to extend the front-end code to make
> > this easier for you, will post it asap, so you don't need this special
> > handling to collect both ends of the interval.
> 
> Nice, thanks. Mind that I think this is actually a bit ugly but fine.
> As I was mentioning to Florian, it doesn't present any particular race
> with bad consequences (at least in v2).
> 
> Right now I was trying to get the NFTA_SET_DESC_CONCAT >
> NFTA_LIST_ELEM > NFTA_SET_FIELD_LEN nesting implemented in libnftnl in
> a somewhat acceptable way. Let me know if the front-end changes would
> affect this significantly, I'll wait for your patch in that case.

I'm attaching a sketch patch, I need a bit more time to finish it. The
idea is to place the interval end in the same element, instead of two.
This should also simplify the rbtree implementation. Main issue is
that this needs a bit more work to make it backward compatible.

P.S: I'm skipping the transaction discussion in this email, will come
back to it later.

--6y373lilnraotfkm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-add-NFT_SET_EXT_KEY_END.patch"

From b6d159e8b3e3f1c6e41e6101996df36e6977c3e3 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 27 Nov 2019 19:01:10 +0100
Subject: [PATCH] netfilter: nf_tables: add NFT_SET_EXT_KEY_END

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  7 +++++++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 35 ++++++++++++++++++++++++++------
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2d0275f13bbf..51338b438e86 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -509,6 +509,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
  *	@NFT_SET_EXT_USERDATA: user data associated with the element
  *	@NFT_SET_EXT_EXPR: expression assiociated with the element
  *	@NFT_SET_EXT_OBJREF: stateful object reference associated with element
+ *	@NFT_SET_EXT_KEY_END: closing element key
  *	@NFT_SET_EXT_NUM: number of extension types
  */
 enum nft_set_extensions {
@@ -520,6 +521,7 @@ enum nft_set_extensions {
 	NFT_SET_EXT_USERDATA,
 	NFT_SET_EXT_EXPR,
 	NFT_SET_EXT_OBJREF,
+	NFT_SET_EXT_KEY_END,
 	NFT_SET_EXT_NUM
 };
 
@@ -606,6 +608,11 @@ static inline struct nft_data *nft_set_ext_key(const struct nft_set_ext *ext)
 	return nft_set_ext(ext, NFT_SET_EXT_KEY);
 }
 
+static inline struct nft_data *nft_set_ext_key_end(const struct nft_set_ext *ext)
+{
+	return nft_set_ext(ext, NFT_SET_EXT_KEY_END);
+}
+
 static inline struct nft_data *nft_set_ext_data(const struct nft_set_ext *ext)
 {
 	return nft_set_ext(ext, NFT_SET_EXT_DATA);
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ed8881ad18ed..9e4f0a584c57 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -368,6 +368,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_ELEM_OBJREF: stateful object reference (NLA_STRING)
+ * @NFTA_SET_ELEM_KEY_END: closing key value (NLA_STRING)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -380,6 +381,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_EXPR,
 	NFTA_SET_ELEM_PAD,
 	NFTA_SET_ELEM_OBJREF,
+	NFTA_SET_ELEM_KEY_END,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ab325c6fcfb8..b8b2b918bd47 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3932,6 +3932,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 					    .len = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_ELEM_EXPR]		= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_KEY_END]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
@@ -4399,10 +4400,11 @@ static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
 	return trans;
 }
 
-void *nft_set_elem_init(const struct nft_set *set,
-			const struct nft_set_ext_tmpl *tmpl,
-			const u32 *key, const u32 *data,
-			u64 timeout, u64 expiration, gfp_t gfp)
+static void *__nft_set_elem_init(const struct nft_set *set,
+				 const struct nft_set_ext_tmpl *tmpl,
+				 const u32 *key, const u32 *key_end,
+				 const u32 *data, u64 timeout, u64 expiration,
+				 gfp_t gfp)
 {
 	struct nft_set_ext *ext;
 	void *elem;
@@ -4415,6 +4417,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 	nft_set_ext_init(ext, tmpl);
 
 	memcpy(nft_set_ext_key(ext), key, set->klen);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
+		memcpy(nft_set_ext_key_end(ext), key_end, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		memcpy(nft_set_ext_data(ext), data, set->dlen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
@@ -4428,6 +4432,15 @@ void *nft_set_elem_init(const struct nft_set *set,
 	return elem;
 }
 
+void *nft_set_elem_init(const struct nft_set *set,
+			const struct nft_set_ext_tmpl *tmpl,
+			const u32 *key, const u32 *data, u64 timeout,
+			u64 expiration, gfp_t gfp)
+{
+	return __nft_set_elem_init(set, tmpl, key, NULL, data, timeout,
+				   expiration, gfp);
+}
+
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr)
 {
@@ -4480,6 +4493,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_binding *binding;
 	struct nft_object *obj = NULL;
 	struct nft_userdata *udata;
+	struct nft_data key_end;
 	struct nft_data_desc d2;
 	struct nft_data data;
 	enum nft_registers dreg;
@@ -4551,6 +4565,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
+	if (nla[NFTA_SET_ELEM_KEY_END]) {
+		err = nft_set_elem_key_ext(ctx, set, &key_end, &tmpl,
+					   nla[NFTA_SET_ELEM_KEY_END],
+					   NFT_SET_EXT_KEY_END);
+		if (err < 0)
+			return err;
+	}
+
 	if (timeout > 0) {
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
 		if (timeout != set->timeout)
@@ -4623,8 +4645,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	err = -ENOMEM;
-	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
-				      timeout, expiration, GFP_KERNEL);
+	elem.priv = __nft_set_elem_init(set, &tmpl, elem.key.val.data,
+					key_end.data, data.data, timeout,
+					expiration, GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err3;
 
-- 
2.11.0


--6y373lilnraotfkm--
