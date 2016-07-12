From: ivan.vettese@openmailbox.org
Subject: iptables bypass via raw ethernet frames and other networking
 protocols
Date: Tue, 12 Jul 2016 05:05:13 -0700
Message-ID: <2eef5fa078283d833761a1a6d5612a97@openmailbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail2.openmailbox.org ([62.4.1.33]:52780 "EHLO
	mail2.openmailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbcGLMFQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jul 2016 08:05:16 -0400
Received: from www.openmailbox.org (unknown [10.91.130.51])
	by mail2.openmailbox.org (Postfix) with ESMTP id B7A0B10191D
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jul 2016 14:05:13 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"ZMap relies on the Linux kernel to respond to SYN/ACK packets with RST=
=20
packets in order to close connections opened by the scanner. This occur=
s=20
because ZMap sends packets at the Ethernet layer in order to reduce=20
overhead otherwise incurred in the kernel from tracking open TCP=20
connections and performing route lookups. As such, if you have a=20
firewall rule that tracks established connections such as a netfilter=20
rule similar to -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT=
,=20
this will block SYN/ACK packets from reaching the kernel. This will not=
=20
prevent ZMap from recording responses, but it will prevent RST packets=20
from being sent back, ultimately using up a connection on the scanned=20
host until your connection times out."

Once upon a time, I created a vm named ESCAPE with two network interfac=
e=20
cards in VirtualBox:
the first interface was set to use "NAT" - inside the vm it is eth0
the second interface was set to use "Internal Network" named=20
NOSTATSINETWORK - inside the vm it is eth1

According to the VirtualBox manual the Internal Network acts like Layer=
2=20
Switch.

Inside ESCAPE, using the NetworkManager GUI I set IPv6 to Ignore and I=20
set IPv4:
eth0 Address: 10.0.2.15, Netmask: 255.255.255.0, Gateway: 10.0.2.2, DNS=
:=20
127.0.0.1
eth1 Address: 192.168.77.1, Netmask: 255.255.255.0, Gateway: 127.0.0.1,=
=20
DNS: 127.0.0.1

My torrc config has the following lines so that tor binds to port 9040=20
and 5353 on 192.168.77.1:
TransPort 192.168.77.1:9040
DnsPort 192.168.77.1:5353

To make sure that all the traffic from the "Internal Network" goes=20
through Tor, I do:

iptables -t nat -A PREROUTING -i eth1 -p udp -m udp --dport 53 -j=20
REDIRECT --to-ports 5353
iptables -t nat -A PREROUTING -i eth1 -p tcp -m tcp --tcp-flags=20
=46IN,SYN,RST,ACK SYN -j REDIRECT --to-ports 9040

You still with me? Now let=E2=80=99s go to the filter table:

iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A INPUT -i eth1 -p udp -m udp --dport 5353 -j ACCEPT
iptables -A INPUT -i eth1 -p tcp -m tcp --dport 9040 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -j DROP

iptables -A FORWARD -j DROP

The tor user has uid of 122 in /etc/passwd, therefore the OUTPUT chain:

iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -d 192.168.77.0/24 -j ACCEPT
iptables -A OUTPUT -m owner --uid-owner 122 -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -j DROP

I then proceed to add the following to /etc/sysctl.conf which I believe=
=20
makes ESCAPE more secure:

net.ipv4.conf.all.accept_redirects=3D0
net.ipv4.conf.all.accept_source_route=3D0
net.ipv4.conf.all.bootp_relay=3D0
net.ipv4.conf.all.log_martians=3D1
net.ipv4.conf.all.proxy_arp=3D0
net.ipv4.conf.all.rp_filter=3D1
net.ipv4.conf.all.secure_redirects=3D1
net.ipv4.conf.all.send_redirects=3D0
net.ipv4.conf.default.accept_redirects=3D0
net.ipv4.conf.default.accept_source_route=3D0
net.ipv4.conf.default.bootp_relay=3D0
net.ipv4.conf.default.proxy_arp=3D0
net.ipv4.conf.default.rp_filter=3D1
net.ipv4.conf.default.send_redirects=3D0
net.ipv4.conf.lo.accept_redirects=3D0
net.ipv4.conf.lo.accept_source_route=3D0
net.ipv4.conf.lo.bootp_relay=3D0
net.ipv4.conf.lo.proxy_arp=3D0
net.ipv4.conf.lo.rp_filter=3D1
net.ipv4.conf.lo.send_redirects=3D0
net.ipv4.icmp_echo_ignore_all=3D1
net.ipv4.icmp_echo_ignore_broadcasts=3D1
net.ipv4.icmp_ignore_bogus_error_responses=3D1
net.ipv4.ip_forward=3D0
net.ipv4.tcp_syncookies=3D1
net.ipv6.conf.all.accept_redirects=3D0
net.ipv6.conf.all.accept_source_route=3D0
net.ipv6.conf.all.disable_ipv6=3D1
net.ipv6.conf.all.rp_filter=3D1
net.ipv6.conf.default.accept_redirects=3D0
net.ipv6.conf.default.accept_source_route=3D0
net.ipv6.conf.default.disable_ipv6=3D1

Great now the NOSTATSINETWORK setup is complete.

I create a new VM called STATSI and set the network interface to use=20
"Internal Network" named NOSTATSINETWORK.

In STATSI I use the NetworkManager GUI to set eth0 Address:=20
192.168.77.2, Netmask: 255.255.255.0, Gateway: 192.168.77.1, DNS:=20
192.168.77.1.

Later you manage to take control of STATSI and you now have full root=20
privileges.
Your main purpose is to identify my real ip.
How would you go about doing that?
If you send raw ethernet frames would you able to bypass ESCAPE's=20
iptable rules and identify my real ip?
Or maybe the numerous protocols that are out there: ipsec, l2tp, pptp,=20
ppp, pppoe, gre, stp, 802.1q, arp, multicast, anycast, igmp, ssdp mdns,=
=20
nat-pmp, upnp, eoip, "make your own protocol" etc... too numerous to=20
list, that when used will bypass ESCAPE's iptable rules and identify my=
=20
real ip?


Now coming to the other side how would you secure ESCAPE even further?


Notice I did not have to set up routing manually using ip route, as thi=
s=20
was all done automatically for me by either NetworkManager or the=20
iptable rules.

Also, notice that ESCAPE does not have any ebtables or arptables rules=20
set up.
What kind of ebtables (or arptables) rules help?
Or maybe adding any ebtables/arptables rules make the security of ESCAP=
E=20
even worse?

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
