From: Martin Kraus <lists_mk@wujiman.net>
Subject: Re: conntrackd, internal cache keeps filling up
Date: Fri, 11 Jul 2014 18:27:55 +0200
Message-ID: <20140711162755.GB3977@finrod>
References: <20140505104058.GA30297@finrod>
 <20140509113129.GA8031@localhost>
 <20140510061743.GA32197@finrod>
 <20140512163538.GA13344@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bomba.12web.cz ([81.0.208.153]:37357 "EHLO fedecks.wujiman.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbaGKQgz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:36:55 -0400
Content-Disposition: inline
In-Reply-To: <20140512163538.GA13344@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 12, 2014 at 06:35:38PM +0200, Pablo Neira Ayuso wrote:
> > will try 1.4.2. we just need to package it.

Hi. 

we've been running 1.4.2 since the end of May but the problem persists. We've
managed to keep it down to a restart once a month through NOTRACK rules but 
that's not a nice solution.

> Please, provide more information on how to reproduce the problem that
> you're noticing. Thank you.

We have two office routers (router1, router2) which are connected to our internal
vlans and then to the uplinks. Both routers are active and there is a dedicated 
line used for conntrackd synchronization.

An example of state that keeps filling the conntrackd internal cache is dns
traffic to our nat64 proxy.

A user from vlan6 goes to our nat64 proxy in vlan20. vlan6 has a default
gateway to router2, vlan20 has a default gateway to vlan1. 

User ipv6 address is 2001:1488:fffe:6:c941:fae:4505:7a22.
Nat64 ipv6 address is 2001:1488:fffe:20::34.

The dns packet from the user goes to router2 and then directly to vlan20 where the 
nat64 host is located.

The dns reply packet from nat64 then goes to router1 and then directly to
vlan6 back to the user.

Now on router2 when I run conntrackd -i I can see

udp      17 src=2001:1488:fffe:6:c941:fae:4505:7a22 dst=2001:1488:fffe:20::34 sport=6728 dport=53 [UNREPLIED] src=2001:1488:fffe:20::34 dst=2001:1488:fffe:6:c941:fae:4505:7a22 sport=53 dport=6728 [active since 192159s]
udp      17 src=2001:1488:fffe:6:c941:fae:4505:7a22 dst=2001:1488:fffe:20::34 sport=6961 dport=53 [UNREPLIED] src=2001:1488:fffe:20::34 dst=2001:1488:fffe:6:c941:fae:4505:7a22 sport=53 dport=6961 [active since 191949s]
udp      17 src=2001:1488:fffe:6:c941:fae:4505:7a22 dst=2001:1488:fffe:20::34 sport=6977 dport=53 [UNREPLIED] src=2001:1488:fffe:20::34 dst=2001:1488:fffe:6:c941:fae:4505:7a22 sport=53 dport=6977 [active since 191962s]
udp      17 src=2001:1488:fffe:6:c941:fae:4505:7a22 dst=2001:1488:fffe:20::34 sport=6979 dport=53 [UNREPLIED] src=2001:1488:fffe:20::34 dst=2001:1488:fffe:6:c941:fae:4505:7a22 sport=53 dport=6979 [active since 168352s]

and another 126000 entries like this. router1 is similar except that the state
is not UNREPLIED. kernel conntrack table doesn't have any of these entries.

Interesting thing is that it's usually 1 ipv[46] address that generates most
of these stale entries. 

This is the config file used

Sync {
        Mode FTFW {
                ResendQueueSize 131072
                ACKWindowSize 300
                DisableExternalCache On
        }
        UDP {
                IPv4_address 192.168.100.100
                IPv4_Destination_Address 192.168.100.200
                Port 3780
                Interface eth0
                Checksum on
        }
        Options {
                TCPWindowTracking On
        }

}

General {
        Nice -20

        HashSize 65536
        HashLimit 262144

        Syslog on
        LockFile /var/lock/conntrack.lock
        UNIX {
                Path /var/run/conntrackd.ctl
                Backlog 20
        }

        NetlinkBufferSize 2097152
        NetlinkBufferSizeMaxGrowth 8388608
        NetlinkEventsReliable Off
        NetlinkOverrunResync On

        Filter From Kernelspace {
                Address Ignore {             
                        IPv4_address 127.0.0.1 # loopback
                }
        }
}

I always assumed that the internal cache is a copy of the kernel conntrack table
plus entries that have not yet been synchronized to the other router so I
don't understand why is it getting this huge.

mk
