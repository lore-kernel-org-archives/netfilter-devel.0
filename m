From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] nft: Add support for inverted bitwise value list
Date: Wed, 22 Jun 2016 18:56:27 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1606221847340.7827@nerf40.vanv.qr>
References: <20160622154945.GA12610@sonyv> <20160622161407.GB10213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Laura Garcia Liebana <nevola@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:40186 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbcFVQ4a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 12:56:30 -0400
In-Reply-To: <20160622161407.GB10213@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2016-06-22 18:14, Florian Westphal wrote:
>Laura Garcia Liebana <nevola@gmail.com> wrote:
>> Add support for inverted state and status bitwise value list required in the
>> ct match.
>> 
>> Before this patch, nft didn't support the rule:
>> 
>> $ nft add rule ip filter INPUT ct state != new,related counter accept
>> <cmdline>:1:41-41: Error: syntax error, unexpected comma, expecting end of file or newline or semicolon
>> add rule ip filter INPUT ct state != new,related counter accept
>                                         ^
>I don't like nft foo,bar syntax since
>
>'state new,related' looks a lot like 'state { new, related }' but its not the same...

What is the difference? More specifically, why is there a difference?
That appears to be a bad pitfall for users. (And as such, choosing
different symbols like the pipe symbol does not cure the issue of 
confusion.)
