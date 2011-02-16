From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: spaces, spaces.
Date: Wed, 16 Feb 2011 03:18:53 +0100
Message-ID: <1297822737-11204-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36198 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756596Ab1BPCTA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 21:19:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit af3d73ec867debb5e38c6c6fde66f05093714fec:

  iptables: fix segfault target option parsing (2011-02-11 01:46:45 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      ip6tables: spacing fixes for -o argument
      libxt_devgroup: option whitespace update following v1.4.10-49-g7386635
      extensions: fix indent of vtable

 extensions/libip6t_LOG.c    |   22 +++++++++++-----------
 extensions/libipt_LOG.c     |   22 +++++++++++-----------
 extensions/libipt_ecn.c     |   22 +++++++++++-----------
 extensions/libxt_devgroup.c |   14 +++++++-------
 extensions/libxt_recent.c   |   24 ++++++++++++------------
 ip6tables.c                 |    2 +-
 6 files changed, 53 insertions(+), 53 deletions(-)

The last one is for an upcoming patchset proposal of mine, so I thought
I might just include that here already.
