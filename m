From: strawks <strawks@yahoo.fr>
Subject: Netfilter hooks on =?UTF-8?Q?SMP=3F?=
Date: Thu, 20 Mar 2008 14:42:02 +0100
Message-ID: <87bed2001e2a343fd125af9b3c97f8c4@nadia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp20.orange.fr ([80.12.242.27]:44923 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbYCTNmM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Mar 2008 09:42:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi all,

I'm working on a kernel module to filter packets for a specific application
(to build a firewall for this specific application). I can't use iptables
for performance issues (the module must filter hundred of thousands small
packets per second, and rules are added/removed relatively fast to a large
ruleset, which is too slow with iptables).

I'm filtering packets using the PREROUTING netfilter hooks, and I can't
figure how they are executed on SMP machine.

This hook should be executed in a softirq, and so could be run by multiple
CPUs at the same time.

This seems to be the case when 2 NICs are used (tested on a dual Xeon,
85%"load on each CPU).

But when there is only one NIC, only one CPU is used.

Is there a way to make packets coming from a single NIC handled by multiple
CPUs?

Thanks in advance,
strawks



