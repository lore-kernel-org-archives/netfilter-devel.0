From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v3] utils: fix arp family number
Date: Tue, 21 Oct 2014 09:59:27 +0200
Message-ID: <20141021075927.GA3610@salvia>
References: <20141020115049.27980.35459.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47905 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbaJUH6A (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:58:00 -0400
Content-Disposition: inline
In-Reply-To: <20141020115049.27980.35459.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 20, 2014 at 01:52:18PM +0200, Arturo Borrero Gonzalez wrote:
> NFPROTO_ARP = 3 in kernel space.
> 
> We need the same value here in userspace in order to correctly communicate
> with the kernel.
> 
> The failure solved by this patch made that {XML|JSON}-parsed tables of ARP
> family unable to be directly injected into kernel.
> 
> To prevent future errors, this patch changes raw and AF_* values by the mathing
> NFPROTO_* couterpart as seen in linux/netfilter.h in both functions:
>  * nft_family2str()
>  * nft_str2family()

Applied, thanks.

BTW, it would be good to see a similar refactor in nft_verdict2str().
