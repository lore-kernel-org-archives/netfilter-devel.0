Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33AF5C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 19:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0346A20863
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 19:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbfCCT7h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 14:59:37 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40106 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726544AbfCCT7h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 14:59:37 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h0XGo-0002NY-Sm; Sun, 03 Mar 2019 20:59:35 +0100
Date:   Sun, 3 Mar 2019 20:59:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: tcp: only close if RST
 matches exact sequence
Message-ID: <20190303195934.r35rgo24dobmpz3y@breakpoint.cc>
References: <20190221160931.10775-1-fw@strlen.de>
 <20190301132436.elh5rxs6vxwnykd4@salvia>
 <alpine.DEB.2.20.1903031715240.18380@blackhole.kfki.hu>
 <20190303191629.jl6hrv4yo6ctqbt4@breakpoint.cc>
 <alpine.DEB.2.20.1903032035350.19344@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1903032035350.19344@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > The ESTABLISHED timeout is 5 minutes because of missing ACKs 
> > (outstanding data) in this case though (the RST has "wrong" sequence 
> > number, so the conntrack is flagged accordingly until something acks the 
> > data).
> 
> Sorry, but I don't see where is the outstanding data. Up to the RST and 
> the challenge ACK there's no missing ACK. The RST hasn't got wrong seq 
> because it's in the window. The RST flag is not counted. What do I miss?

There is no outstanding data, but conntrack thinks there is.

If we have this:
seq 100 ack x len 100
seq 200 rst x len 0

Then rst is accepted immediately and we move to CLOSE.

When we get this:
seq 100 ack x len 100
seq 210 rst x len 0

Then from conntrack point of view, we're 10 bytes "short" because td_end
is 200, and new sequence is 210.  So we hit this:
  if (after(end, sender->td_end)) {
    sender->td_end = end;
    sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
							                     }
in tcp_in_window().

> If the conntrack timeout is not the ESTABLISHED one after the challenge 
> ACK is seen, that's perfect.

The challenge ACK will use last in-sequence number as seen by the
receiver, so 200 in this case.

If it would be 210, then that would mean that conntrack, for some
reason, did not see those 10 bytes, but the real endpoint did.

And in that case we'd move back to full ESTABLISHED timeout.
