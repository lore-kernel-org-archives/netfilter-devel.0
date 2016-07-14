From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 nf] netfilter: x_tables: speed up jump target
 validation
Date: Thu, 14 Jul 2016 23:28:57 +0200
Message-ID: <20160714212857.GA6010@breakpoint.cc>
References: <1468511486-17283-1-git-send-email-fw@strlen.de>
 <20160714180752.GA1471@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46296 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229AbcGNV3F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 17:29:05 -0400
Content-Disposition: inline
In-Reply-To: <20160714180752.GA1471@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jul 14, 2016 at 05:51:26PM +0200, Florian Westphal wrote:
> > The dummy ruleset I used to test the original validation change was broken,
> > most rules were unreachable and were not tested by mark_source_chains().
> >
> > In some cases rulesets that used to load in a few seconds now require
> > several minutes.
> 
> Thanks for fixing this so fast. I was a bit surprised this O(n!)
> validation was only taking 11% more time when you first posted this
> patchset.

Indeed ...

> > sample ruleset that shows the behaviour:
> > 
> > echo "*filter"
> > for i in $(seq 0 100000);do
> >         printf ":chain_%06x - [0:0]\n" $i
> > done
> > for i in $(seq 0 100000);do
> >    printf -- "-A INPUT -j chain_%06x\n" $i
> >    printf -- "-A INPUT -j chain_%06x\n" $i
> >    printf -- "-A INPUT -j chain_%06x\n" $i
> > done
> > echo COMMIT
> 
> Not exactly related to this patch.
> 
> As I said in the workshop, I would really to love to see more tests in
> our trees.
> 
> Is there any chance you can get reuse that tests/shell/ directory that
> Arturo made for nftables and place this in one of those scripts? You
> can inagurate it with this scripts, and others that you used to fix
> the lack of sanity checks (those actually would require some little C
> code though).

Yes, I will see if I can do this.
