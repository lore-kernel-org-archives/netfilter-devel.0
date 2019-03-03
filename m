Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0134EC43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 19:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B947620842
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 19:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="sOJ0A7dS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfCCTqK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 14:46:10 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:55535 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfCCTqK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 14:46:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 3FAD03C800DC;
        Sun,  3 Mar 2019 20:46:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1551642366; x=1553456767; bh=jcyhtv4dq9
        gBpkyE7zYWSIgYAgGy9S0j/xGviKSRau8=; b=sOJ0A7dS7VYUVsI9RhH9HZXfrD
        C2KM54XuxL7uiDJDvpJFKXO2BhoWCt9X5t+UO2k2suxa74KsbFPeJON6LfE7zUIR
        BA9KXGcpr6lopfJLmSIGzKEfKLON3TM8RO1UasN/uzJG5UYZ2uH9ym5dgo4q3dGr
        QVGttA9QY6+IDJb6M=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun,  3 Mar 2019 20:46:06 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id 200753C800F3;
        Sun,  3 Mar 2019 20:46:06 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 0EE3E21E44; Sun,  3 Mar 2019 20:46:05 +0100 (CET)
Date:   Sun, 3 Mar 2019 20:46:05 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Florian Westphal <fw@strlen.de>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: tcp: only close if RST
 matches exact sequence
In-Reply-To: <20190303191629.jl6hrv4yo6ctqbt4@breakpoint.cc>
Message-ID: <alpine.DEB.2.20.1903032035350.19344@blackhole.kfki.hu>
References: <20190221160931.10775-1-fw@strlen.de> <20190301132436.elh5rxs6vxwnykd4@salvia> <alpine.DEB.2.20.1903031715240.18380@blackhole.kfki.hu> <20190303191629.jl6hrv4yo6ctqbt4@breakpoint.cc>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 3 Mar 2019, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > @Jozsef, if you could also have a look to confirm if you see any
> > > issue, this looks fine to me and we, of course, can revert this in
> > > this this tightening in RST tracking has any side issue. Thanks!
> > 
> > The only problem I see is this part:
> > 
> > > > If the peer sends a challenge ack, connection timeout will be reset.
> > 
> > RFC5961 does not discuss the issue of the timeout when the challenge ack 
> > is sent and get lost, never reaches the destination. Like in this 
> > case:
> > 
> > non RFC5961 client 	firewall	our firewall	RFC5961 server
> > in-window RST ->
> > 			ct dropped	ct kept,
> > 					CLOSED timeout
> > 							<- challenge ack
> > 					ct kept,
> > 					ESTABLISHED timeout
> > 			ack dropped
> 
> 
> The ESTABLISHED timeout is 5 minutes because of missing ACKs 
> (outstanding data) in this case though (the RST has "wrong" sequence 
> number, so the conntrack is flagged accordingly until something acks the 
> data).

Sorry, but I don't see where is the outstanding data. Up to the RST and 
the challenge ACK there's no missing ACK. The RST hasn't got wrong seq 
because it's in the window. The RST flag is not counted. What do I miss?
 
> > I think we should keep the CLOSED timeout when the challenge ack is 
> > detected, which probably needs a new flag (IP_CT_EXP_CHALLENGE_ACK is for 
> > SYN ACK challenges).
> 
> I think its fine as is with the unacknowledged data timeout, but it
> should be easy to keep the 10 seconds using the flag you suggest).

If the conntrack timeout is not the ESTABLISHED one after the challenge 
ACK is seen, that's perfect.

Best regard,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
