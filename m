From: Thomas Spatzier <tspat@de.ibm.com>
Subject: Re: [netfilter-core] memory leak with IP connection tracking and IP forwarding
Date: Tue, 4 May 2004 16:02:26 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <200405041602.26635.tspat@de.ibm.com>
References: <200405041305.55627.tspat@de.ibm.com> <20040504115808.GJ6345@sunbeam.de.gnumonks.org>
Reply-To: tspat@gmx.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040504115808.GJ6345@sunbeam.de.gnumonks.org>
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

> > I'm experiencing a major memory leak if I run a router with IP connection
> > tracking enabled and packets larger than MTU size.
>
> How do you observe such a memory leak?  What exact values are you
> looking at?

On the router I issue a 'watch -n 1 cat /proc/meminfo'.
Then I do a 'ping -f -s 64000' from one host to another host via the router.
On each update of my watch above there are about 10 MB of memory
(MemFree) missing.
I also watched /proc/slabinfo and noticed the increasing size of the
skbuff_head_cache slab.

> > My only glue so far is that the skbuff_head_cache is growing. Connection
> > tracking has a hook in the IP stack, where it gets hold of packets. If
> > these packets are fragmented (due to the packet size being larger than
> > MTU size) they are reassembled by ip_conntrack. So I guess the memory
> > leak might be somewhere in there.
>
> Did you enable support for bridging?
>
> There was a bug in the bridging (bridging firewall) code which made it
> 'forget' to drop the reference count (and thus introduced a memory
> leak).

CONFIG_BRIDGE is not set, i.e. bridging is not enabled.

-- 
Regards,
Thomas.

