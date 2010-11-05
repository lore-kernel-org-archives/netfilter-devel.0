From: Jan Engelhardt <jengelh@medozas.de>
Subject: people.netfilter.org v6 busted
Date: Fri, 5 Nov 2010 19:38:35 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011051937540.23942@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44450 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0KESig (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:38:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by borg.medozas.de (Postfix) with ESMTP id 4309364E2
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Nov 2010 19:38:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


JFYI, p.n.o ain't reachable over IPv6 anymore.


19:37 nova:~/code/iptv-analyzer > telnet people.netfilter.org 80
Trying 2001:780:45:1d:a00:20ff:feb3:606d...
telnet: connect to address 2001:780:45:1d:a00:20ff:feb3:606d: No route 
to host
Trying 213.95.46.76...
Connected to people.netfilter.org.
Escape character is '^]'.
^]
telnet> Connection closed.
19:37 nova:~/code/iptv-analyzer > telnet ipv6.google.com 80
Trying 2a00:1450:8004::67...
Connected to ipv6.google.com.
Escape character is '^]'.
^]
telnet> Connection closed.


