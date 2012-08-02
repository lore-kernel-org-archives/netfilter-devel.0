From: Fergal Meath <fergalme@gmail.com>
Subject: Local port forwarding and IP_NF_NAT_LOCAL
Date: Thu, 2 Aug 2012 12:58:47 +0100
Message-ID: <CAKZGBhjfz1cXH1SFH__HhN23z8e11Zs=ip_naUXbz4EVQV8ckw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35564 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab2HBL6s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:58:48 -0400
Received: by weyx8 with SMTP id x8so5771374wey.19
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Aug 2012 04:58:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have an SSH tunnel from my office to my home linux server box.
On my linux server box, I am trying to forward all port 80 traffic to
another device on my home network 192.168.1.1.
This is to allow me to remotely configure the other device on my home network.

Frozentux tutorials suggest that I could use DNAT and SNAT targets as follows...

/ # iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT
--to-destination 192.168.1.1:80
/ # iptables -t nat -A POSTROUTING -p tcp -d 192.168.1.1 --dport 80 -j
SNAT --to-source 192.168.1.113

Note: I use the OUTPUT and POSTROUTING chains because the packets come
out of my SSH server locally destined for 127.0.0.1:80.

When I generate some traffic, my browser hangs and  I get the
following console messages...

[  683.160000] IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 LEN=60 TOS=0x00
PREC=0x00 TTL=64 ID=45473 DF PROTO=TCP SPT=3833 DPT=80 WINDOW=32792
RES=0x00 SYN URGP=0
[  683.170000] NAT: no longer support implicit source local NAT
[  683.180000] NAT: packet src 192.168.1.1 -> dst 127.0.0.1

A quick search on this error message suggests that this option
IP_NF_NAT_LOCAL was removed from kernel 2.6.11.

This DNAT / SNAT combination works find for me with external traffic....
# iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT
--to-destination 192.168.1.1:80

Is there some way that I can force local traffic from OUTPUT chain
back into the PREROUTING chain?

I have iptables v1.3.6 running on linux-2.6.19-uc1.
More details below.

Any help would be greatly appreciated.

Regards,

Fergal


 # iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
SNAT       tcp  --  anywhere             192.168.1.1         tcp
dpt:http to:192.168.1.113
LOG        tcp  --  anywhere             anywhere            LOG level warning

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
LOG        tcp  --  anywhere             anywhere            LOG level warning
DNAT       tcp  --  anywhere             anywhere            tcp
dpt:http to:192.168.1.1:80
