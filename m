From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH v2] src: fix return code
Date: Thu, 17 Oct 2013 11:09:53 +0200
Message-ID: <20131017090953.GA9816@localhost>
References: <20131011110235.2912.77468.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39545 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab3JQJJ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 05:09:58 -0400
Content-Disposition: inline
In-Reply-To: <20131011110235.2912.77468.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 11, 2013 at 01:03:08PM +0200, Arturo Borrero Gonzalez wrote:
> Exit with NFT_EXIT_FAILURE if something went wrong in the netlink zone.
> 
> Before this patch:
> 
> # nft list chain filter asd ; echo $?
> internal:0:0-0: Error: Could not find chain `asd' in table `filter': [...]
> 
> 0
> 
> After this patch:
> 
> # nft list chain filter asd ; echo $?
> internal:0:0-0: Error: Could not find chain `asd' in table `filter': [...]
> 
> 1

Applied, thanks.
