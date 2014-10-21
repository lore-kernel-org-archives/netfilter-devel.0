From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3] evaluate: fix a crash if we specify ether type or
 meta nfproto in reject
Date: Tue, 21 Oct 2014 10:12:25 +0200
Message-ID: <20141021081225.GA3628@salvia>
References: <1413811929-21955-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53608 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbaJUILE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:11:04 -0400
Content-Disposition: inline
In-Reply-To: <1413811929-21955-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 20, 2014 at 03:32:09PM +0200, Alvaro Neira Ayuso wrote:
> If we use this rule:
> 
> nft add rule bridge filter input \
> 	ether type ip reject with icmp type host-unreachable
> 
> or that:
> 
> nft add rule inet filter input \
> 	meta nfproto ipv4 reject with icmp type host-unreachable
> 
> we have a segfault because we add a network dependency when we already have
> network context.

Applied, thanks.
