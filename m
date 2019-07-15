Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E1EC7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 12:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45481206B8
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 12:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbfGOMcv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 08:32:51 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48724 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728933AbfGOMcv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 08:32:51 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hn09x-0004R8-7H; Mon, 15 Jul 2019 14:32:49 +0200
Date:   Mon, 15 Jul 2019 14:32:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: synproxy: fix rst sequence number
 mismatch
Message-ID: <20190715123249.4qc4rwuse3nxuq3y@breakpoint.cc>
References: <20190712104513.11683-1-ffmancera@riseup.net>
 <20190713222624.heea2xjqeh52dohu@breakpoint.cc>
 <D18A40D8-9569-4975-8CC2-3ED9DE7FFFB7@riseup.net>
 <e452baf5-0ac8-473f-0568-389de62eb375@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e452baf5-0ac8-473f-0568-389de62eb375@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:
> >> ... its not obvious to me why a reset is generated here in first place,
> >> and why changing code in TCP_CLOSE case helps?
> >> (I could guess the hook was called in postrouting and close transition
> >> came from rst that was sent, but that still doesn't explain why it
> >> was sent to begin with).
> >>
> >> I assume the hostname "netfilter" is the synproxy machine, and
> >> 192.168.122.1 is a client we're proxying for, right?
> > 
> > Sure, I will prepare a detailed description of the problem. Sorry about that and thanks!
> > 
> 
> When there is no service listening in the specified port in the backend,
> we get a reset packet from the backend that is sent to the client but
> the sequence number mismatches the tcp stream one so there is a loop in
> which the client is requesting it until the timeout.

Oh, no listener on the backend -- now this tcpdump makes sense :-)

I wondered where synproxy would generate a reset.  It doesn't.  Doh.

> To solve this we need to adjust the sequence number, we cannot use the
> !SEEN_REPLY_BIT test because it is always false at this point and then

Right, that part now makes sense too, we only sent the syn to the
backend, so we have not seen a reply yet.  The reset switches the
conntrack to CLOSED immediately, so that part now makes sense to me too.

> we never get into the if statement. Instead of check the !SEEN_REPLY_BIT
> we need to check if the CT IP address is different to the original CT IP.

Yes indeed.

> I hope that answers your questions, here is the tcpdump output with only
> the important information. Please note that "netfilter" is the synproxy
> machine and 192.168.122.1 is the client. If that is fine to you, I will
> include this description into the commit message and send a v3 patch.
> Thanks Florian! :-)

Yes, perhaps also add a small comment to the tcpdump that the reset
is not coming from the synproxy machine but is originally received from
client.

Perhaps something like this:
> TCPDUMP output:
> 
> 14:51:00.024418 IP 192.168.122.1.41462 > netfilter.90: Flags [S], seq
> 4023580551,
> 14:51:00.024454 IP netfilter.90 > 192.168.122.1.41462: Flags [S.], seq
> 727560212, ack 4023580552,
> 14:51:00.024524 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
# here, SYNPROXY will send a SYN to the real server, as the 3whs was
# completed sucessfully.
# instead of a syn/ack that we can intercept, we instead received a
# reset packet from the real backend, that we forward to the original
# client.  However, we don't use the correct sequence number, so
# the reset is not effective in closing the connection coming from
# the client.
> 14:51:01.474395 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,

Client then retries until timeout.


Thats just a suggestion so that its more obvious that we see only
one leg of the connection in the tcpdump.

This explanation makes sense, thanks a lot for elaborating on this.
