From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables kernel 1/3] netfilter: nft_log: group is u16,
 snaplen u32
Date: Sat, 14 Sep 2013 21:10:02 +0200
Message-ID: <20130914191002.GA13409@localhost>
References: <1379083488-20752-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730Ab3INTKI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:10:08 -0400
Content-Disposition: inline
In-Reply-To: <1379083488-20752-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 13, 2013 at 04:44:46PM +0200, Florian Westphal wrote:
> 0edecbe17ae (netfilter: nft_log: group and qthreshold are 2^16)
> made the correct changes except in the nla_policy where
> it changed snaplen instead of group attibute.

Applied, thanks Florian.
