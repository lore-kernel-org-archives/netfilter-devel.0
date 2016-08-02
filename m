From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -stable 4.1.y] netfilter: x_tables: speed up jump target
 validation
Date: Tue, 2 Aug 2016 21:51:03 +0200
Message-ID: <20160802195103.GA31209@breakpoint.cc>
References: <1470076704-13325-1-git-send-email-fw@strlen.de>
 <1470076704-13325-5-git-send-email-fw@strlen.de>
 <124e6257-749b-6561-b706-15e02fb356b4@verizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>
To: "Levin, Alexander" <alexander.levin@verizon.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53850 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbcHBTvk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Aug 2016 15:51:40 -0400
Content-Disposition: inline
In-Reply-To: <124e6257-749b-6561-b706-15e02fb356b4@verizon.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Levin, Alexander <alexander.levin@verizon.com> wrote:
> On 08/01/2016 02:38 PM, Florian Westphal wrote:
> > [ Upstream commit f4dc77713f8016d2e8a3295e1c9c53a21f296def ]
> > 
> > The dummy ruleset I used to test the original validation change was broken,
> > most rules were unreachable and were not tested by mark_source_chains().
> > 
> > In some cases rulesets that used to load in a few seconds now require
> > several minutes.
> > 
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
> > 
> > [ pipe result into iptables-restore ]
> > 
> > This ruleset will be about 74mbyte in size, with ~500k searches
> > though all 500k[1] rule entries. iptables-restore will take forever
> > (gave up after 10 minutes)
> > 
> > Instead of always searching the entire blob for a match, fill an
> > array with the start offsets of every single ipt_entry struct,
> > then do a binary search to check if the jump target is present or not.
> > 
> > After this change ruleset restore times get again close to what one
> > gets when reverting 36472341017529e (~3 seconds on my workstation).
> > 
> > [1] every user-defined rule gets an implicit RETURN, so we get
> > 300k jumps + 100k userchains + 100k returns -> 500k rule entries
> > 
> > Fixes: 36472341017529e ("netfilter: x_tables: validate targets of jumps")
> > Reported-by: Jeff Wu <wujiafu@gmail.com>
> > Tested-by: Jeff Wu <wujiafu@gmail.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Hi Florian,
> 
> This patch doesn't seem to apply on 4.1, does it have any dependencies
> that don't currently exist in the tree?

I tried to apply it on top of c3ed55b836cff71 (4.1.29) and
git-am worked without issues.

What is the problem?
