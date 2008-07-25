From: "G.W. Haywood" <ged@jubileegroup.co.uk>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.2-rc1
Date: Fri, 25 Jul 2008 14:10:01 +0100 (BST)
Message-ID: <Pine.LNX.4.58.0807251358380.25240@mail3.jubileegroup.co.uk>
References: <488734A3.3090401@trash.net> <Pine.LNX.4.58.0807241231520.30125@mail3.jubileegroup.co.uk>
 <48886ABA.8020200@trash.net> <Pine.LNX.4.64.0807251357210.30751@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter <netfilter@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jubileegroup.co.uk ([217.147.177.250]:35219 "EHLO
	mail3.jubileegroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbYGYNKE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:10:04 -0400
In-Reply-To: <Pine.LNX.4.64.0807251357210.30751@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Fri, 25 Jul 2008, Jozsef Kadlecsik wrote:

> > G.W. Haywood wrote:
> >
> > > I'm curious about the ipset userspace tool - will it eventually find
> > > its way to the iptables tarball?
>
> With the iptables source you already get the userspace part of the set
> match and target. The (new) ipset source tarball contains both the ipset
> userspace tool and the kernel modules, including the netfilter match and
> target. There's no need for patch-o-matic-ng for ipset anymore, so the
> life is easier to get the complete ipset functionality.

You're quite right, I've installed it on a couple of my mailservers and
it is a lot easier than patching [sic] the patch-o-matic sources.

Thank you.  Thank you all! very much for your efforts.

> ...there's no point to waste the resources of the maintainers as I
> have been working on a complete rewriting of ipset.  By the next
> netfilter development workshop I want to release the first version...

I understand.  I was just curious. :)

--

73,
Ged.
