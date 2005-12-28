From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack NAT problem w/ UDP
Date: Wed, 28 Dec 2005 08:15:47 +0100
Message-ID: <20051228071547.GC11503@oknodo.bof.de>
References: <H000006700179012.1135713196.@MHS>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: chip@innovates.com
Content-Disposition: inline
In-Reply-To: <H000006700179012.1135713196.@MHS>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> There seems to be an intermittent problem w/ NAT when the source port 
> and destination port are the same on UDP traffic.
[...]
> I diagnosed the problem by sniffing the traffic between the router and 
> internet device (DSL or cable modem).

How much time was there between the last correctly rewritten packet,
and the first bad packet?

I bet it was more than 120 seconds.

UDP is connectionless. Thus, conntracking must use some form of
idle (no packets flowing) timeout for its NAT entries. The timeout
is 120 seconds for replied (packets seen in both directions)
UDP connections.

With the setup you described, having fixed "real" ports, maybe
you can just set up static nat (use the SNAT or DNAT target after
matching client IP address), instead of dynamic (random mangled port)
NAT like MASQUERADE, and your problem will go away - because the decision
will be the same each time a new conntrack is created after a pause.

You could also try to work around the problem by making the application
send data in the correct direction more often than each 120 seconds.

Or you could manipulate the UDP timeout on the NAT box. Look/change
/proc/sys/net/ipv4/netfilter/ip_conntrack_udp_stream. However, this
will affect all UDP traffic (traceroute, DNS lookups).

best regards
  Patrick
