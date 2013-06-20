From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH lnfct-ct 1/2] conntrack: snprintf: add labels in hex
 representation by default
Date: Thu, 20 Jun 2013 13:34:19 +0200
Message-ID: <20130620113419.GA7070@localhost>
References: <1371588862-3407-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38915 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965378Ab3FTLe3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:34:29 -0400
Content-Disposition: inline
In-Reply-To: <1371588862-3407-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 18, 2013 at 10:54:21PM +0200, Florian Westphal wrote:
> udp      17 24 [..] dport=62277 mark=0 use=1 labels=0x28000000000000008
> or
> [..]<mark>0</mark><labels>0x28000000000000008</labels> [..] </meta></flow>
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  I'm interested if there are any objections on putting
>  this in by default, one alternative would be to toss this and only
>  print label info with special formating request (see next patch,
>  which adds NFCT_OF_ specifier (which will then print the resovled names
>  instead of bitmask).

I'm not sure about the utility of this without the translation to
strings.
