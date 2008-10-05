From: Patrick McHardy <kaber@trash.net>
Subject: RFC: net/netfilter reorganization
Date: Sun, 05 Oct 2008 14:34:01 +0200
Message-ID: <48E8B439.6030608@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43647 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYJEMeJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:34:09 -0400
Received: from [192.168.0.100] (unknown [78.42.204.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTP id 37E4A948A7
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Oct 2008 14:34:06 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We've talked about reorganizing net/netfilter in a smaller group
during the workshop. Its currently quite crowded in there,
additionally the IPVS guys are moving their code under
net/netfilter/ipvs in 2.6.28.

Some suggestions for a new directory structure:

net/netfilter/xtables
net/netfilter/{ct, conntrack, nfct, ...}
net/netfilter/nftables for my new stuff

We could go further by splitting up xtables and conntrack,
parts of this structure would be mirrored in net/ipv4/netfilter
and net/ipv6/netfilter:

net/netfilter/xtables/matches
net/netfilter/xtables/targets
net/netfilter/ct/protocols
net/netfilter/ct/helpers

I'm not sure whether this is too much since 4 directory
levels seem a bit extreme.

Since the amount of core code is increasing too, one more
thought was

net/netfilter/core

containing core.c, netfilter.c, logging and queuing stuff and
everything netlink related that doesn't fall in a more specific
area.

