From: Jan Engelhardt <jengelh@medozas.de>
Subject: pull for iptables
Date: Mon,  1 Jun 2009 12:06:28 +0200
Message-ID: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53160 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbZFAKGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:06:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


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
