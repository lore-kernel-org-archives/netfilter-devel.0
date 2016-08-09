From: vDev <vijaypas@gmail.com>
Subject: Drop pings to other VLAN interfaces
Date: Tue, 9 Aug 2016 10:03:56 -0500
Message-ID: <CAC=w+U5rT5pmpDeVie4+aYF4erfO7671qsNch1=q0Vb8V9k_6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f169.google.com ([209.85.217.169]:35676 "EHLO
	mail-ua0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbcHIPcD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Aug 2016 11:32:03 -0400
Received: by mail-ua0-f169.google.com with SMTP id n59so24277519uan.2
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Aug 2016 08:32:03 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have a Linux gateway with multiple VLANs with the default policy
being DROP. We have the following rules in the INPUT and OUTPUT chains
of the filter table:

iptables -I INPUT -p icmp -j ACCEPT
iptables -I OUTPUT -p icmp -j ACCEPT

to allow pings to and from the gateway. What would be the best way to
allow pings from a host on a VLAN to the VLAN interface on the gateway
and everywhere else EXCEPT to other VLAN interfaces on the gateway?

For example, if the gateway's VLAN interfaces had IP addresses
192.168.1.1/24 (vlan0) and 192.168.2.1/24 (vlan1) and host on vlan0
with address 192.168.1.8 must be able to ping 192.168.1.1 and other
public addresses EXCEPT 192.168.2.1. There could be many VLAN
interfaces so excluding each one will be not so efficient. I'm trying
to see if there's a better way that add specific DROP rules for each,
which can lead to a good number of rules depending on the number of
VLANs.

Thanks in advance for your help.
