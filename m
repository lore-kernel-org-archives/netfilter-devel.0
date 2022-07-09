Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FA0CCA47C
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Jul 2022 14:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiGIOVD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Jul 2022 10:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiGIOUu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Jul 2022 10:20:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90B341583F
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2022 07:20:48 -0700 (PDT)
Date:   Sat, 9 Jul 2022 16:20:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 1/2] netfilter: nf_tables: release element key when
 parser fails
Message-ID: <YsmOvf3cQYme89zy@salvia>
References: <20220708100633.18896-1-pablo@netfilter.org>
 <YsmN+h5c6OazXBgn@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsmN+h5c6OazXBgn@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 09, 2022 at 04:17:30PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jul 08, 2022 at 12:06:32PM +0200, Pablo Neira Ayuso wrote:
> > Call nft_data_release() to release the element keys otherwise this
> > might leak chain reference counter.
> > 
> > Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
> > Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: coalesce two similar patches:
> >     https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220708084453.11066-1-pablo@netfilter.org/
> >     https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220708085805.12310-1-pablo@netfilter.org/
> 
> Scratch this. nft_data_release() is noop for NFT_DATA_VERDICT case.

s/NFT_DATA_VERDICT/NFT_DATA_VALUE

> Calling this is good for consistency, but let's schedule this patch
> for nf-next instead.
