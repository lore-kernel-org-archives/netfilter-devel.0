From: Jan Engelhardt <jengelh@medozas.de>
Subject: (resend) pull for iptables
Date: Fri, 5 Jun 2009 15:26:31 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906051524250.7950@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48789 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbZFEN0a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:26:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



The request is a resend from June 1's.
In light of the "let's wait" resolution for the NFQUEUE thread,
below's pull is tbd immediate as it fixes a preexisting condition.

----------
Date: Mon, 1 Jun 2009 12:06:28
Subject: pull for iptables


Please pull or apply from
	git://dev.medozas.de/iptables master

to receive:

[PATCH 1/5] libip6t_policy: remove redundant functions
[PATCH 2/5] policy: use direct xt_policy_info instead of ipt/ip6t
[PATCH 3/5] policy: merge ipv6 and ipv4 variant
[PATCH 4/5] build: fix manpage collection
[PATCH 5/5] extensions: use NFPROTO_UNSPEC for .family field

The xt_policy file layout kinda stood in the way a bit, so I felt
inclined to fix that. The manpage fix from Florian is ok, but can
be done a little simpler (see 4/5); the .c files receive updates
they should have gotten with v1.4.3-rc1-2-g03d9948 (5/5) to complete
the manpage collection group fix.
