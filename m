From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf_ct_ipv6 doesn't like ICMPv6 MTU notices
Date: Wed, 19 May 2010 21:50:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005192138390.16764@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57408 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab0ESTuU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 May 2010 15:50:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Heya,


I notice that -m conntrack --ctstate INVALID marks what seems to be a 
legitimate packet. StrongSWAN sends out fragmented and large packets for 
PMTUD, and the returning ICMP packet too big from the tunnel provider 
falls victim to ctstate INVALID.

Observed on the left side running 2.6.33.x:
[1424176.051256] [v6-xinv] IN=sit1 OUT=
MAC=00:24:21:a7:24:e1:00:21:59:c5:58:5f:08:00:45:00:05:14:00:00:40:00:fb:29:3c:6d:d8:42:50:1e:bc:28:59:ca
TUNNEL=216.66.80.30->188.40.89.202 SRC=2001:0470:1f0a:0a59:0000:0000:0000:0001
DST=2001:0470:1f0b:0a59:0000:0000:0000:0001 LEN=1280 TC=0 HOPLIMIT=64 FLOWLBL=0
PROTO=ICMPv6 TYPE=2 CODE=0 [SRC=2001:0470:1f0b:0a59:0000:0000:0000:0001
DST=2001:0470:1f0b:1129:0000:0000:0000:0005 LEN=1480 TC=0 HOPLIMIT=64 FLOWLBL=0
FRAG:0 INCOMPLETE ID:0000003a PROTO=UDP SPT=4500 DPT=4500 LEN=2904 ] MTU=1430

And even on the other side running a 2.6.34-rc1:
[v6-xinv] IN=sit1 OUT=
MAC=00:14:4f:e1:d1:25:00:40:48:b1:5d:18:08:00:45:00:05:14:00:00:40:00:f7:29:7c:d8:d8:42:50:1e:86:4c:53:3b
TUNNEL=216.66.80.30->134.76.83.59 SRC=2001:0470:1f0a:1129:0000:0000:0000:0001
DST=2001:0470:1f0b:1129:0000:0000:0000:0005 LEN=1280 TC=0 HOPLIMIT=64 FLOWLBL=0
PROTO=ICMPv6 TYPE=2 CODE=0 [SRC=2001:0470:1f0b:1129:0000:0000:0000:0005
DST=2001:0470:1f0b:0a59:0000:0000:0000:0001 LEN=1480 TC=0 HOPLIMIT=64 FLOWLBL=0
FRAG:0 INCOMPLETE ID:00000070 PROTO=UDP SPT=4500 DPT=4500 LEN=2424 ] MTU=1430

21:44:07.473237 IP6 2001:470:1f0a:1129::1 > 2001:470:1f0b:1129::5: ICMP6,
packet too big, mtu 1430, length 1240

An idea what's up in nf_conntrack_ipv6?
