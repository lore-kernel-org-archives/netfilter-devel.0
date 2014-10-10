From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: bad timeout assignments
Date: Fri, 10 Oct 2014 23:19:15 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1410102317060.23228@blackhole.kfki.hu>
References: <20141010085621.GA9211@pc11.op.pod.cz> <alpine.DEB.2.10.1410101256230.18124@blackhole.kfki.hu> <20141010111404.GA15011@pc11.op.pod.cz> <alpine.DEB.2.10.1410101856580.21928@blackhole.kfki.hu>
 <CAJ26g5RuSpQBzZ+L8LCx7daSorSiY0uqGPb044HLzmbrV=Rhnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Vitezslav Samel <vitezslav@samel.cz>
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:52203 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbaJJVSq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:18:46 -0400
In-Reply-To: <CAJ26g5RuSpQBzZ+L8LCx7daSorSiY0uqGPb044HLzmbrV=Rhnw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 10 Oct 2014, Patrick Schaaf wrote:

> > You are right, I'll look into it. Part of the problem comes from a bad 
> > protocol decision, because ipset passes timeout values as an u32 value 
> > between userspace and kernel.
>
> Not sure whether it makes sense, but maybe an intermediate "fix" would 
> be to recognize, in userlevel, the too-large values, and properly clamp 
> them to the highest value representable by the protocol. Better than 
> wraparound that causes unexpectedly low timeouts, I think.

I'm thinking on just introducing a new attribute to carry u64 sized 
timeout values.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
