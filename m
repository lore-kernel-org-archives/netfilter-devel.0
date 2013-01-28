From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] Introduce aliases for matches and targets
Date: Mon, 28 Jan 2013 21:32:52 +0100
Message-ID: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:49365 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3A1Ujl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:39:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The next patches introduce the alias support for matches and targets in
iptables. The goal is to keep the old syntax of matches/targets merged
into "super" matches/targets. This way firewall scripts can run unmodified,
using the old extensions.

The NOTRACK alias requires a new revision of the CT target (flags are checked
in the current revision). Next follows the kernel part of the patches. Until
the new revision is missing, instead of the warning, a notice is printed
to the users.

Please comment/ACK the patches.

Best regards,
Jozsef

Jozsef Kadlecsik (3):
  Introduce match/target aliases
  Add the "state" alias to the "conntrack" match
  Add the "NOTRACK" alias to the "CT" target

 extensions/libxt_CT.c                  |   48 ++++++++++++++++++++++++++++++++
 extensions/libxt_NOTRACK.man           |    4 +-
 extensions/libxt_conntrack.c           |   27 ++++++++++++++++--
 extensions/libxt_state.man             |    2 +-
 include/linux/netfilter/xt_CT.h        |    5 ++-
 include/linux/netfilter/xt_conntrack.h |    1 +
 include/xtables.h                      |   16 ++++++++++
 iptables/ip6tables.c                   |   34 ++++++++++++----------
 iptables/iptables.c                    |   34 ++++++++++++----------
 9 files changed, 132 insertions(+), 39 deletions(-)

