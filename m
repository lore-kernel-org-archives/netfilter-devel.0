From: "Fischer, Anna" <anna.fischer@hp.com>
Subject: iptable_nat and ip_conntrack coupling
Date: Thu, 26 Mar 2009 17:04:09 +0000
Message-ID: <0199E0D51A61344794750DC57738F58E6677CE122D@GVW1118EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1341 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZCZREq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:04:46 -0400
Received: from G3W0631.americas.hpqcorp.net (g3w0631.americas.hpqcorp.net [16.233.59.15])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g5t0006.atlanta.hp.com (Postfix) with ESMTPS id 3E6BFC469
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 17:04:45 +0000 (UTC)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'd like to understand how tightly integrated the iptable_nat code is with ip_conntrack. If I have rules that define what packets are supposed to be NATed (e.g. -j SNAT --to x.x.x.x or -j DNAT --to x.x.x.x), then does the code *always* do NAT on packets that match those rules? Or, is there also the requirement that there has to be a connection maintained by ip_conntrack before packets are to be rewritten? For example, if there is an ICMP packet coming through the iptable_nat code, and it is a REPLY where ip_conntrack has not tracked a REQUEST for, then will this prevent the code from rewriting the packet, even if the rules match the packet?

Many thanks for your help.
