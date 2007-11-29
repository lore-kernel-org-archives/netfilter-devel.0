From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [RFC] using iproute2 tables
Date: Thu, 29 Nov 2007 13:57:15 +0100
Message-ID: <474EB72B.4010709@balabit.hu>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:46803 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758858AbXK2M5R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 07:57:17 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 13C23C1449
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 13:57:16 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

If a module would use symbolic names as in iproute2, for instance using 
the same files and names in iproute2 and iptables, it is reasonable to 
add support of it by iptables core? I mean copying the 
rtnl_tab_initialize() function from iproute2 to iptables/xtables.c.

Regards,
Attila
