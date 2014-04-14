From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/2] netfilter: nf_tables: set selection
Date: Mon, 14 Apr 2014 10:52:36 +0200
Message-ID: <20140414085235.GA6181@macbook.localnet>
References: <1396001988-32338-1-git-send-email-kaber@trash.net>
 <20140331115333.GA3623@localhost>
 <20140414055605.GA541@macbook.localnet>
 <20140414082800.GA3882@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59289 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaDNIwk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:52:40 -0400
Content-Disposition: inline
In-Reply-To: <20140414082800.GA3882@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 14, 2014 at 10:28:00AM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 14, 2014 at 07:56:07AM +0200, Patrick McHardy wrote:
> > On Mon, Mar 31, 2014 at 01:53:33PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Mar 28, 2014 at 10:19:46AM +0000, Patrick McHardy wrote:
> > > > These patches implement the basic set selection mechanism based on data
> > > > characteristics provided by userspace. So far we only need to know the
> > > > maximum number of elements.
> > > > 
> > > > Instead of trying to anticipate the information future set types will
> > > > need, the plan is to add more as we require it under the assumption
> > > > that we will converge to a state where a new set type already has
> > > > all information required available. The expectation is that most set
> > > > types will require the same information for estimation since they
> > > > most likely will be some type of tree or trie.
> > > 
> > > I'm going to include this in the next batch for net-next before merge
> > > window closes, which should happen soon. Thanks a lot Patrick.
> > 
> > I can't find neither this series, nor the patch
> > "netfilter: nf_tables: handle more than 8 * PAGE_SIZE set name allocations"
> > anywhere in your trees or upstream.
> 
> That one I missed, I'll enqueue it to the nftables tree.
> 
> > Am I missing something?
> 
> http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/log/

I see. I thought that tree was retired and things moved to nf/nf-next?
