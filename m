From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: option parsing inversion fix
Date: Tue,  1 Mar 2011 15:44:24 +0100
Message-ID: <1298990667-22518-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46318 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676Ab1CAOo3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:44:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 2ad8dc895ec28a173c629c695c2e11c41b625b6e:

  xtables: use all IPv6 addresses resolved from a hostname (2011-02-27 02:28:44 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (2):
      iptables: fix an inversion
      doc: add VERSION section to manpages

 ip6tables.8.in |    3 +++
 iptables.8.in  |    3 +++
 xshared.c      |    2 +-
 3 files changed, 7 insertions(+), 1 deletions(-)
