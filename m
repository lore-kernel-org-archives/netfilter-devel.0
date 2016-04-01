From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 00/17] netfilter: xtables: stricter ruleset validation
Date: Fri,  1 Apr 2016 14:17:20 +0200
Message-ID: <1459513057-30652-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46456 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754808AbcDAMRV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2016 08:17:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series adds more checks on xtables (arp, ip, ip6tables) rulesets.

- check all offsets (target, next) of all rules during initial pass
  after copy from userspace.
- check targets of jumps (-j bla): offset should be start of a rule
- assert that alleged target size is at least as big as minimum target
  structure
- change CONFIG_COMPAT code path to push ruleset via normal setsockopt
  path after initial 32->64 bit conversion to avoid duplicating checks
- use a common helper to copy counters from userspace instead of
  the ip/ip6/arp implementation.

Tested:
- iptables.git iptables-test.py passes
- made a few performance tests w. really silly rulesets to verify
that things don't slow down too much, see individual patches for details.

 include/linux/netfilter/x_tables.h |   12 +
 net/ipv4/netfilter/arp_tables.c    |  303 ++++++++++------------------------
 net/ipv4/netfilter/ip_tables.c     |  327 +++++++++----------------------------
 net/ipv6/netfilter/ip6_tables.c    |  320 ++++++++----------------------------
 net/netfilter/x_tables.c           |  244 +++++++++++++++++++++++++++
 5 files changed, 506 insertions(+), 700 deletions(-)

