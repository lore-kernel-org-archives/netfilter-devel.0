From: "Nicolas Macquet" <nmacquet@cyberdeck.com>
Subject: [IFUP][2xNICs] IP already attributed on distinct eth
Date: Tue, 27 Mar 2007 10:18:42 +0200
Message-ID: <MFEMLDHGENPIFCPLHHMOAEJCCIAA.nmacquet@cyberdeck.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello everybody,

Firstly, I would like to advise that I am French therefore my English is not
very good.

Here is my trouble :
I have got 2 identical servers under FC3/2.6.12 on which 2 ethernet cards
are mounted.

Server 1 :

The first NIC (eth0) permits to be connected to internet trough a
modem-router : 192.168.1.33/24.
The second NIC (eth1) is used for a specific application which is useless to
explain here : 10.1.0.1/16
This server is setup as a gateway so : ip_forward=1 and MASQUERADE on eth0
rule with IPTABLES.

I would like to put my second server on eth1 of server1 while keeping the
specific part of these servers : the second eth card in 10.1.0.1/16.
The technical constraint is that I cannot change eth1 setup (on both
servers)

What I have done:
-on server 1 : I have added an IP address to eth1 : 172.20.30.1/24
-on server 2 : I have replaced eth0 parameters with 172.20.30.2/24
I have also restricted the MASQUERADING rule to the network 172.20.30.0/8 on
server 1.

In this configuration, everything works well, my server 2 can access
Internet trough server1 as well as its second specific eth card.

Unfortunatelly, the second specific eth card of server 1 does not work any
more. The problem is that its freeze, in fact when I execute ifdown/ifup,
the terminal tells me that the IP address (10.1.0.1)  is already in use.

My questions :
How is it possible that server 1 could find IP 10.1.0.1 located on the
second eth card of my second server whereas they are linked by a distinct
eth interface ?
In other words : what is the fact that these 2 ethernet interfaces are
linked and not independant ? Which mistake have I made ?
There must be a particular network setup or an iptables rule that could
solve this ...

remember : only server 1 is a gateway

I thank you for your answers and your expertise.

Nicolas Macquet
