From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: hashlimit & conntrack misc
Date: Fri, 25 Jun 2010 14:45:39 +0200
Message-ID: <1277469942-26270-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58077 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab0FYMpp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:45:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 11c2dd54b69e06ae3f35dea130ecba3df3859243:

  xtables: remove xtables_set_revision function (2010-06-07 12:00:24 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (2):
      libxt_hashlimit: always print burst value
      libxt_conntrack: do print netmask

 extensions/libxt_conntrack.c |   16 ++++++++++++----
 extensions/libxt_hashlimit.c |    6 ++----
 2 files changed, 14 insertions(+), 8 deletions(-)
