From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: multiple NAT on one box
Date: Sun, 16 Nov 2003 18:29:20 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311161815050.31812-100000@filer.marasystems.com>
References: <000801c3ac47$6cdfd610$0101a8c0@kc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kristof Cauwel <kristof.cauwel@ugent.be>
In-Reply-To: <000801c3ac47$6cdfd610$0101a8c0@kc>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 16 Nov 2003, Kristof Cauwel wrote:

> So I have 2 IP adresses towards the internet (one to serve network 1 and one
> to serve network 2) and 2 different networks on my LAN side. What I want to
> do is NAT all trafic comming from network 1 on the first IP and NAT all
> trafic comming from network 2 on the second IP.

I assume the two VLAN are using different IP networks? If so then just 
make suitable SNAT rules in POSTROUTING selecting the IP address to NAT as 
based on the source IP address.

iptables -t nat -A POSTROUTING -s net.of.vlan.1/mask -j SNAT --to-source  ip.for.vlan.1

or similar rules depending on how you want the clients to be NAT:ed.

If you have overlapping IP addresses on the VLANs then things get a little 
more complex.

To have the traffic routed correctly you need to use policy routing based
on the original source addresses and the "external" addresses. This part
is actually mostly independent of the NAT question. See the Linux advanced
routing howto or the iproute2 documentation for details.

I don't see anything in what you discuss where it is apparent that
iptables needs extensions to handle what you are doing in a clean manner.  
The 'nat' table supports custom chains just as the 'filter' table does.

You do not need to worry about the sizes of the conntrack table (includes
NAT of existing sessions). Your only concern there is to make sure the
conntrack hash size is at least sufficiently large for the amount of
concurrent sessions you need to support.

For administrative reasons I would recommend making your NAT rules as
general as possible, deferring access controls to the filter table only.

If I have overlooked anything of what you are doing then please don't be 
afraid to try to get it thru to my thick brain..

Regards
Henrik
