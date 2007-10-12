From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH 0/2] address type match limited to incoming interface
Date: Fri, 12 Oct 2007 16:03:29 +0200
Message-ID: <470F7EB1.2080309@balabit.hu>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:34394 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbXJLODe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:03:34 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id CE937C01A0
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Oct 2007 16:03:32 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Current version of address type match lets incoming packets filter by
address type such as LOCAL (local address of any interface). With this
the following patches this type check can be limited to the interface
the packet coming in. For instance the lets SSH in on every interface
and nothing else:

iptables -P INPUT DROP
(some additional checks may be here such as -m state --state INVALID -j
DROP)
iptables -A INPUT -p tcp -m tcp --dport 22 -m addrtype --dst-type LOCAL
--limit-iface -j ACCEPT

If a packet arrives on eth0 with the IP address of the eth0 it is
accepted but if it is an address of eth1 it is dropped.

Also it can be used for checking IP spoofing.

Regards,
	Attila

