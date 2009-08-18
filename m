From: =?ISO-8859-1?Q?Timo_Ter=E4s?= <timo.teras@iki.fi>
Subject: bad nat connection tracking performance with ip_gre
Date: Tue, 18 Aug 2009 13:14:44 +0300
Message-ID: <4A8A7F14.3010103@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I noticed (in relation to my nbma gre multicast testing) that
the nat connection tracking code does not cache flows for
locally originating traffic that is routed to gre tunnel
(forwarded traffic is ok).

I basically have a router box with nbma gre tunnel. It gets
10/8 traffic. And is routed to internet interface. An ipsec
xfrm is applied.

Now, if the router box is forwarding traffic from some
physical interface, everything works as expected.

However, if a local process on the router box is sending
packets that go to gre tunnel, each packet causes a new
lookup on nat table OUTPUT chain. This is easily verified
by doing flood ping on router box on private IP and the
counters on nat table OUTPUT chain default policy start
to get incremented wildly.

I tried to oprofile this and it says most of the time is
spent in ipt_do_table(). I would suppose that the place
where netfilter hook is called is
ip_gre.c:ipgre_tunnel_xmit() when it invokes macro
IPTUNNEL_XMIT() calling ip_local_out().

Monitoring the connection tracking stats, it looks like
all packets are reusing the proper connection tracking
cache entry. But somehow the nat target still gets
called for the locally originating packets to gre.

Any ideas how to fix this?

Thanks,
 Timo
