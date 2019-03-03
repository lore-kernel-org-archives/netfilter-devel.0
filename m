Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76624C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 19:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4903B20835
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 19:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfCCTQi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 14:16:38 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40076 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbfCCTQi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 14:16:38 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h0Wb7-0002FR-Ik; Sun, 03 Mar 2019 20:16:29 +0100
Date:   Sun, 3 Mar 2019 20:16:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: tcp: only close if RST
 matches exact sequence
Message-ID: <20190303191629.jl6hrv4yo6ctqbt4@breakpoint.cc>
References: <20190221160931.10775-1-fw@strlen.de>
 <20190301132436.elh5rxs6vxwnykd4@salvia>
 <alpine.DEB.2.20.1903031715240.18380@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1903031715240.18380@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > @Jozsef, if you could also have a look to confirm if you see any
> > issue, this looks fine to me and we, of course, can revert this in
> > this this tightening in RST tracking has any side issue. Thanks!
> 
> The only problem I see is this part:
> 
> > > If the peer sends a challenge ack, connection timeout will be reset.
> 
> RFC5961 does not discuss the issue of the timeout when the challenge ack 
> is sent and get lost, never reaches the destination. Like in this 
> case:
> 
> non RFC5961 client 	firewall	our firewall	RFC5961 server
> in-window RST ->
> 			ct dropped	ct kept,
> 					CLOSED timeout
> 							<- challenge ack
> 					ct kept,
> 					ESTABLISHED timeout
> 			ack dropped


The ESTABLISHED timeout is 5 minutes because of missing ACKs
(outstanding data) in this case though (the RST has "wrong" sequence
number, so the conntrack is flagged accordingly until something
acks the data).

> I think we should keep the CLOSED timeout when the challenge ack is 
> detected, which probably needs a new flag (IP_CT_EXP_CHALLENGE_ACK is for 
> SYN ACK challenges).

I think its fine as is with the unacknowledged data timeout, but it
should be easy to keep the 10 seconds using the flag you suggest).

I think we can even reuse the EXP_CHALLENGE_ACK for this.

> In my opinion it was a very bad design decision of RFC5961 that there's no 
> TCP option/flag to signal to the peer that the sender speaks the RFC5961 
> flavour.

I think its fine, we would have the same problem if the RST was lost
before reaching us.
