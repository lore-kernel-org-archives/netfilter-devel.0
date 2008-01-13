From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_RAWNAT target idea
Date: Sun, 13 Jan 2008 17:08:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48330 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYAMQI4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2008 11:08:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


the following series implements xt_RAWNAT, a target to do network
address translation not depending on conntrack. I still have an issue
though, if you have an idea what could be wrong, please let me know.



Network scheme:
	vmware--(eth0) -> (rtl0)--ichi--(sis0) -> internet and 85.214.

16:47 ichi:../Coding/linux-2.6_nosov # tcpdump -lni rtl0 port 22 -Xs0
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on rtl0, link-type EN10MB (Ethernet), capture size 65535 bytes
16:47:29.767215 IP 192.168.222.24.38108 > 85.214.69.204.22: S 3962616798:3962616798(0) win 5840 <mss 1460,sackOK,timestamp 6565122 0,nop,wscale 2>
        0x0000:  4510 003c 96dc 4000 4006 696c c0a8 de18  E..<..@.@.il....
        0x0010:  55d6 45cc 94dc 0016 ec30 bbde 0000 0000  U.E......0......
        0x0020:  a002 16d0 94a3 0000 0204 05b4 0402 080a  ................
        0x0030:  0064 2d02 0000 0000 0103 0302            .d-.........


The odd part is that the packet is not recognized by connection tracking
on ichi. `conntrack -E` remains silent, and the packet does not hit the
nat table. Only in mangle it is visible:

# iptables -t mangle -A FORWARD -i rtl0 -j LOG --log-prefix "[fw/rtl0] "

[14168.102974] [fw/rtl0] IN=rtl0 OUT=sis0 SRC=192.168.222.24 DST=85.214.69.204
LEN=60 TOS=0x10 PREC=0x00 TTL=63 ID=64886 DF PROTO=TCP SPT=40337 DPT=22
WINDOW=5840 RES=0x00 SYN URGP=0 


Is the packet constructed wrong? What I used inside the VMware host was:

# iptables -t raw -A POSTROUTING -o eth0 -d 1.3.3.7 -j RAWDNAT --to
  85.214.69.204



thanks,
Jan
