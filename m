From: Derek Ng <derek@rentec.com>
Subject: destination NAT suggestion
Date: Wed, 7 Jan 2009 17:20:42 -0500
Message-ID: <200901071720.42864.derek@rentec.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from unicorn.rentec.com ([216.223.240.10]:43843 "EHLO
	unicorn.rentec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbZAGWjs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:39:48 -0500
Received: from papyrus2.rentec.com ([172.18.66.19])
	by unicorn.rentec.com (8.13.6/8.12.1) with ESMTP id n07MKTXd017254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Wed, 7 Jan 2009 17:20:29 -0500 (EST)
Received: from sakura.rentec.com (sakura.rentec.com [172.18.83.39])
	by papyrus2.rentec.com (8.14.3/8.14.0/SuSE Linux 0.8) with ESMTP id n07MKhh5030536
	for <netfilter-devel@vger.kernel.org>; Wed, 7 Jan 2009 17:20:43 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Currently, iptables has the following behavior:

1) Packet enters to the incoming interface
2) Check the INPUT rules
3) Prerouting NAT check and perform source NAT
4) Check the FORWARD rules
5) Postrouting NAT check and perform destination NAT
6) Check the OUTPUT rules

The above flow has a limitation when performing the NAT.  SNAT can only be 
performed under PREROUTING chain and DNAT can only be done on POSTROUTING 
NAT.  It would be great if this limitation is removed.

Reasons:
1) Gain more control on routing table
	a) The host's routing table would be cleaner, no matter what the destination 
networks are.
2) More flexible and more competitive
	a) Engineer can design a cleaner and securer Linux firewalls and be creative
	b) Easier for troubleshooting when the routing table is clean
	c) More competitive to Cisco IOS NAT features (Inside Global, Inside Local, 
Outside Local, Outside Global)

Senario Example:
1) Assume the web servers IP addresses for yahoo and google as the following
	a) Yahoo: 10.10.10.1
	b) Google: 10.10.10.1
2) The firewall has three interfaces
	a) Inside LAN (172.16.0.0/24 network)
	b) Yahoo direct line (next hop IP is 192.168.1.1)
	c) Google direct line (next hop IP is 192.168.1.2)
3) iptables DNAT
	a) 172.16.1.1 > 10.10.10.1
	b) 172.16.1.2 > 10.10.10.1
3) Current Limitation
	a) Inside host tries to connect to Yahoo web server, 172.16.1.1.
	b) iptables receives the packet and performs the prerouting DNAT 172.16.1.1 > 
10.10.10.1
	c) Based on the 10.10.10.1 destination, the host will try to forward the 
packet based on the routing table, which can only point to 192.168.1.1 or 
192.168.1.2.
	d) Routing table.
		Either	1) 10.10.10.1 192.168.1.1 255.255.255.255 eth1
		or 		2) 10.10.10.1 192.168.1.2 255.255.255.255 eth2
4) Without the current limitation
	a) Inside host tries to connect to Yahoo web server, 172.16.1.1
	b) Host receives the packet and forward it to the outside interface based on 
the routing table.
	c) iptables performs the postrouting DNAT before sending it out to the next 
hop 192.168.1.1, 172.16.1.1 > 10.10.10.1
	d) Routing table.
		172.16.1.1 192.168.1.1 255.255.255.255 eth1
		172.16.1.2 192.168.1.2 255.255.255.255 eth2

If you need further information, please feel free to contact me at 
631-246-7626 or email me at derek@rentec.com

Thank you very much!

Sincerely,
Derek Ng
