Return-Path: <SRS0=jWs9=AB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FF4C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 11:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC6A23B1C
	for <netfilter-devel@archiver.kernel.org>; Sat, 20 Jun 2020 11:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgFTLEM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jun 2020 07:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgFTLEL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jun 2020 07:04:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DE0C06174E
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2020 04:04:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jmbI4-0000Dt-2X; Sat, 20 Jun 2020 13:04:04 +0200
Date:   Sat, 20 Jun 2020 13:04:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eugene Crosser <crosser@average.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: Expose skb_gso_validate_network_len() [Was: ebtables:
 load-on-demand extensions]
Message-ID: <20200620110404.GF26990@breakpoint.cc>
References: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org>
 <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr>
 <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
 <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr>
 <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
 <20200619151530.GA3894@salvia>
 <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13977ee9-d93b-62fd-c86a-6c4466f63e38@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eugene Crosser <crosser@average.org> wrote:
> On 19/06/2020 17:15, Pablo Neira Ayuso wrote:
> >>>>> Why not make a patch to publicly expose the skb's data via nft_meta?
> >>>>> No more custom modules, no more userspace modifications [..]
> >>>>
> >>>> For our particular use case, we are running the skb through the kernel
> >>>> function `skb_validate_network_len()` with custom mtu size [..]
> 
> (the function name is skb_gso_validate_network_len, my mistake)
> 
> I previously expressed strong opinion that our "hack" to send icmp rejects on
> Layer 2 will not be useful for anyone else. But the existence of the commit from
> Michael Braun proves that I was wrong, and Jan Engelhards was right: it probably
> makes sense to implement the functionality that we need within the "new" nft
> infrastructure.

Yes, just do what Jan suggested and expost this in nft_meta.c

> As far as I understand, the part that is missing in the existing implementation
> is exposure (in some form) of `skb_gso_validate_network_len()` function to
> user-configurable filters.

No, nft already has "< $value" logic.
The only missing piece of the puzzle is a way to populate an nft
register with the "size per segment" value.

> Because the kernel does now expose the _size_ under
> which a gso skb can be segmented, but only the _boolean_ with the meaning "this
> gso skb can fit in mtu that you've specified",

It would be best to remove "static" from skb_gso_network_seglen() and
add an EXPORT_SYMBOL_GPL for it.

Then, extend nft_meta.c to set register content to that for gso
or the ip/ipv6 packet size for !gso.

Then, extend nft to support something like

      nft insert rule bridge filter FORWARD \
        ip frag-off & 0x4000 != 0 \
        ip protocol tcp \
	meta nh_segment_length > 1400 \
        reject with icmp type frag-needed

[ NB: I suck at naming, so feel free to come up
  with somethng more descriptive than "nh_segment_length".
  l3size? nh-len...? ]
