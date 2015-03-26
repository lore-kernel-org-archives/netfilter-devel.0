From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] netfilter: nf_tables: set transactions
Date: Thu, 26 Mar 2015 12:15:30 +0100
Message-ID: <20150326111530.GA3769@salvia>
References: <1427292530-28529-1-git-send-email-kaber@trash.net>
 <20150326110949.GB3734@salvia>
 <20150326110700.GH3526@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49488 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbbCZLLf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 07:11:35 -0400
Content-Disposition: inline
In-Reply-To: <20150326110700.GH3526@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 26, 2015 at 11:07:01AM +0000, Patrick McHardy wrote:
> On 26.03, Pablo Neira Ayuso wrote:
> > On Wed, Mar 25, 2015 at 02:08:46PM +0000, Patrick McHardy wrote:
> > > These patches add transaction support to set elements. It pretty much
> > > resembles the existing transaction support, the changelogs explain it
> > > in more detail.
> > 
> > Thanks a lot for finishing this support.
> > 
> > > As a by-product the patches get rid of the RCU grace period for every
> > > nft_hash element that is destroyed, we now have only the single global
> > > transaction grace perdiod independantly of what we destroy.
> > 
> > Great work.
> > 
> > Applied, thanks Patrick!
> 
> Thanks! Next batch will follow shortly :)

I'm going to send a pull request to try to keep the batch relatively
small, so the next batch will just sit for a while on the list, OK?

Thanks!
