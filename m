From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] Fix nft-table-upd example
Date: Mon, 12 Oct 2015 22:15:51 +0200
Message-ID: <20151012201551.GA16300@salvia>
References: <1444425858-24568-1-git-send-email-subramanian.vijay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Vijay Subramanian <subramanian.vijay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58505 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbbJLUIt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 16:08:49 -0400
Content-Disposition: inline
In-Reply-To: <1444425858-24568-1-git-send-email-subramanian.vijay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 09, 2015 at 02:24:18PM -0700, Vijay Subramanian wrote:
> examples/nft-table-upd does not work currently since NFT_MSG_NEWTABLE
> needs to use batching mode of netlink message delivery.
> 
> This patch adds batching to nft-table-upd example.
> 
> While here, also add support for netdev family.

Applied.
