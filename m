From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] nft: Add support for inverted bitwise value list
Date: Wed, 22 Jun 2016 19:13:08 +0200
Message-ID: <20160622171308.GE10213@breakpoint.cc>
References: <20160622154945.GA12610@sonyv>
 <20160622161407.GB10213@breakpoint.cc>
 <alpine.LSU.2.20.1606221847340.7827@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34240 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbcFVRNN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:13:13 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1606221847340.7827@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> 
> On Wednesday 2016-06-22 18:14, Florian Westphal wrote:
> >Laura Garcia Liebana <nevola@gmail.com> wrote:
> >> Add support for inverted state and status bitwise value list required in the
> >> ct match.
> >> 
> >> Before this patch, nft didn't support the rule:
> >> 
> >> $ nft add rule ip filter INPUT ct state != new,related counter accept
> >> <cmdline>:1:41-41: Error: syntax error, unexpected comma, expecting end of file or newline or semicolon
> >> add rule ip filter INPUT ct state != new,related counter accept
> >                                         ^
> >I don't like nft foo,bar syntax since
> >
> >'state new,related' looks a lot like 'state { new, related }' but its not the same...
> 
> What is the difference? More specifically, why is there a difference?

state { new, related  } asks nft to perform a lookup in an anonymous set with the
key values new and related and check if there is a matching key.

> That appears to be a bad pitfall for users. (And as such, choosing
> different symbols like the pipe symbol does not cure the issue of 
> confusion.)

The | already works, and in fact 'state new|related' is displayed as
'state new, related'.

state { new | related  } would ask nft to perform a lookup in anonymous
set, but that set would have just one value, namely the result of '4|8': 12.
