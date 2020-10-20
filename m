Return-Path: <SRS0=bd9C=D3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB9BC4363A
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 18:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB2F2206CA
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 18:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408894AbgJTSBE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Oct 2020 14:01:04 -0400
Received: from mg.ssi.bg ([178.16.128.9]:44678 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408890AbgJTSBD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 14:01:03 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id D448F2A4D0;
        Tue, 20 Oct 2020 21:01:00 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 15F392A444;
        Tue, 20 Oct 2020 21:01:00 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id E0FD23C09C1;
        Tue, 20 Oct 2020 21:00:59 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 09KI0xrP006704;
        Tue, 20 Oct 2020 21:00:59 +0300
Date:   Tue, 20 Oct 2020 21:00:59 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Damien Claisse <d.claisse@criteo.com>
cc:     "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Re: Network namespace, ipvlan and IPVS source NAT
In-Reply-To: <1A2C4E81-2244-4104-B543-08713F000C0C@criteo.com>
Message-ID: <79a56db-5657-6dda-5de0-d7565ef950c6@ssi.bg>
References: <1A2C4E81-2244-4104-B543-08713F000C0C@criteo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 20 Oct 2020, Damien Claisse wrote:

> I'm trying to understand a limitation in ipvlan/netfilter that prevents doing routed IPVS with source NAT inside a namespace.
> 
> Setup is the following: there is an "lvs" namespace, with an ipvlan interface (in l3 mode) moved to this namespace, linked to physical interface. Goal is to isolate load balanced traffic in a separate namespace.
> This setup is working flawlessly with l3 routed IPIP encapsulation, but I also have a use case for applications that don't support encapsulation, hence the need to do l3 routed load balancing with source NAT.
> Issue is that if I put iptables NAT rule in namespace using ipvs module, nothing happens, packet is forwarded but source IP is not translated. It seems like netfilter is blind to ipvlan l3 traffic. I also tried using "l3s" mode that should to go through netfilter, but in that case, packets for virtual IPs are rejected with a TCP reset. Virtual IPs in namespace seem not visible to this mode.
> 
> I'm wondering what would be the best way to make it happen:
> - patch ipvlan to lookup for VIPs in namespaces
> - patch netfilter ipvs NAT module to translate in root namespace
> - any other better idea is welcome
> 
> Please find below commands to reproduce the issue. In this example physical load balancer interface is enp4s0, virtual IP is 192.168.42.1 (to be exported by a routing protocol, or route manually added to a client in same subnet as load balancer for testing), load balancer IP is 192.168.10.10, and real server IP is 192.168.20.20
> 
> - In root namespace:
> ip netns add lvs
> ip link add ipvlan0 link enp4s0 type ipvlan mode l3s
> ip link set ipvlan0 up
> ip link set ipvlan0 netns lvs
> 
> - In lvs namespace (ip netns exec lvs bash):
> ip addr add 192.168.42.1/32 dev ipvlan0
> ip route add default via 192.168.10.10 dev ipvlan0 onlink
> ipvsadm -A -t 192.168.42.1:80 -s rr
> ipvsadm -a -t 192.168.42.1:80 -r 192.168.20.20:80 -m
> iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.42.1/24 --vport 80 -j SNAT --to-source 192.168.10.10

	Make sure /proc/sys/net/ipv4/vs/conntrack is set to 1
to allow IPVS to keep the netfilter conntracks for its
packets. This is supported with the CONFIG_IP_VS_NFCT=y
kernel option.

> What I'd expect: a packet outgoing from enp4s0 with source IP 192.168.10.10 and destination IP 192.168.20.20
> What I see from a test client:
> - in l3 mode: a packet outgoing from enp4s0 with source client IP address and destination 192.168.20.20 (hence missing source NAT). I also don't see any conntrack event when doing conntrack -E
> - in l3s mode: connection reset sent to client. While reading l3s implementation, I wonder where route lookup is done in ipvlan_l3_rcv, it seems that namespaces' virtual IP addresses are not visible during this lookup, hence the TCP RST.

Regards

--
Julian Anastasov <ja@ssi.bg>

