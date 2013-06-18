From: Tsachi <tsachi.kimel@gmail.com>
Subject: Bridge-nf and iptables SNAT
Date: Tue, 18 Jun 2013 17:11:33 +0300
Message-ID: <CAAobQ8eDxDYaewZM2AmPK0MnbNnamXOnOmtJjsH=4CD90Hct-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:48583 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab3FROLe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:11:34 -0400
Received: by mail-ve0-f178.google.com with SMTP id pb11so3136477veb.23
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2013 07:11:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have few questions regarding bridge-nf which I hope it is the right
place to ask:
Background: Embedded Linux MIPS 200 MHz, Kernel 2.6.35.12 (netfilter
iptables+ebtables)
I am developing a bridge device (2 ports) which receives an IP
(public) from the network (internet).
I want to share this IP between the bridge interface and the host
computer which is connected to one of the bridge port.
The bridge interface has a private IP (e.g 10.0.0.1) but when going
out to the internet it should use the public IP (which the host is
also using).

Host computer <-> device (bridge) <-> Internet

When "/proc/sys/net/bridge/bridge-nf-call-iptables" is enabled,
Adding a simple iptable SNAT postrouting  rule, works well.
SNAT perform on the bridge outbound packets and Inbound bridged
packets will be going through the iptable conntrack (NAT) flow and are
accepted by the bridged interface (if were initiated from it).
Packets from to the host are going through the bridge normally.

The problem is that enabling bridge-nf-call-iptables, has an effect on
bridge traffic throughput:
96Mb/s when disabled.
70Mb/s when enabled.

First question:
When I check the same without bridge (routing + SNAT) throughput was 86Mb/s.
When bridge-nf-call-iptables is enabled, packets are going through L2
bridge code as well as L3 netfilter code, but, why it has such an
effects on the throughput?

Second question:
In order to share an IP (with iptables SNAT, without enabling
bridge-nf-call-iptables) ,
One solution I thought about, is to write a new ebtable module (used
in the brouting chain) which looks for the packet in the conntrack.
In case it finds it, Drop (routed) the packet, thus going through the
iptables code, if not found - Accept it (bridged).
This means some skb header work and conntrack searching for every
packet, do you think is a good approach?

Is there something that I am missing and can be done in a simpler way?

Other ideas are very much welcome?


Thanks,

Kimel
