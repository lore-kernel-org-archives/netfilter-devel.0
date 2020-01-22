Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81B2C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 11:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F6B621734
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 11:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAVLnq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 06:43:46 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:38730 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbgAVLnp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 06:43:45 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iuEQ1-0007c2-PI; Wed, 22 Jan 2020 12:43:33 +0100
Date:   Wed, 22 Jan 2020 12:43:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Praveen Chaudhary <praveen5582@gmail.com>, fw@strlen.de,
        pablo@netfilter.org, davem@davemloft.net, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: Re: [PATCH v3] [net]: Fix skb->csum update in
 inet_proto_csum_replace16().
Message-ID: <20200122114333.GQ795@breakpoint.cc>
References: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
 <1573080729-3102-2-git-send-email-pchaudhary@linkedin.com>
 <16d56ee6-53bc-1124-3700-bc0a78f927d6@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16d56ee6-53bc-1124-3700-bc0a78f927d6@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> wrote:
> > @@ -449,9 +464,6 @@ void inet_proto_csum_replace16(__sum16 *sum, struct sk_buff *skb,
> >   	if (skb->ip_summed != CHECKSUM_PARTIAL) {
> >   		*sum = csum_fold(csum_partial(diff, sizeof(diff),
> >   				 ~csum_unfold(*sum)));
> > -		if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
> > -			skb->csum = ~csum_partial(diff, sizeof(diff),
> > -						  ~skb->csum);
> 
> What is the technical rationale in removing this here but not in any of the
> other inet_proto_csum_replace*() functions? You changelog has zero analysis
> on why here but not elsewhere this change would be needed?

Right, I think it could be dropped everywhere BUT there is a major caveat:

At least for the nf_nat case ipv4 header manipulation (which uses the other
helpers froum utils.c) will eventually also update iph->checksum field
to account for the changed ip addresses.

And that update doesn't touch skb->csum.

So in a way the update of skb->csum in the other helpers indirectly account
for later ip header checksum update.

At least that was my conclusion when reviewing the earlier incarnation
of the patch.
