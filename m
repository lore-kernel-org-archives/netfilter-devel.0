From: Old Cowhand <oldcowhanddoug@yahoo.com>
Subject: Re: Connection tracking bug with DNAT?
Date: Tue, 6 Apr 2004 09:07:39 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040406160739.33702.qmail@web21327.mail.yahoo.com>
References: <Pine.LNX.4.44.0404030028560.23219-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404030028560.23219-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> What I can tell is that I frequently do
> 
> a) DNAT of traffic destined to a local address on
> the NAT gateway to 
> redirect the traffic to another destination on the
> other side of the NAT 
> gateway.

This works, but it is NOT what we're doing.

> b) DNAT of traffic destined to a forwarded address
> on the other side of 
> the NAT gateway, to have the traffic redirected to a
> proxy running on the 
> NAT gateway.
>
> c) DNAT of traffic destined to a forwarded address
> on the other side of 
> the NAT gateway to have the traffic redirected to
> another destination, 
> often even via another network interface than the
> original destination.

I cannot get either b) or c) above to work.  These
only seem to work if the destination address is an
address configured on the NAT gateway itself.

Do you have a configuration that accomplishes these?

The destination address of the traffic MUST NOT be an
address configured on the NAT gateway.  The simplest
example is from my original post:

                                   |--Web server
       eth0                   eth1 |  192.168.64.15/24
PC---------------Linux 2.4.19-------
172.16.1.2/30    172.16.1.1/30     |
                 192.168.64.1/24   |--Web server
                                      192.168.64.5/24

My DNAT rule:

iptables -t nat -A PREROUTING -s 172.16.1.2 -d
192.168.64.5 -p tcp --dport 80 -j DNAT --to
192.168.64.15

>From my original post:

In tcpdump, I see the HTTP request come from the PC
with a destination of .5 on eth0.  I see the DNAT rule
match in iptables -L -n -v -t nat.  I see the HTTP
request go on eth1 to .15 (DNAT rule works).  I see
the HTTP server at .15 reply to 172.16.1.2 on eth1. 
The data is dropped and never returned after that. 
The reply never appears on eth0.

ip_conntrack shows SYN_SENT [UNREPLIED] on that
connection.

A few notes:

1) The PC can talk directly to .15's Web server with
no problems.  Routing is just fine.

2) If I configure .5 on the Linux box and ditch the
second Web server, everything works normally.

3) The DNAT rule is the ONLY iptables rule in place.

4) I have no dynamic routing, proxy arp, route filters
or other configurations in place.  It's simple static
routing.

I'm stumped.  Ultimately, I want to be able to take IP
addresses for my customers and point any Web requests
to a server that returns a page saying "Sorry, you
didn't pay your bill."  That's why #2 above won't work
for me in the long run.

> 
> d) Even DNAT back to a destination in the same
> network as the client, but 
> then SNAT must also be used to make sure return
> traffic is sent via the 
> NAT gateway and not directly to the original client.

This only works if the destination address is an
address configured on the NAT gateway.

Doug

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
