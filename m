From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.2-rc1
Date: Fri, 25 Jul 2008 14:22:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807251357210.30751@blackhole.kfki.hu>
References: <488734A3.3090401@trash.net> <Pine.LNX.4.58.0807241231520.30125@mail3.jubileegroup.co.uk>
 <48886ABA.8020200@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "G.W. Haywood" <ged@jubileegroup.co.uk>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	netfilter <netfilter@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:41624 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbYGYMWr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2008 08:22:47 -0400
In-Reply-To: <48886ABA.8020200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 24 Jul 2008, Patrick McHardy wrote:

> G.W. Haywood wrote:
> 
> > I'm curious about the ipset userspace tool - will it eventually find
> > its way to the iptables tarball?  Right now it seems that you get it
> > kind of incidentally when you apply the kernel patch, which seems to
> > me a little odd.
> 
> Jozsef should be able to answer that.

With the iptables source you already get the userspace part of the set 
match and target. The (new) ipset source tarball contains both the ipset 
userspace tool and the kernel modules, including the netfilter match and 
target. There's no need for patch-o-matic-ng for ipset anymore, so the 
life is easier to get the complete ipset functionality.

As I stated several times, I do not want to submit the kernel part of 
ipset for inclusion: there's no point to waste the resources of the 
maintainers as I have been working on a complete rewriting of ipset.
By the next netfilter development workshop I want to release the first 
version of it, so it's not in the indefinite future anymore.

I'd not like the ipset userspace tool to be included into the iptables 
source either. That'd be an even stranger situation and then there'd come 
even bigger pressure to submit the kernel part of the present version of 
ipset.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
