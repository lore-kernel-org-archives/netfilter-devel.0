From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nft_compat: fix sparse warning
Date: Thu, 19 Feb 2015 01:02:18 +0100
Message-ID: <20150219000218.GA28820@salvia>
References: <20150212182218.4842.31064.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34454 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbbBRX64 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 18:58:56 -0500
Content-Disposition: inline
In-Reply-To: <20150212182218.4842.31064.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 12, 2015 at 07:23:11PM +0100, Arturo Borrero Gonzalez wrote:
> >> net/netfilter/nft_compat.c:140:37: sparse: incorrect type in assignment (different base types)
>    net/netfilter/nft_compat.c:140:37:    expected restricted __be16 [usertype] ethproto
>    net/netfilter/nft_compat.c:140:37:    got unsigned char [unsigned] [usertype] proto
> >> net/netfilter/nft_compat.c:351:37: sparse: incorrect type in assignment (different base types)
>    net/netfilter/nft_compat.c:351:37:    expected restricted __be16 [usertype] ethproto
>    net/netfilter/nft_compat.c:351:37:    got unsigned char [unsigned] [usertype] proto

Please, reword the title and resubmit. Basically, sparse has
discovered a real bug.

I'm telling this because we cannot pass patch to calm down sparse
warnings to the 'net' tree and I would like to make sure that people
understand that this is fixing a breakage in ebtables-compat, so it
should follow the fast path to mainstream.

Thanks.
