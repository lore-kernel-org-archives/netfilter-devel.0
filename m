From: Ed W <lists@wildgooses.com>
Subject: Re: [RFC PATCH] netfilter: add connlabel conntrack extension
Date: Sat, 20 Oct 2012 14:15:29 +0100
Message-ID: <5082A3F1.6070204@wildgooses.com>
References: <1350577344-16321-1-git-send-email-fw@strlen.de> <20121018165104.GA15142@1984> <20121018203809.GA18674@breakpoint.cc> <20121019081959.GA11880@1984> <20121019085007.GC18674@breakpoint.cc> <20121019131533.GB30731@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:33878 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab2JTNPb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2012 09:15:31 -0400
In-Reply-To: <20121019131533.GB30731@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

>> Yes, thats something I also don't know yet.  My guess is that in most
>> cases it will be unused, or very low (< 32 labels in total).
> I was thinking on the layer-7 pre-classification from kernel-space via
> nfgrep.
>
> This connlabel (or something similar) can be very useful for it.
> In initial states we can match several layer 7 filters until we
> finally conclude which one it is. For example, many protocols are
> based on HTTP, so the enumerate would allow to set some type and set
> several protocols matching. Connmark is too generic for this and it's
> heavily used by others.
>
> I just think that having some clear use case for this is important.

Aha, perfect.  I was just about to ask a question about how to do 
something like this!

I'm updating the opendpi-netfilter patches to run against nDPI, which is 
the ntop fork of opendpi.  This seems to be a very decent attempt to do 
something like layer 7 heuristics and in particular does a rather clever 
labelling of https connections by inspecting the certs themselves (so we 
can block/allow facebook despite it being encrypted)
     https://github.com/ewildgoose/ndpi-netfilter

What I would very much desire is to be able to extent this to conntrack 
so I can easily get summary stats back through userspace conntrack.  So 
I would like to simply log the output of "conntrack -E" and group by 
some protocol column


However, I have a second use case that isn't covered by this:
- For use with a captive portal I need to calculate bandwidth used by 
the WAN connection
- Some WAN connections have an overhead because they are wrapped inside 
some outer protocol (ATM would be an example, eg where we transmit over 
an ADSL connection the billed bandwidth is higher than the ethernet 
bandwidth).  Or other connections may use PPP header compression, etc
- I desire to have conntrack userspace have visibility over the 
*charged* bandwidth so again I can very easily use the output as a 
fairly accurate billing mechanism
- Also I need to know which WAN connection the packets went out via 
(since billing will be different per WAN). This isn't computable from 
routing since we use policy routing. Also there is NAT on all outbound 
connections.

Given that this isn't satisfied by the proposed labelling system, how 
else might I implement this requirement please?  Suggestions appreciated?

Cheers

Ed W
