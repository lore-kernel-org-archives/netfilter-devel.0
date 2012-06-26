From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: hash:net,iface: fix interface
 comparision
Date: Tue, 26 Jun 2012 09:08:31 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1206260904520.8075@blackhole.kfki.hu>
References: <1339963006-15296-1-git-send-email-fw@strlen.de> <20120625131109.GA12597@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:60689 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2FZHIe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:08:34 -0400
In-Reply-To: <20120625131109.GA12597@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 25 Jun 2012, Pablo Neira Ayuso wrote:

> On Sun, Jun 17, 2012 at 09:56:46PM +0200, Florian Westphal wrote:
> > ifname_compare() assumes that skb->dev is zero-padded,
> > e.g 'eth1\0\0\0\0\0...'. This isn't always the case. e1000 driver does
> > 
> > strncpy(netdev->name, pci_name(pdev), sizeof(netdev->name) - 1);
> > 
> > in e1000_probe(), so once device is registered dev->name memory contains
> > 'eth1\0:0:3\0\0\0' (or something like that), which makes eth1 compare
> > fail.
> > 
> > Use plain strcmp() instead.
> 
> Applied, thanks Florian.

Thanks, Pablo! I had commited the patch in my ipset git tree, just haven't 
time yet to send/ack to you.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
