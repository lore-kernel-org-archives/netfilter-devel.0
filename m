Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D815AC4BA0B
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC97220637
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 11:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgBZL3n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 06:29:43 -0500
Received: from correo.us.es ([193.147.175.20]:57498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbgBZL3n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 06:29:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0A9418D020
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 12:29:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D203FDA3AA
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 12:29:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D03A0DA3AC; Wed, 26 Feb 2020 12:29:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C9B4DA3AE;
        Wed, 26 Feb 2020 12:29:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 12:29:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7FEF042EF42B;
        Wed, 26 Feb 2020 12:29:28 +0100 (CET)
Date:   Wed, 26 Feb 2020 12:29:35 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling entries
 in mapping table
Message-ID: <20200226112935.bdsz733f2gltkbpu@salvia>
References: <20200223222258.2bb7516a@redhat.com>
 <20200225123934.p3vru3tmbsjj2o7y@salvia>
 <20200225141346.7406e06b@redhat.com>
 <20200225134236.sdz5ujufvxm2in3h@salvia>
 <20200225153435.17319874@redhat.com>
 <20200225202143.tqsfhggvklvhnsvs@salvia>
 <20200225213815.3c0a1caa@redhat.com>
 <20200225205847.s5pjjp652unj6u7v@salvia>
 <20200226105804.xramr6duqkvrtop3@salvia>
 <20200226120253.71e9f0e0@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ak4wabhsx6bogq4d"
Content-Disposition: inline
In-Reply-To: <20200226120253.71e9f0e0@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ak4wabhsx6bogq4d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 26, 2020 at 12:02:53PM +0100, Stefano Brivio wrote:
> On Wed, 26 Feb 2020 11:58:04 +0100
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > I'm attaching a patch for the core. This is handling -ENOTEMPTY which
> > is (ab)used to report the partial element matching.
> > 
> > if NLM_F_EXCL is set off, then -EEXIST becomes 0.
> >                           then -ENOTEMPTY becomes -EEXIST.
> > 
> > Would this work for you?
> 
> Oops, I sent you my patch 80 seconds later it seems. Yes, we just need
> to s/TTY/TEMPTY/ :)

All good, we're in sync.

> Let me know how to proceed, if you want me to post that or you want to
> post that (as a series?).

I'm revisiting the patch I sent, it would be like this, to not expose
the -ENOTEMPTY to userspace.

--ak4wabhsx6bogq4d
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_tables-report-ENOTEMPTY-on-element-inte.patch"

From a17f22eac1dfd599ff97bb262fc97d64333b06fe Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 26 Feb 2020 12:11:53 +0100
Subject: [PATCH] netfilter: nf_tables: report ENOTEMPTY on element
 intersection

The set backend uses ENOTEMPTY to report an intersection between two
range elements.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d1318bdf49ca..48ad273a273e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5059,7 +5059,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
 	if (err) {
-		if (err == -EEXIST) {
+		if (err == -EEXIST || err == -ENOTEMPTY) {
 			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
 			    nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) ||
 			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
@@ -5073,10 +5073,17 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 				    nft_set_ext_data(ext2), set->dlen) != 0) ||
 			    (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF) &&
-			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2)))
+			     *nft_set_ext_obj(ext) != *nft_set_ext_obj(ext2))) {
 				err = -EBUSY;
-			else if (!(nlmsg_flags & NLM_F_EXCL))
-				err = 0;
+			} else {
+				/* ENOTEMPTY reports an intersection between
+				 * this element and an existing one.
+				 */
+				if (err == -ENOTEMPTY)
+					err = -EEXIST;
+				else if (!(nlmsg_flags & NLM_F_EXCL))
+					err = 0;
+			}
 		}
 		goto err_element_clash;
 	}
-- 
2.11.0


--ak4wabhsx6bogq4d--
