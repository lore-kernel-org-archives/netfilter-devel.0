From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/5] netfilter: ipset: fix interface comparision in
 hash-netiface sets
Date: Fri, 29 Jun 2012 20:24:23 +0200
Message-ID: <20120629182423.GD13074@breakpoint.cc>
References: <1340984255-738-2-git-send-email-pablo@netfilter.org>
 <AE90C24D6B3A694183C094C60CF0A2F6026B6F6E@saturn3.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40628 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754512Ab2F2SYa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:24:30 -0400
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6F6E@saturn3.aculab.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

David Laight <David.Laight@ACULAB.COM> wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > ifname_compare() assumes that skb->dev is zero-padded,
> > e.g 'eth1\0\0\0\0\0...'. This isn't always the case. e1000 driver does
> > 
> > strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
> > 
> > in e1000_probe(), so once device is registered dev->name memory
> contains
> > 'eth1\0:0:3\0\0\0' (or something like that), which makes eth1 compare
> fail.
> 
> strncpy() would normally zero-fill the destination buffer
> (at least the libc version does).
> 
> So something else must be wrong.

No. driver .probe() runs before the device name is filled in, and no
explict zeroing happens there.
