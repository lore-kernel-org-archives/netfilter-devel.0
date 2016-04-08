From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC nf-next 0/3] named expressions for nf_tables
Date: Fri, 8 Apr 2016 14:12:48 +0200
Message-ID: <20160408121248.GB6526@breakpoint.cc>
References: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58446 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757805AbcDHMMu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 08:12:50 -0400
Content-Disposition: inline
In-Reply-To: <1459961493-7494-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> * List existing named counters:
> 
>  # nft lists counters
>  table ip filter {
>         counter tcp-counter {
>                 packets 6086 bytes 6278052
>         }
>         counter udp-counter {
>                 packets 272 bytes 64690
>         }
>         counter icmp-counter {
>                 packets 10 bytes 840
>         }
>  }

So if we extend this scheme to all (stateful) expressions we'll have to
add 'nft list limits' (or whatever).

Do you think it makes sense to represent this in a more generic fashion?

nft list tables
nft list chains

Maybe add
nft list expressions

?

> The snippet below shows a simplistic configuration to account tcp, udp
> and icmp traffic through the named counter:
> 
> -o-
> table ip filter {
>         counter tcp-counter {
>                 packets 6086 bytes 6278052
>         }

So this could f.e. look like

expression tcp-counter {
	counter packets 6086 bytes 6278052
}

(and tcp-counter is just some identifier).

> support named limits. I have another (imcomplete) patch that allows to
> update the named expressions parameters, this can be useful to
> dynamically update the ratelimiting policies, the command line should
> look like:
> 
>  # nft update limit name user01234 rate 250 mbytes/day

nft update expression user01234 rate 250 mbytes/day

(or perhaps

nft update expression user01234 limit rate 250 mbytes/day

not sure if we want to allow replacing the (internal) expression
stored in a named expression with a different one....)
