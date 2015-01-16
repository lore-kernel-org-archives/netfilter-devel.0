From: The Media Server <info@themediaserver.com>
Subject: IPTABLES + PREROUTING + --set-mark + Ubuntu
Date: Thu, 15 Jan 2015 20:48:51 -0500
Message-ID: <CAJb3rWC_Xu2JhobvJZSv82034Y1TvDyk_rQXfvR+5eBN75kKQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from segonax.lunarpages.com ([216.97.227.60]:55308 "EHLO
	segonax.lunarpages.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbbAPCmS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:42:18 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:39208)
	by segonax.lunarpages.com with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <info@themediaserver.com>)
	id 1YBw1p-00052U-PU
	for netfilter-devel@vger.kernel.org; Thu, 15 Jan 2015 17:48:49 -0800
Received: by mail-la0-f47.google.com with SMTP id hz20so16708360lab.6
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2015 17:48:51 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes I tried it with let say:
2 ht

I also disabled and enabled in the kernel rp_filter and forward for ipv4:
sudo sysctl -w net.ipv4.conf.eth0.rp_filter=0 &&
sudo sysctl -w net.ipv4.conf.tun0.rp_filter=0 &&
sudo sysctl -w net.ipv4.conf.all.rp_filter=0 &&
sudo sysctl -w net.ipv4.conf.default.rp_filter=0 &&
sudo sysctl -w net.ipv4.conf.lo.rp_filter=0  &&

sudo sysctl -w net.ipv4.conf.all.forwarding=1 &&
sudo sysctl -w net.ipv4.conf.default.forwarding=1 &&
sudo sysctl -w net.ipv4.conf.eth0.forwarding=1 &&
sudo sysctl -w net.ipv4.conf.lo.forwarding=1 &&
sudo sysctl -w net.ipv4.conf.tun0.forwarding=1 &&

sudo sysctl -w net.ipv6.conf.all.forwarding=1 &&
sudo sysctl -w net.ipv6.conf.default.forwarding=1 &&
sudo sysctl -w net.ipv6.conf.eth0.forwarding=1 &&
sudo sysctl -w net.ipv6.conf.lo.forwarding=1 &&
sudo sysctl -w net.ipv6.conf.tun0.forwarding=1

the result of my rule list is:
0:      from all lookup local
32765:  from all fwmark 0x2 lookup ht
32766:  from all lookup main
32767:  from all lookup default

my ht (2) table is:
default via 192.168.0.1 dev eth0
192.168.0.0/24 dev eth0  proto kernel  scope link  src 192.168.2.20  metric 1

I tried these rules:
sudo iptables -t mangle -A PREROUTING -j MARK --set-mark 2
sudo iptables -t mangle -A OUTPUT -p tcp --dport 80 -j MARK --set-mark 2
sudo iptables -t mangle -A OUTPUT -p tcp --sport 80 -j MARK --set-mark 2

Nothing work..


--
The weird part is that the OUTPUT rules works:

sudo iptables -t mangle -A OUTPUT -p tcp --dport 80 -j MARK --set-mark 2
sudo iptables --table nat --append POSTROUTING -o eth0 -j MASQUERADE

and this work too:
sudo ip rule add from 192.168.2.0/24 table ht
---

Looks like it doesn't want to mark anything only the PREROUTING /
INPUT phase.. or an option somewhere is not enabled..

Thks
