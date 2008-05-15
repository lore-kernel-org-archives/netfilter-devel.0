From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: conntrack-tools sync ftp
Date: Thu, 15 May 2008 11:25:40 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805151125270.16151@fbirervta.pbzchgretzou.qr>
References: <482BFAFC.06D996.27390@m5-83.163.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: fenglg <flg2932946@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47795 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbYEOJZl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 05:25:41 -0400
In-Reply-To: <482BFAFC.06D996.27390@m5-83.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-15 10:43, fenglg wrote:
>netfilter-devel:
>
>	I test conntrack-tools using conntrack-tools-0.9.6, libnfnetlink-0.0.33, libnetfilter_conntrack-0.0.89 and linux-2.6.25.3.
>    When i sync ftp-control connection, everything is ok. conntracks of two pc is:(/proc/net/ip_conntrack)
>    tcp      6 431975 ESTABLISHED src=192.168.5.139 dst=10.0.2.2 sport=1360 dport=21 packets=10 bytes=592 src=10.0.2.2 dst=192.168.5.139 sport=21 dport=1360 packets=0 bytes=0 [ASSURED] mark=0 use=1       //node1
>
>    tcp      6 431996 ESTABLISHED src=192.168.5.139 dst=10.0.2.2 sport=1360 dport=21 packets=0 bytes=0 src=10.0.2.2 dst=192.168.5.139 sport=21 dport=1360 packets=5 bytes=374 [ASSURED] mark=0 use=1                  //node2
>
>    But the ftp-data connection can't through node2 if i add iptables' rule in node2.
>       iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
>
>    I don't understand why ftp-data can't be related to ftp-control.
>
>    Anyone help, thanks!

modprobe nf_conntrack_ftp
