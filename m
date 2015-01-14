From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf] netfilter: nf_tables: validate hooks in NAT
 expressions
Date: Wed, 14 Jan 2015 17:59:15 +0000
Message-ID: <20150114175915.GI5710@acer.localdomain>
References: <1421254861-18698-1-git-send-email-pablo@netfilter.org>
 <20150114171730.GF5710@acer.localdomain>
 <20150114172830.GA21037@salvia>
 <20150114174459.GH5710@acer.localdomain>
 <20150114175027.GA21424@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com,
	linkerpro@mail.ru
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59607 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbANR7V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:59:21 -0500
Content-Disposition: inline
In-Reply-To: <20150114175027.GA21424@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.01, Pablo Neira Ayuso wrote:
> On Wed, Jan 14, 2015 at 05:45:00PM +0000, Patrick McHardy wrote:
> > On 14.01, Pablo Neira Ayuso wrote:
> > > On Wed, Jan 14, 2015 at 05:17:31PM +0000, Patrick McHardy wrote:
> > > > On 14.01, Pablo Neira Ayuso wrote:
> > > > > The user can crash the kernel if it configures the NAT chain in the
> > > > > wrong hook, so validate that the expression is used from the right
> > > > > hook when loading the rule.
> > > > > 
> > > > > This patch introduces nft_chain_validate_hooks() which is based on
> > > > > existing code in the bridge version of the reject expression.
> > > > 
> > > > But this will still allow use in non base chains that are called
> > > > from incorrect chains, right?
> > > 
> > > The expression .validate callback should make sure that doesn't happen
> > > once you attach the non-base chain is "attached" to some base chain
> > > via jump/goto.
> > 
> > How so? The nf_nat_validate_dependency() function simply returns 0
> > for non base chains.
> 
> The validation is also called from nf_tables_check_loops(), using the
> base chain at which the non-base chain has been attached to.

Right, I missed that. Thanks!
