From: "Maxime Ducharme" <mducharme@cybergeneration.com>
Subject: Re: netfilter efficiency
Date: Fri, 21 Jan 2005 14:35:25 -0500
Message-ID: <173b01c4fff0$5b180030$b000a8c0@cybergeneration.com>
References: <005c01c4ff19$508ade80$c0de623e@MAURO>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "MauroTablo'" <m.tablo@libero.it>,
	<netfilter-devel@lists.netfilter.org>
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


Hi

I think the packet will traverse every filters
before getting dropped by the policy

suggestion :
add a drop rule after each protocols
if packet is tcp

-A FORWARD -p tcp --dport 123 -j ACCEPT
...
-A FORWARD -p tcp --dport 1234 -j ACCEPT
-A FORWARD -p tcp -j DROP

-A FORWARD -p udp --dport 123 -j ACCEPT
-A FORWARD -p udp --dport 1234 -j ACCEPT
...
-A FORWARD -p udp -j DROP

This way a tcp packet which is not allowed wont
get to udp and icmp rules

Hope this helps

Have a nice day

Maxime Ducharme
Programmeur / Spécialiste en sécurité réseau

----- Original Message ----- 
From: "MauroTablo'" <m.tablo@libero.it>
To: <netfilter-devel@lists.netfilter.org>
Sent: Thursday, January 20, 2005 12:56 PM
Subject: netfilter efficiency


Hi all.
My Linux (+ iptables) based firewall has about 90 forward filtering rules,
for tcp packets (about 30 rules), udp datagram (about 40 rules) and icmp
messages(about 20 rules).
Suppose that it comes a transit tcp packet that doesn't match anyone of my
rules. So, the last rule will be applied, because it is the first one that
matches the packet (/sbin/iptables -A FORWARD -j DROP)

The question is: iptables confronts the TCP packet with all my 90 rules, or
it confronts the packet ONLY WITH rules for tcp packets (-p tcp)?
In other words, is there a function in netfilter that looks up to the
protocol type of a transit packet and decides which rules to confront the
packet with?

Thank you.
Mauro.
