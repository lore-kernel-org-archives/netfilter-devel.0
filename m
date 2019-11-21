Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FA7C432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 13:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9ABCC2089D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 13:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKUN1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 08:27:43 -0500
Received: from correo.us.es ([193.147.175.20]:35556 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUN1n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 08:27:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33F331022AC
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 14:27:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21DECB7FF2
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2019 14:27:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1725DFB362; Thu, 21 Nov 2019 14:27:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04365DA4CA;
        Thu, 21 Nov 2019 14:27:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Nov 2019 14:27:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CF04342EF4E1;
        Thu, 21 Nov 2019 14:27:35 +0100 (CET)
Date:   Thu, 21 Nov 2019 14:27:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC 2/4] src: add ability to set/get secmarks to/from connection
Message-ID: <20191121132737.gkbv4rthnd5nerde@salvia>
References: <20191120174357.26112-1-cgzones@googlemail.com>
 <20191120174357.26112-2-cgzones@googlemail.com>
 <20191121130634.nohe3p7coyx3pd7u@salvia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nrorknxn6g47netc"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191121130634.nohe3p7coyx3pd7u@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--nrorknxn6g47netc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Nov 21, 2019 at 02:06:34PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 20, 2019 at 06:43:55PM +0100, Christian Göttsche wrote:
> > Labeling established and related packets requires the secmark to be stored in the connection.
> > Add the ability to store and retrieve secmarks like:
> > 
> >     ...
> >     chain input {
> >         ...
> > 
> >         # label new incoming packets
> >         ct state new meta secmark set tcp dport map @secmapping_in
> > 
> >         # add label to connection
> >         ct state new ct secmark set meta secmark
> > 
> >         # set label for est/rel packets from connection
> >         ct state established,related meta secmark set ct secmark
> > 
> >         ...
> >     }
> >     ...
> >     chain output {
> >         ...
> > 
> >         # label new outgoing packets
> >         ct state new meta secmark set tcp dport map @secmapping_out
> > 
> >         # add label to connection
> >         ct state new ct secmark set meta secmark
> > 
> >         # set label for est/rel packets from connection
> >         ct state established,related meta secmark set ct secmark
> > 
> >         ...
> >         }
> >     ...
> 
> I have applied this with minor changes on the evaluation side. Just
> follow up with another patch in case you find any issue.

Actually, I'm keeping back 2/4. I'm attaching the update I made.

I think it's good to disallow this:

        ct secmark 12
        meta secmark 12

but you also have to check from the evaluation phase that ct and meta
statements do not allow setting a constant value, ie.

        ct secmark set 12
        meta secmark set 12

From the objref statement evaluation step, you can check if this
expression is a constant through flags.

Thanks.

--nrorknxn6g47netc
Content-Type: text/x-diff; charset=iso-8859-1
Content-Disposition: attachment; filename="x.patch"
Content-Transfer-Encoding: 8bit

commit 785049e16782f7afb658927e5fee3b1da761f97d
Author: Christian Göttsche <cgzones@googlemail.com>
Date:   Wed Nov 20 18:43:55 2019 +0100

    src: add ability to set/get secmarks to/from connection
    
    Labeling established and related packets requires the secmark to be stored in the connection.
    Add the ability to store and retrieve secmarks like:
    
        ...
        chain input {
            ...
    
            # label new incoming packets
            ct state new meta secmark set tcp dport map @secmapping_in
    
            # add label to connection
            ct state new ct secmark set meta secmark
    
            # set label for est/rel packets from connection
            ct state established,related meta secmark set ct secmark
    
            ...
        }
        ...
        chain output {
            ...
    
            # label new outgoing packets
            ct state new meta secmark set tcp dport map @secmapping_out
    
            # add label to connection
            ct state new ct secmark set meta secmark
    
            # set label for est/rel packets from connection
            ct state established,related meta secmark set ct secmark
    
            ...
            }
        ...
    
    This patch also disallow constant value on the right hand side.
    
     # nft add rule x y meta secmark 12
     Error: Cannot be used with right hand side constant value
     add rule x y meta secmark 12
                  ~~~~~~~~~~~~ ^^
     # nft add rule x y ct secmark 12
     Error: Cannot be used with right hand side constant value
     add rule x y ct secmark 12
                  ~~~~~~~~~~ ^^
    
    This patch improves 3bc84e5c1fdd ("src: add support for setting secmark").
    
    Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/src/ct.c b/src/ct.c
index ed458e6b679b..9e6a8351ffb2 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -299,6 +299,8 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
 					      BYTEORDER_BIG_ENDIAN, 128),
 	[NFT_CT_DST_IP6]	= CT_TEMPLATE("ip6 daddr", &ip6addr_type,
 					      BYTEORDER_BIG_ENDIAN, 128),
+	[NFT_CT_SECMARK]	= CT_TEMPLATE("secmark", &integer_type,
+					      BYTEORDER_HOST_ENDIAN, 32),
 };
 
 static void ct_print(enum nft_ct_keys key, int8_t dir, uint8_t nfproto,
diff --git a/src/evaluate.c b/src/evaluate.c
index e54eaf1a7110..00f6c6a4cc3e 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1784,6 +1784,18 @@ static int expr_evaluate_relational(struct eval_ctx *ctx, struct expr **expr)
 					 left->dtype->desc,
 					 right->dtype->desc);
 
+	/*
+	 * Statements like 'ct secmark 12' are parsed as relational,
+	 * disallow constant value on the right hand side.
+	 */
+	if (((left->etype == EXPR_META &&
+	      left->meta.key == NFT_META_SECMARK) ||
+	     (left->etype == EXPR_CT &&
+	      left->ct.key == NFT_CT_SECMARK)) &&
+	    right->flags & EXPR_F_CONSTANT)
+		return expr_binary_error(ctx->msgs, right, left,
+                                         "Cannot be used with right hand side constant value");
+
 	switch (rel->op) {
 	case OP_EQ:
 	case OP_IMPLICIT:
diff --git a/src/meta.c b/src/meta.c
index 69a897a92686..796d8e941486 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -698,6 +698,8 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_TIME_HOUR]	= META_TEMPLATE("hour", &hour_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_SECMARK]	= META_TEMPLATE("secmark", &integer_type,
+						32, BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 631b7d684555..707f46716ed3 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4190,9 +4190,16 @@ meta_stmt		:	META	meta_key	SET	stmt_expr
 			{
 				switch ($2) {
 				case NFT_META_SECMARK:
-					$$ = objref_stmt_alloc(&@$);
-					$$->objref.type = NFT_OBJECT_SECMARK;
-					$$->objref.expr = $4;
+					switch ($4->etype) {
+					case EXPR_CT:
+						$$ = meta_stmt_alloc(&@$, $2, $4);
+						break;
+					default:
+						$$ = objref_stmt_alloc(&@$);
+						$$->objref.type = NFT_OBJECT_SECMARK;
+						$$->objref.expr = $4;
+						break;
+					}
 					break;
 				default:
 					$$ = meta_stmt_alloc(&@$, $2, $4);
@@ -4388,6 +4395,7 @@ ct_key			:	L3PROTOCOL	{ $$ = NFT_CT_L3PROTOCOL; }
 			|	PROTO_DST	{ $$ = NFT_CT_PROTO_DST; }
 			|	LABEL		{ $$ = NFT_CT_LABELS; }
 			|	EVENT		{ $$ = NFT_CT_EVENTMASK; }
+			|	SECMARK		{ $$ = NFT_CT_SECMARK; }
 			|	ct_key_dir_optional
 			;
 

--nrorknxn6g47netc--
