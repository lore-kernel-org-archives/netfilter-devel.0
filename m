From: "Nishit Shah" <nishit@elitecore.com>
Subject: iptables error
Date: Sat, 30 Aug 2008 18:30:16 +0530
Message-ID: <003501c90aa0$59d583a0$0d808ae0$@com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:56842 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbYH3M7X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Aug 2008 08:59:23 -0400
Received: from ice.140.client116.youtele.com (HELO elitecore3) ([203.88.140.116])
          (envelope-sender <nishit@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 30 Aug 2008 12:35:27 -0000
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
	I am using 2.6.16.13 kernel in smp configuration. Machine is working
as a gateway and frequent iptables commands are fired as users logged in and
logged out.

      I got following error in between

[root@manage /root]# iptables -nvx -L INPUT
ERROR: 7 not a valid target)
Aborted (core dumped)

So, I tried to flush INPUT and got following

[root@manage /root]# iptables -F INPUT 
iptables: Too many levels of symbolic links

following is a message I got in /var/log/messages

Aug 26 14:38:30 1219741710 kernel: iptables: loop hook 1 pos 0 00000022.

Rgds,
Nishit Shah.        

