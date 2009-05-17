From: jamal <hadi@cyberus.ca>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull
	request]]
Date: Sun, 17 May 2009 18:09:27 -0400
Message-ID: <1242598167.3996.115.camel@dogo.mojatatu.com>
References: <4A0E9786.8060407@netfilter.org>
	 <1242566196.3996.23.camel@dogo.mojatatu.com>
	 <4A10235B.3070607@netfilter.org>
	 <alpine.LSU.2.00.0905171711230.6819@fbirervta.pbzchgretzou.qr>
	 <4A103751.9060501@netfilter.org>
	 <alpine.LSU.2.00.0905171822570.6819@fbirervta.pbzchgretzou.qr>
	 <1242579553.3996.81.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0905171907060.12523@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f180.google.com ([209.85.221.180]:39044 "EHLO
	mail-qy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZEQWKQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 18:10:16 -0400
Received: by qyk10 with SMTP id 10so741830qyk.33
        for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2009 15:10:11 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0905171907060.12523@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2009-05-17 at 19:11 +0200, Jan Engelhardt wrote:

> The hurdle with IPv6 is just like patches that would add a copy of a
> function with a slightly different signature or semantics: 
> it would be met with reluctance. 

I think v6 is met with reluctance because it is a _revolution_.
It is a slight exageration on my part to equate the API churning
challenge to be of the same magnitude as protocols deployed in the
internet, however, conceptually the pain for someone who has to deal
with API changes is similar.
Imagine a user re-learning to remember the v6 addressing semantics
(analogy would be a user of an API having to learn new semantics).
And then factor in people who have already invested a gazillion $ and
time in V4 applications, equipment and infrastructure (anology will be
some corp who has deployed applications using old API). 
NAT, OTOH, would be analogous to a patch on top of V4 which solves an
immediate problem - hence an evolution. NAT is so popular that even the
IETF has given up on trying to get the cat back into the bag.

What i am trying to say is: netfilter (hate to use marketing-speak) has
created an ecosystem; and with huge power comes huge responsibility;
every time ypu make small changes like APIs, you are providing guidance
to the distros about what you are no longer willing to support and
unintentionally screwing me (make me do more work).

> I already given up on submission of
> Xtables-addons modules to upstream for the same reason because there
> are so much "no no"s coming back. I don't get it.

It doesnt sound right to reject them if they dont kill backward compat.

cheers,
jamal

