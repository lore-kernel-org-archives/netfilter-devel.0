From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: validate hooks in NAT
 expressions
Date: Wed, 14 Jan 2015 18:28:30 +0100
Message-ID: <20150114172830.GA21037@salvia>
References: <1421254861-18698-1-git-send-email-pablo@netfilter.org>
 <20150114171730.GF5710@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com,
	linkerpro@mail.ru
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47078 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414AbbANRZj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:25:39 -0500
Content-Disposition: inline
In-Reply-To: <20150114171730.GF5710@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 14, 2015 at 05:17:31PM +0000, Patrick McHardy wrote:
> On 14.01, Pablo Neira Ayuso wrote:
> > The user can crash the kernel if it configures the NAT chain in the
> > wrong hook, so validate that the expression is used from the right
> > hook when loading the rule.
> > 
> > This patch introduces nft_chain_validate_hooks() which is based on
> > existing code in the bridge version of the reject expression.
> 
> But this will still allow use in non base chains that are called
> from incorrect chains, right?

The expression .validate callback should make sure that doesn't happen
once you attach the non-base chain is "attached" to some base chain
via jump/goto.
