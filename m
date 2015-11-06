From: "Murat Sezgin" <msezgin@codeaurora.org>
Subject: route table change events
Date: Thu, 5 Nov 2015 16:48:30 -0800
Message-ID: <002701d1182c$db558e60$9200ab20$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50826 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030611AbbKFAsb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2015 19:48:31 -0500
Received: from MSEZGIN (qf-scl1nat.qualcomm.com [207.114.132.30])
	(using TLSv1 with cipher AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: msezgin@smtp.codeaurora.org)
	by smtp.codeaurora.org (Postfix) with ESMTPSA id 63C32140286
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Nov 2015 00:48:30 +0000 (UTC)
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

In the netfilter conntrack framework, is there a route table change event
handler like netdevice event handler? 

I am reading 3.4 and 3.14 kernels, but I couldn't find any, and I
implemented my own notification registration in routing code and a handler
in my own kernel module. With this handler, if there is any change in route
table, (add or remove), an event notify my module and I clean all the
conntrack entires which are created on each netdevice in the system.

I use a code in my block notifier handler something like below:

for_each_netdevice(&init_net, dev) {
	nf_ct_iterate_cleanup(&init_net, device_cmp, (void
*)(long)dev->ifindex);
}

I clean up all the conntrack entries, because it is possible that the newly
added route wants to send the traffic through another interface in the
system. If we don't delete the conntrack entry, the old source NAT address
would be remain in the conntrack table for that flow.

Regards,
Murat

