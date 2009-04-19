From: Jan Engelhardt <jengelh@medozas.de>
Subject: conntrack -E misses ipv6 events
Date: Sun, 19 Apr 2009 13:12:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904191309470.4703@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44890 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbZDSLMH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Apr 2009 07:12:07 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


(given a loaded nf_conntrack_netlink.ko), conntrack -E seems to miss 
IPv6 connections. Xinetd listens on port 9 for testing.

# conntrack -E -e NEW,DESTROY -p tcp --orig-port-dst 9 &
[1] 8691

# telnet 127.0.0.1 9
Trying 127.0.0.1...
    [NEW] tcp      6 120 SYN_SENT src=127.0.0.1 dst=127.0.0.1 
sport=56558 dport=9 [UNREPLIED] src=127.0.0.1 dst=127.0.0.1 sport=9 
dport=56558
Connected to 127.0.0.1.
Escape character is '^]'.
^]
telnet> Connection closed.

# telnet ::1 9
Trying ::1...
Connected to ::1.
Escape character is '^]'.
^]
telnet> Connection closed.

(conntrack 0.9.12)


Jan
