From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nft_compat: don't truncate ethernet
 protocol type to u8
Date: Tue, 24 Feb 2015 19:51:13 +0100
Message-ID: <20150224185113.GA32613@salvia>
References: <20150221183014.26341.83261.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44329 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbbBXSrm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:47:42 -0500
Content-Disposition: inline
In-Reply-To: <20150221183014.26341.83261.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 21, 2015 at 07:30:55PM +0100, Arturo Borrero Gonzalez wrote:
> Use u16 for protocol and then cast it to __be16
> 
> >> net/netfilter/nft_compat.c:140:37: sparse: incorrect type in assignment (different base types)
>    net/netfilter/nft_compat.c:140:37:    expected restricted __be16 [usertype] ethproto
>    net/netfilter/nft_compat.c:140:37:    got unsigned char [unsigned] [usertype] proto
> >> net/netfilter/nft_compat.c:351:37: sparse: incorrect type in assignment (different base types)
>    net/netfilter/nft_compat.c:351:37:    expected restricted __be16 [usertype] ethproto
>    net/netfilter/nft_compat.c:351:37:    got unsigned char [unsigned] [usertype] proto

Applied, thanks Arturo.
