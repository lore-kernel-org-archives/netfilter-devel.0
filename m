From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 0/1] doc: include matches/targets in manpage again
Date: Thu,  9 Jun 2011 15:29:42 +0200
Message-ID: <1307626184-25928-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48125 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757555Ab1FIN3q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:29:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I spent some thoughts about this already - should we perhaps separate
the extensions' manpages into their own file, rather than doing a
hackish substitution into ip[6]tables.8.in?

I was thinking of just taking the produced
matches[46].man/targets[46].man and install these, so that the only
postprocessing needed is cat, no sed,
and the result looking something like the xtables-addons(8) manpage.

That way, the duplicate presence of descriptions - since xt pieces
are copied to both - between iptables(8) and ip6tables(8) could also
be removed, and the makefile simplified.
How about it?

For now, this one:
===
The following changes since commit c960bde4a82792c285110589cf8b2cf1438e1b8f:

  Bump version to 1.4.11.1 (2011-06-08 15:26:17 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      doc: include matches/targets in manpage again

 iptables/Makefile.am |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
