From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink: remove redundant variable nskb
Date: Mon, 5 Jan 2015 12:34:29 +0100
Message-ID: <20150105113429.GA15129@salvia>
References: <548810B7.5080901@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57469 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627AbbAELbt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:31:49 -0500
Content-Disposition: inline
In-Reply-To: <548810B7.5080901@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 10, 2014 at 05:21:59PM +0800, Duan Jiong wrote:
> 
> Actually after netlink_skb_clone() is called, the nskb and
> skb will point to the same thing, but they are used just like
> they are different, sometimes this is confusing, so i think
> there is no necessary to keep nskb anymore.

Applied, thanks.
