From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] scanner: add aliases to symbols for easier
 interaction with most shells
Date: Wed, 15 Jan 2014 10:30:15 +0100
Message-ID: <20140115093015.GA4583@localhost>
References: <1389711314-9008-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35320 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaAOJaa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:30:30 -0500
Content-Disposition: inline
In-Reply-To: <1389711314-9008-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 03:55:14PM +0100, Pablo Neira Ayuso wrote:
> These symbols need to be escaped in bash and if you use them without
> escaping then, it can lead to confusion. This patch adds nominal
> aliases, eg.
> 
>  nft add rule filter output meta mark and 0x3 eq 0x1
> 
> as an alternative to:
> 
>  nft add rule filter output meta mark \& 0x3 == 0x1

Just pushed this patch.
