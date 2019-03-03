Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA69C43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 20:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F290E20835
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 20:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="Dm86QOT2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfCCUo6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 15:44:58 -0500
Received: from smtp-out.kfki.hu ([148.6.0.45]:42237 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbfCCUo6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 15:44:58 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 6AB6067400C6;
        Sun,  3 Mar 2019 21:44:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1551645894; x=1553460295; bh=v5+J/uj0P1
        phwldcZaOWrX1zZyGQbfz+UcmupBpxERA=; b=Dm86QOT2mRPonyXZqEOyxZYKWo
        C9SjhQsFh/EydZ5w+REspldQX+u0IjkMg7bQU+0ekniZFg7SGI0HORUn9vnfkFVE
        EJrI/T6IXMMHKkMiBAlNiX2sI+z63xg9KTnn13MAYc0wiTBpVB7M+qcYeVrGfIvs
        ISLI+u1bBmPQ5jy0Y=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Sun,  3 Mar 2019 21:44:54 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 58D8767400C1;
        Sun,  3 Mar 2019 21:44:54 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 2A8BA21E44; Sun,  3 Mar 2019 21:44:54 +0100 (CET)
Date:   Sun, 3 Mar 2019 21:44:54 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Florian Westphal <fw@strlen.de>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: tcp: only close if RST
 matches exact sequence
In-Reply-To: <20190303195934.r35rgo24dobmpz3y@breakpoint.cc>
Message-ID: <alpine.DEB.2.20.1903032139510.19344@blackhole.kfki.hu>
References: <20190221160931.10775-1-fw@strlen.de> <20190301132436.elh5rxs6vxwnykd4@salvia> <alpine.DEB.2.20.1903031715240.18380@blackhole.kfki.hu> <20190303191629.jl6hrv4yo6ctqbt4@breakpoint.cc> <alpine.DEB.2.20.1903032035350.19344@blackhole.kfki.hu>
 <20190303195934.r35rgo24dobmpz3y@breakpoint.cc>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 3 Mar 2019, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > > The ESTABLISHED timeout is 5 minutes because of missing ACKs 
> > > (outstanding data) in this case though (the RST has "wrong" sequence 
> > > number, so the conntrack is flagged accordingly until something acks the 
> > > data).
> > 
> > Sorry, but I don't see where is the outstanding data. Up to the RST and 
> > the challenge ACK there's no missing ACK. The RST hasn't got wrong seq 
> > because it's in the window. The RST flag is not counted. What do I miss?
> 
> There is no outstanding data, but conntrack thinks there is.
> 
> If we have this:
> seq 100 ack x len 100
> seq 200 rst x len 0
> 
> Then rst is accepted immediately and we move to CLOSE.
> 
> When we get this:
> seq 100 ack x len 100
> seq 210 rst x len 0
> 
> Then from conntrack point of view, we're 10 bytes "short" because td_end
> is 200, and new sequence is 210.  So we hit this:
>   if (after(end, sender->td_end)) {
>     sender->td_end = end;
>     sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
> 							                     }
> in tcp_in_window().

I see, thanks indeed! That explains perfectly.

I did not think about the packet before the RST one. :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
