From: Bryan Duff <bduff@ecessa.com>
Subject: operation failure on delete
Date: Wed, 04 Mar 2009 10:16:38 -0600
Message-ID: <49AEA966.2020007@astrocorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21509 "EHLO
	mail.astrocorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZCDQi1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2009 11:38:27 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.astrocorp.com (Postfix) with ESMTP id 831AC630CF
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2009 10:16:26 -0600 (CST)
Received: from mail.astrocorp.com ([127.0.0.1])
	by localhost (mail.astrocorp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2KpMnx9i539F for <netfilter-devel@vger.kernel.org>;
	Wed,  4 Mar 2009 10:16:25 -0600 (CST)
Received: from Win2003.astrocorp.com (unknown [192.168.1.146])
	by mail.astrocorp.com (Postfix) with ESMTP id F17ED630CB
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2009 10:16:24 -0600 (CST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

//snip - conntrack search and attempted delete.
root@localhost / # conntrack -L -p gre  
unknown  47 27 src=60.60.60.151 dst=192.168.2.2 packets=6 bytes=648 
[UNREPLIED] src=10.10.10.100 dst=60.60.60.151 packets=0 bytes=0 mark=2 use=1
conntrack v0.9.11 (conntrack-tools): 1 flow entries has been shown.
root@localhost / # conntrack -D -p gre
conntrack v0.9.11 (conntrack-tools): Operation failed: invalid parameters
//end snip

But I can delete tcp, udp, icmp conntrack entries.  I can only guess 
that there is a problem with "unknown" protocols like gre (haven't 
checked on esp, and so forth).  Using the protocol number (in this case 
47) also fails.

I'm using  libnfnetlink-0.0.40 and libnetfilter_conntrack-0.0.99

Kernel version 2.6.29-rc7.  The conntrack version is that released on 
the website (md5sum: ae97d335ad44e9611adde881490c8ec9).

All that appears correct.

-Bryan
