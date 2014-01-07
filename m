From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nftables: fix warning in nft_reject
Date: Wed, 8 Jan 2014 00:04:52 +0100
Message-ID: <20140107230452.GA16049@localhost>
References: <52cb0425.bwwhbZOarZlZjGHg%fengguang.wu@intel.com>
 <1389043154-28415-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33330 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaAGXE6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:04:58 -0500
Content-Disposition: inline
In-Reply-To: <1389043154-28415-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 10:19:14PM +0100, Eric Leblond wrote:
> The 0-day testing from Fenguang Wu issued the following warning:
>  net/netfilter/nft_reject.c: In function 'nft_reject_eval':
>  >> net/netfilter/nft_reject.c:37:14: warning: unused variable 'net' [-Wunused-variable]
>       struct net *net = dev_net((pkt->in != NULL) ? pkt->in : pkt->out);
> 
> This is due to the fact that if IPv6 is not build the variable is
> indeed unused.

Thanks Eric.

I sent this patch a bit earlier to address this:

http://patchwork.ozlabs.org/patch/307435/
