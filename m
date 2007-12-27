From: gpf <gpf@simm.ru>
Subject: Quota on SMP AGAIN
Date: Thu, 27 Dec 2007 18:14:05 +0300
Message-ID: <4773C13D.1040106@simm.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns.simm.ru ([89.239.191.1]:58379 "EHLO ns.simm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXL0PU3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Dec 2007 10:20:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by ns.simm.ru (Postfix) with ESMTP id 135017800978
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Dec 2007 18:14:12 +0300 (MSK)
Received: from ns.simm.ru ([127.0.0.1])
	by localhost (ns.simm.ru [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id BSfg-qm2iWwc for <netfilter-devel@vger.kernel.org>;
	Thu, 27 Dec 2007 18:14:10 +0300 (MSK)
Received: from [192.168.0.22] (unknown [192.168.0.22])
	by ns.simm.ru (Postfix) with ESMTP id ADEB57800965
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Dec 2007 18:14:10 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi

iptables, iptables-save not working properly

[root@ns bind] iptables -L quot |grep devel
RETURN     0    --  anywhere             developer.simm.ru   quota:
226620450 bytes
[root@ns bind] iptables -L quot |grep devel
RETURN     0    --  anywhere             developer.simm.ru   quota:
226620036 bytes
[root@ns bind] iptables -L quot |grep devel
RETURN     0    --  anywhere             developer.simm.ru   quota:
227219801 bytes
[root@ns bind] iptables -L quot |grep devel
RETURN     0    --  anywhere             developer.simm.ru   quota:
227219801 bytes
[root@ns bind] iptables -L quot |grep devel
RETURN     0    --  anywhere             developer.simm.ru   quota:
226619312 bytes

[root@ns bind] uname -a
Linux ns 2.6.18-5-686 #1 SMP Wed Oct 3 00:12:50 UTC 2007 i686 GNU/Linux
[root@ns bind] cat /etc/debian_version
4.0
[root@ns bind] dpkg -l |grep iptables
ii  iptables                   1.3.6.0debian1-5                        
administration tools for packet filtering an

Hardware: HP Proliant DL360


