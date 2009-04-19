From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack -E misses ipv6 events
Date: Sun, 19 Apr 2009 13:15:54 +0200
Message-ID: <49EB07EA.1070507@netfilter.org>
References: <alpine.LSU.2.00.0904191309470.4703@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50738 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353AbZDSLQE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Apr 2009 07:16:04 -0400
In-Reply-To: <alpine.LSU.2.00.0904191309470.4703@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> (given a loaded nf_conntrack_netlink.ko), conntrack -E seems to miss 
> IPv6 connections. Xinetd listens on port 9 for testing.

Did you forget to load nf_conntrack_ipv6?

Decadence:/home/pablo# conntrack -E
    [NEW] tcp      6 120 SYN_SENT src=::1 dst=::1 sport=40220 dport=80
[UNREPLIED] src=::1 dst=::1 sport=80 dport=40220
 [UPDATE] tcp      6 60 SYN_RECV src=::1 dst=::1 sport=40220 dport=80
src=::1 dst=::1 sport=80 dport=40220
 [UPDATE] tcp      6 432000 ESTABLISHED src=::1 dst=::1 sport=40220
dport=80 src=::1 dst=::1 sport=80 dport=40220 [ASSURED]
 [UPDATE] tcp      6 120 FIN_WAIT src=::1 dst=::1 sport=40220 dport=80
src=::1 dst=::1 sport=80 dport=40220 [ASSURED]
 [UPDATE] tcp      6 60 CLOSE_WAIT src=::1 dst=::1 sport=40220 dport=80
src=::1 dst=::1 sport=80 dport=40220 [ASSURED]
 [UPDATE] tcp      6 30 LAST_ACK src=::1 dst=::1 sport=40220 dport=80
src=::1 dst=::1 sport=80 dport=40220 [ASSURED]
 [UPDATE] tcp      6 120 TIME_WAIT src=::1 dst=::1 sport=40220 dport=80
src=::1 dst=::1 sport=80 dport=40220 [ASSURED]
^Cconntrack v0.9.12 (conntrack-tools): 7 flow events have been shown.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
