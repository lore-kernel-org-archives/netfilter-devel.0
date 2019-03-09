Return-Path: <SRS0=r5Yn=RM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B99FC43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Mar 2019 09:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B2C520866
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Mar 2019 09:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfCIJYj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 04:24:39 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37934 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726208AbfCIJYj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 04:24:39 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h2YDa-000754-Pl; Sat, 09 Mar 2019 10:24:34 +0100
Date:   Sat, 9 Mar 2019 10:24:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] netfilter: set skb transport_header before calling
 sctp_compute_cksum
Message-ID: <20190309092434.oflik6j57yrhpkh5@breakpoint.cc>
References: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
 <20190308155049.by7f4uzjxqnf3xu7@salvia>
 <CADvbK_djd5ckv3nTROsmHNdr0Z5ULt7MF3MXtNYAO58mo+po7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_djd5ckv3nTROsmHNdr0Z5ULt7MF3MXtNYAO58mo+po7Q@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:
>   https://marc.info/?l=linux-netdev&m=155109395226858&w=2
> But from sctp side, Neil preferred sctp_hdr().
> 
> We need to either add skb_set_transport_header() in sctp_s/dnat_handler()
> and sctp_manip_pkt(), or bring that patch back?
> 
> Now it seems not good to set skb->transport_header in netfilter code.

I think its fine, but I wonder why we need to do it.

Since 21d1196a35f5686c4323e42a62fdb4b23b0ab4a3 ipv4 input path sets
transport header before netfilter.  The only problem is that linear
access is illegal without may_pull checks, but in this case the
make_writable call takes care of this already.

So, why was this patch needed?
If we need it, do we also need to add it in other locations that
deal with sctp csum (e.g. in ipvs?).

Thanks,
Florian
