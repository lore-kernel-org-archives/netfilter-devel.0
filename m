From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH v2] iptables/nft-shared.c: kill add_*() invflags
 parameter
Date: Wed, 12 Nov 2014 13:18:52 +0100
Message-ID: <20141112121852.GA1397@salvia>
References: <20141112115949.3179.82085.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33493 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaKLMRL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:17:11 -0500
Content-Disposition: inline
In-Reply-To: <20141112115949.3179.82085.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 12, 2014 at 01:00:12PM +0100, Arturo Borrero Gonzalez wrote:
> Let's kill the invflags parameter and use directly NFT_CMP_[N]EQ.
> The caller must calculate which kind of cmp operation requires.
> 
> BTW, the this patch solves absence of inversion in some arptables-compat
> builtin matches. Thus, translating arptables inv flags is no longer needed.

Applied, thanks Arturo.
