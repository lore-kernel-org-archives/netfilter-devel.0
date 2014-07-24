From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash
 with same name
Date: Thu, 24 Jul 2014 10:49:27 +0200
Message-ID: <20140724084927.GB18404@breakpoint.cc>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Harald Welte <laforge@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33990 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaGXItc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:49:32 -0400
Content-Disposition: inline
In-Reply-To: <1406004850-31336-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Josh Hunt <johunt@akamai.com> wrote:
> Below is a first pass attempt at fixing a problem we've come across when
> trying to do an iptables-restore where the hashlimit name stays the same, but
> one of the hashlimit parameters changes but does not take affect.
> 
> For ex, if you have an existing hashlimit rule, do an iptables-save, change the
> rate for that rule, and then do an iptables-restore the new rate will not be
> enforced.
> 
> This appears to be due to a problem where hashlimit only checks for existing
> hashes by name and family and does not consider any of the other config
> parameters.
> 
> I've attempted to fix this by having it check for all hashlimit config params,
> this way it doesn't accidentally match just on name. This brought up an issue
> of having to make hashlimit aware of how many references there are to its
> proc entry.
> 
> I'm not submitting this for inclusion yet, but for feedback. Mainly on the approach
> and if there's possibly a better way of resolving this problem. My handling of
> the proc "problem" is pretty messy right now and possibly incomplete, but the
> patch below allows the case I described above to pass now. I hope to clean up
> the proc handling in a v2.
> 
> Any feedback is greatly appreciated.

[ ignoring proc issue you pointed out ]

>     from:
>     -A INPUT -s 10.18.40.44/32 -i eth1 -p tcp -m hashlimit --hashlimit-upto 10/sec --hashlimit-burst 10 --hashlimit-name test -j ACCEPT
> 
>     to:
>     -A INPUT -s 10.18.40.44/32 -i eth1 -p tcp -m hashlimit --hashlimit-upto 1000/sec --hashlimit-burst 10 --hashlimit-name test -j ACCEPT
> 
>     Currently when we do do this the new parameters are not enforced.

Note that:

-A INPUT -m hashlimit --hashlimit-upto 10/sec --hashlimit-burst 10 --hashlimit-name test
-A INPUT -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 10 --hashlimit-name test

doesn't work as expected either (rule #2 uses config options of #1).

I think is behaviour is so unexpected that I would consider this a bug...

Wrt. to the patch, aside from proc issue I only see style/indent nits, f.e.

> +	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
> +		if (!strcmp(name, hinfo->name) &&
> +			family == hinfo->family) {

'family' should align with the 'if (', not the body.

Other than that, it looks good to me.
