From: Jan Engelhardt <jengelh@medozas.de>
Subject: Ebtables cleanup patches
Date: Thu, 21 Oct 2010 17:06:03 +0200
Message-ID: <1287673569-8587-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, bdschuym@pandora.be
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56802 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0JUPGL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:06:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 093d282321daeb19c107e5f1f16d7f68484f3ade:

  tproxy: fix hash locking issue when using port redirection in __inet_inherit_port() (2010-10-21 13:06:43 +0200)

are available in the git repository at:
  git://dev.medozas.de/linux ebtables

Jan Engelhardt (5):
      netfilter: ebtables: remove unused definitions
      netfilter: xtables: add a missing pair of parentheses
      netfilter: ebtables: replace EBT_ENTRY_ITERATE macro
      netfilter: ebtables: replace EBT_MATCH_ITERATE macro
      netfilter: ebtables: replace EBT_WATCHER_ITERATE macro

 include/linux/netfilter/x_tables.h        |    2 +-
 include/linux/netfilter_bridge/ebtables.h |   80 ++++---------
 net/bridge/netfilter/ebtables.c           |  186 ++++++++++++++++++++---------
 3 files changed, 155 insertions(+), 113 deletions(-)
