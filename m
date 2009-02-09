From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: arptables: add mcmangle target
Date: Mon, 09 Feb 2009 16:11:31 +0100
Message-ID: <499047A3.9000505@trash.net>
References: <20090128145801.7501.44459.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57001 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZBIPLg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:11:36 -0500
In-Reply-To: <20090128145801.7501.44459.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds the mcmangle target for arptables which allows
> altering the source hardware address in ARP with a multicast
> hardware address. This target can be used to make a switch flood
> packets to the ports that use the same MAC multicast address. This
> is useful to deploy load-sharing clusters in environments in which
> the switch does not provide a way to flood packets to several
> ports.

Great name. Took me a bit to realize the connection to "multicast" :)

> Since all the nodes receives the same packets, each decides if
> it handles the packet based on hashing approach (See the `cluster'
> iptables match that comes with this patchset).
> 
> Theoretically, the use of the reserved VRRP hardware address should
> be fine for this, however, switches generally treat this hardware
> address space as normal unicast hardware address. Thus, in practise,
> it is not possible to have two nodes with the same VRRP hardware
> address.
> 
> Please, note that this target violates RFC 1812 (section 3.3.2) since
> an ethernet device must not use a multicast link address.
> 
> An example of the use of this target:
> 
> arptables -I OUTPUT -o eth0 -j mcmangle --h-length 6 \
> 	--mc-mangle-mac 01:00:5e:00:01:01 --mc-mangle-dev eth0
> arptables -I INPUT -i eth0 --h-length 6 --destination-mac \
> 	01:00:5e:00:01:01 -j mangle --mangle-mac-d 00:zz:yy:xx:5a:27

Wouldn't it be more generically usable if it was a simple "set
either source or destination mac address to any value" target?
In fact thats what it seems to be (or is there a multicast check?),
so perhaps we should call it S/DNAT for consistency with iptables
and ebtables?

I'm wondering though why the device is needed as a parameter ..
ah I see:

+	if (dev_mc_add(dev, mangle->mc_devaddr, ETH_ALEN, 0) < 0) {
+		printk(KERN_ERR "arpt_mcmangle: cannot set multicast "
+				"address\n");
+		return false;
+	}

Continuing the idea of a generic ARP address mangling target,
this would have to be done in userspace using SIOCADDMULTI.

I would also prefer that approach because the multicast mangling
seems a bit like a hack which only works when the requesting
host accepts a multicast MAC address in the ARP reply.


