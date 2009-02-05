From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/3 v2] netfilter: multi-primary firewall clustering support
Date: Thu, 05 Feb 2009 18:22:09 +0100
Message-ID: <498B2041.1000003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50519 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753552AbZBERWQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:22:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This is the second version of the clustering support for iptables. The
following patches add one target for arptables, one target and one
match for iptables. They are useful to setup active/active setups both
for gateways with connection tracking support and back-end servers.

[PATCH 1/3] netfilter: arptables: add mcmangle target
[PATCH 2/3] netfilter: xtables: add PKTTYPE target
[PATCH 3/3] netfilter: xtables: add cluster match

One node of my testbed in an primary/backup setup performs very simple
stateful filtering and NAT of ~21000 TCP connections per second. By
using these target/matches appropriately, my two firewall nodes
(multi-primary setup) can filter traffic reaching up to ~30000
connection per second, which means a gain of ~40% more. I don't know yet
the limit of this solution in terms of scalability as I also have two
firewall nodes.

BTW, this patchset contains some of the Jan Engelhardt's suggestions.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
