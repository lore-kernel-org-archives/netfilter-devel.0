Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B70C433FF
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAB9420679
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 09:37:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbfHBJhb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 05:37:31 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60384 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729051AbfHBJha (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 05:37:30 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1htU09-0001uv-QC; Fri, 02 Aug 2019 11:37:29 +0200
Date:   Fri, 2 Aug 2019 11:37:29 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3] netfilter: nft_meta: support for time matching
Message-ID: <20190802093729.3sko4wr45shjwnw2@breakpoint.cc>
References: <20190802071233.5580-1-a@juaristi.eus>
 <55c6fec8-6c1d-174e-942e-b3f3d6f53542@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55c6fec8-6c1d-174e-942e-b3f3d6f53542@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ander Juaristi <a@juaristi.eus> wrote:
> 
> 
> On 2/8/19 9:12, Ander Juaristi wrote:
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index 82abaa183fc3..6d9dd120b466 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -799,6 +799,9 @@ enum nft_exthdr_attributes {
> >    * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
> >    * @NFT_META_BRI_IIFPVID: packet input bridge port pvid
> >    * @NFT_META_BRI_IIFVPROTO: packet input bridge vlan proto
> > + * @NFT_META_TIME: a UNIX timestamp
> > + * @NFT_META_TIME_DAY: day of week
> > + * @NFT_META_TIME_HOUR: hour of day
> >    */
> >   enum nft_meta_keys {
> >   	NFT_META_LEN,
> > @@ -829,8 +832,9 @@ enum nft_meta_keys {
> >   	NFT_META_SECPATH,
> >   	NFT_META_IIFKIND,
> >   	NFT_META_OIFKIND,
> > -	NFT_META_BRI_IIFPVID,
> > -	NFT_META_BRI_IIFVPROTO,
> 
> I needed to remove these two so that the next three constants take the
> correct values (otherwise it won't work because the meta keys sent by
> userspace and those expected by the kernel don't match).

This breaks the build.

> Those two constants NFT_META_BRI_IIFPVID and NFT_META_BRI_IIFVPROTO aren't
> defined in nftables, I don't know why.

The userspace patch has not been applied yet, only the kernel one.

You can include a pre-patch in your series that adds the enums.

"sync meta keys with kernel" or similar.
