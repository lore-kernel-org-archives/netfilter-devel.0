From: Florian Westphal <fw@strlen.de>
Subject: Re: ebtables not working correctly with
 1086bbe97a074844188c6c988fa0b1a98c3ccbb9
Date: Tue, 26 May 2015 10:14:14 +0200
Message-ID: <20150526081414.GA7817@breakpoint.cc>
References: <5563D5E5.70502@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, davej@codemonkey.org.uk,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42561 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbbEZIOR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2015 04:14:17 -0400
Content-Disposition: inline
In-Reply-To: <5563D5E5.70502@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bernhard Thaler <bernhard.thaler@wvnet.at> wrote:
> setting rules with ebtables does not work for me any more with
> 1086bbe97a074844188c6c988fa0b1a98c3ccbb9 / "netfilter: ensure number of
> counters is >0 in do_replace()" in place.
> 
> There is an error message and no rules set in the end.
> 
> e.g.
> 
> root@kali:~# ebtables -t nat -A POSTROUTING --src 12:34:56:78:9a:bc -j DROP
> Unable to update the kernel. Two possible causes:
> 1. Multiple ebtables programs were executing simultaneously. The ebtables
>    userspace tool doesn't by default support multiple ebtables programs
> running

[..]

> With 1086bbe97a074844188c6c988fa0b1a98c3ccbb9 reverted everything works
> fine again.

Yes, seems we don't want the ebtables part of that commit.
The vmalloc() calls are conditional on repl->num_counters in ebtables,
and no counters are fetched on zero.

Would you mind submitting a partial revert patch?

Thanks for debugging this!
