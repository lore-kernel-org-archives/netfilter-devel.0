From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: xt_hashlimit: handle iptables-restore of hash
 with same name
Date: Thu, 24 Jul 2014 13:48:46 +0200
Message-ID: <20140724114846.GE18404@breakpoint.cc>
References: <1406004850-31336-1-git-send-email-johunt@akamai.com>
 <20140724084927.GB18404@breakpoint.cc>
 <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Josh Hunt <johunt@akamai.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Harald Welte <laforge@netfilter.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34564 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750771AbaGXLsx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:48:53 -0400
Content-Disposition: inline
In-Reply-To: <ffaf5ee3-2af6-4747-bdd1-481ed87e68aa@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 24. Juli 2014 09:49:27 GMT+01:00, Florian Westphal <fw@strlen.de> wrote:
> >Josh Hunt <johunt@akamai.com> wrote: 
> >>     Currently when we do do this the new parameters are not enforced.
> >
> >Note that:
> >
> >-A INPUT -m hashlimit --hashlimit-upto 10/sec --hashlimit-burst 10
> >--hashlimit-name test
> >-A INPUT -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 10
> >--hashlimit-name test
> >
> >doesn't work as expected either (rule #2 uses config options of #1).
> >
> >I think is behaviour is so unexpected that I would consider this a
> >bug...
> 
> True, but it's a bug that has existed forever and I've seen scripts that actually rely on this.

Too bad.  In that case it seems like we really cannot fix this 8-(
