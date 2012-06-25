From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: hash:net,iface: fix interface
 comparision
Date: Mon, 25 Jun 2012 15:11:09 +0200
Message-ID: <20120625131109.GA12597@1984>
References: <1339963006-15296-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55860 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756744Ab2FYNLQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:11:16 -0400
Content-Disposition: inline
In-Reply-To: <1339963006-15296-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 17, 2012 at 09:56:46PM +0200, Florian Westphal wrote:
> ifname_compare() assumes that skb->dev is zero-padded,
> e.g 'eth1\0\0\0\0\0...'. This isn't always the case. e1000 driver does
> 
> strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
> 
> in e1000_probe(), so once device is registered dev->name memory contains
> 'eth1\0:0:3\0\0\0' (or something like that), which makes eth1 compare
> fail.
> 
> Use plain strcmp() instead.

Applied, thanks Florian.
