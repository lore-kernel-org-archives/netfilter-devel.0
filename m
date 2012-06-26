From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: hash:net,iface: fix interface
 comparision
Date: Tue, 26 Jun 2012 15:35:01 +0200
Message-ID: <20120626133501.GA8050@1984>
References: <1339963006-15296-1-git-send-email-fw@strlen.de>
 <20120625131109.GA12597@1984>
 <alpine.DEB.2.00.1206260904520.8075@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48923 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab2FZNfL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:35:11 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1206260904520.8075@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 26, 2012 at 09:08:31AM +0200, Jozsef Kadlecsik wrote:
> On Mon, 25 Jun 2012, Pablo Neira Ayuso wrote:
> 
> > On Sun, Jun 17, 2012 at 09:56:46PM +0200, Florian Westphal wrote:
> > > ifname_compare() assumes that skb->dev is zero-padded,
> > > e.g 'eth1\0\0\0\0\0...'. This isn't always the case. e1000 driver does
> > > 
> > > strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
> > > 
> > > in e1000_probe(), so once device is registered dev->name memory contains
> > > 'eth1\0:0:3\0\0\0' (or something like that), which makes eth1 compare
> > > fail.
> > > 
> > > Use plain strcmp() instead.
> > 
> > Applied, thanks Florian.
> 
> Thanks, Pablo! I had commited the patch in my ipset git tree, just haven't 
> time yet to send/ack to you.

No problem. Please, rebase your tree to remove it:

git rebase -i COMMIT_YOU_WANT_TO_REMOVE^
# then, write "e" in the patch you want to remove on the list that it shows
git reset HEAD^
git reset --hard
git rebase --continue

Not sure if there's a smarter way to do it. This is how I make it
though.

Note that we're on -rc4, so please send me important fixes that you
want me to pass to David first, after that those to net-next.

Thanks Jozsef.
