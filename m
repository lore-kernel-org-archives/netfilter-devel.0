From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: Avoid duplicate call to nft_data_uninit() for
 same key
Date: Fri, 1 Aug 2014 18:14:06 +0200
Message-ID: <20140801161406.GB4679@salvia>
References: <b7a5a0e246bbe94de1f14594586e1ce75dc311bb.1406906631.git.tgraf@suug.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43998 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaHAQOA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:14:00 -0400
Content-Disposition: inline
In-Reply-To: <b7a5a0e246bbe94de1f14594586e1ce75dc311bb.1406906631.git.tgraf@suug.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 01, 2014 at 05:25:38PM +0200, Thomas Graf wrote:
> nft_del_setelem() currently calls nft_data_uninit() twice on the same
> key. Once to release the key which is guaranteed to be NFT_DATA_VALUE
> and a second time in the error path to which it falls through.
> 
> The second call has been harmless so far though because the type
> passed is always NFT_DATA_VALUE which is currently a no-op.

Applied, thanks Thomas.

BTW, this bug seems to be there since the very beginning:
http://lxr.free-electrons.com/source/net/netfilter/nf_tables_api.c?v=3.13#L2735
