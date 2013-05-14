From: Ankit <ankit.s.shah@elitecore.com>
Subject: Query: No-flush support for ebtables-restore in v2.0.10-4
Date: Tue, 14 May 2013 20:56:10 +0530
Message-ID: <51925792.3050505@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:3269 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756872Ab3ENPY3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 11:24:29 -0400
Received: from router.elitecore.com (HELO [10.102.1.165]) (ankit.s.shah@[203.88.135.193])
          (envelope-sender <ankit.s.shah@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 14 May 2013 15:17:41 -0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
         I am working on ebtables-v2.0.10-4 and I noticed that there is 
no support for "no-flush" switch in ebtables-restore unlike 
iptables-restore. Before I start digging for a roundabout solution, I 
wanted to confirm if there is any particular reason for not 
incorporating no-flush support in ebtables-restore? Does the netfilter 
team have any plans to develop it further?
Thanks,
Ankit.
