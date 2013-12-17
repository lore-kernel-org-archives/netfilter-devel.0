From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Tue, 17 Dec 2013 14:01:17 +0100
Message-ID: <20131217130117.GA8852@localhost>
References: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
 <2247276.HWz9edslhi@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xiaosuo@gmail.xom, netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57980 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573Ab3LQNBc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:01:32 -0500
Content-Disposition: inline
In-Reply-To: <2247276.HWz9edslhi@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 15, 2013 at 07:57:02AM +0100, Oliver wrote:
> On Thursday 12 December 2013 10:19:34 Changli Gao wrote:
> > Think about the following scenario:
> > 
> > +--------+      +-------+      +----------+
> > 
> > | Server +------+ NAT 1 +------| Client 1 |
> > 
> > +---+----+      +-------+      +----------+
> > 
> >     |           +-------+      +----------+
> > 
> >     +-----------+ NAT 2 +------| Client 2 |
> >                 +-------+      +----------+
> > 
> > The following UDP punching steps are used to to establish a direct session
> > between Client 1 and Client 2 with the help from Server.
> > 
> > 1. Client 1 sends a UDP packet to Server, and Server learned the public IP
> > and port of Client 1.
> > 2. Client 2 sends a UDP packet to Server, and Server learned the public IP
> > and port of Client 2.
> > 3. Server tells Client 1 the public IP and port of Client 2.
> > 4. Server tells Client 2 the public IP and port of Client 1.
> > 5. Client 1 sends UDP packets to the public IP and port of Client 2.
> > 6. Client 2 sends UDP packets to the public IP and port of Client 1.
> > 
> > If both NAT 1 and NAT 2 are Cone NAT, Client 1 and Client 2 can communicate
> > with each other directly.
> > 
> > Linux tries its best to be a Port Restricted NAT. But there is a race
> > condition between 5 and 6.
> > 
> > Suppose the packet from Client 1 to the public IP and port of Client 2
> > reaches NAT 2 before the packet from Client 2 to the public IP and port of
> > Client 1, and it belongs to a new session to NAT 2 itself since there isn't
> > any corresponding conntrack in NAT 2, and it is likely that port isn't
> > opened at NAT 2, so at last, a Port Unreachable ICMP packet will be
> > delivered to Client 1.
> 
> I don't think that's universally the case; whether or not a port unreachable 
> happens is going to depend on the configured behaviour; it may very well just 
> silently drop the packet.

Indeed. You can configure those two NATs to make them more
hole-punching friendly by dropping UDP packets to local closed ports,
so that conntrack entry won't be created.
