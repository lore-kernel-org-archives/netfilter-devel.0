From: "fenglg" <flg2932946@163.com>
Subject: conntrack-tools sync ftp
Date: Thu, 15 May 2008 16:43:30 +0800
Message-ID: <482BFAFC.06D996.27390@m5-83.163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m5-83.163.com ([202.108.5.83]:45784 "HELO m5-83.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753662AbYEOI5h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 04:57:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter-devel:

	I test conntrack-tools using conntrack-tools-0.9.6, libnfnetlink-0.0.33, libnetfilter_conntrack-0.0.89 and linux-2.6.25.3.
    When i sync ftp-control connection, everything is ok. conntracks of two pc is:(/proc/net/ip_conntrack)
    tcp      6 431975 ESTABLISHED src=192.168.5.139 dst=10.0.2.2 sport=1360 dport=21 packets=10 bytes=592 src=10.0.2.2 dst=192.168.5.139 sport=21 dport=1360 packets=0 bytes=0 [ASSURED] mark=0 use=1       //node1

    tcp      6 431996 ESTABLISHED src=192.168.5.139 dst=10.0.2.2 sport=1360 dport=21 packets=0 bytes=0 src=10.0.2.2 dst=192.168.5.139 sport=21 dport=1360 packets=5 bytes=374 [ASSURED] mark=0 use=1                  //node2

    But the ftp-data connection can't through node2 if i add iptables' rule in node2.
       iptables -I FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT

    I don't understand why ftp-data can't be related to ftp-control.

    Anyone help, thanks!


Sincerely
Felix 


