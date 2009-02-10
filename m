From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/3] netfilter: xtables: add PKTTYPE target
Date: Tue, 10 Feb 2009 15:18:34 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0902101512500.9244@blackhole.kfki.hu>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145826.7501.34671.stgit@Decadence> <4990480D.9060900@trash.net> <4990B910.1050802@netfilter.org> <49918948.5010103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:57408 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZBJOSg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:18:36 -0500
In-Reply-To: <49918948.5010103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 10 Feb 2009, Patrick McHardy wrote:

> Pablo Neira Ayuso wrote:
> > Patrick McHardy wrote:
> > > Pablo Neira Ayuso wrote:
> > > > This patch adds the PKTTYPE target which can be used to mangle the
> > > > skbuff packet type field. This target is useful in conjunction with
> > > > the arptables mcmangle target to TCP working again when a
> > > > multicast hardware address is used. An example of its use:
> > > > 
> > > > iptables -I PREROUTING ! -s 224.0.0.0/4 -t mangle \
> > > >     -j PKTTYPE --to-pkt-type unicast
> > > > 
> > > > Given the following arptables rule-set:
> > > > 
> > > > arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6
> > > >     \ --mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
> > > > arptables -I INPUT --h-length 6 --destination-mac 01:00:5e:00:01:01
> > > >     \ -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27
> > > > 
> > > > See arptables mcmangle target for further information.
> > > That one refers to this patch :) So you're actually communicating
> > > using TCP and multicast? Why don't you use UDP, which works fine
> > > using multicast without pkttype mangling?
> > 
> > If the netdevice uses multicast MAC address, the link layer sets skbuff
> > pkttype to PACKET_MULTICAST and TCP (among others) doesn't like this.
> > This target is required to make TCP work again if a multicast MAC
> > address is used.
> 
> Yes, I know, I'm just wondering why you're using TCP at all for
> synchronizing. Its not for traffic from the Internet I assume
> since the node it ends up on is unknown to the outside anyways.

No, that's not the syncronizing traffic, but the "normal" TCP traffic to 
be filtered by the firewalls, which have got multicast MAC addresses on 
their interfaces.
 
Best regards,
Jzosef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
