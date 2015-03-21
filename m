From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_compat: set IP6T_F_PROTO flag if
 protocol is set
Date: Sat, 21 Mar 2015 20:14:46 +0100
Message-ID: <20150321191446.GA8344@salvia>
References: <1426963018-6838-1-git-send-email-pablo@netfilter.org>
 <20150321184509.GB16593@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57598 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbbCUTKx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 15:10:53 -0400
Content-Disposition: inline
In-Reply-To: <20150321184509.GB16593@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 21, 2015 at 06:45:09PM +0000, Patrick McHardy wrote:
> On 21.03, Pablo Neira Ayuso wrote:
> > ip6tables extensions check for this flag to restrict match/target to a
> > given protocol. Without this flag set, SYNPROXY6 returns an error.
> 
> That looks like the correct solution to me, thanks!
>
> I guess we should also fix all the ip6_tables extensions that think
> they're matching on the L4 protocol but are actually not enforcing
> this.

I'll send a follow up patch to fix this. Thanks for reviewing!
