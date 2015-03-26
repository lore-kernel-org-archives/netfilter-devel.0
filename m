From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/4] netfilter: nf_tables: set transactions
Date: Thu, 26 Mar 2015 11:14:36 +0000
Message-ID: <20150326111436.GI3526@acer.localdomain>
References: <1427292530-28529-1-git-send-email-kaber@trash.net>
 <20150326110949.GB3734@salvia>
 <20150326110700.GH3526@acer.localdomain>
 <20150326111530.GA3769@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57410 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbbCZLOk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 07:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20150326111530.GA3769@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.03, Pablo Neira Ayuso wrote:
> On Thu, Mar 26, 2015 at 11:07:01AM +0000, Patrick McHardy wrote:
> > On 26.03, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 25, 2015 at 02:08:46PM +0000, Patrick McHardy wrote:
> > > > These patches add transaction support to set elements. It pretty much
> > > > resembles the existing transaction support, the changelogs explain it
> > > > in more detail.
> > > 
> > > Thanks a lot for finishing this support.
> > > 
> > > > As a by-product the patches get rid of the RCU grace period for every
> > > > nft_hash element that is destroyed, we now have only the single global
> > > > transaction grace perdiod independantly of what we destroy.
> > > 
> > > Great work.
> > > 
> > > Applied, thanks Patrick!
> > 
> > Thanks! Next batch will follow shortly :)
> 
> I'm going to send a pull request to try to keep the batch relatively
> small, so the next batch will just sit for a while on the list, OK?

Sure, no problem.
