From: Jan Engelhardt <jengelh@medozas.de>
Subject: guided option parser, run 7
Date: Wed, 11 May 2011 15:52:45 +0200
Message-ID: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60362 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203Ab1EKPsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 8075493a00e06857147263574333df4073ea671b:

  Merge branch 'opts' of git://dev.medozas.de/iptables (2011-05-11 13:43:44 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables floating/opts

Jan Engelhardt (11):
      libip6t_mh: use guided option parser
      libip6t_rt: use guided option parser
      libxtables: XTTYPE_ETHERMAC support
      libxt_mac: use guided option parser
      libipt_CLUSTERIP: use guided option parser
      libxt_iprange: use guided option parser
      libipt_DNAT: use guided option parser
      libipt_SNAT: use guided option parser
      libipt_MASQUERADE: use guided option parser
      libipt_REDIRECT: use guided option parser
      libipt_SAME: use guided option parser

 extensions/libip6t_mh.c        |   44 ++++-------
 extensions/libip6t_rt.c        |  159 +++++++++++-----------------------------
 extensions/libipt_CLUSTERIP.c  |  157 +++++++++++++--------------------------
 extensions/libipt_DNAT.c       |   88 ++++++++++------------
 extensions/libipt_MASQUERADE.c |   48 +++++-------
 extensions/libipt_REDIRECT.c   |   62 ++++++---------
 extensions/libipt_SAME.c       |   82 ++++++++-------------
 extensions/libipt_SNAT.c       |   88 ++++++++++------------
 extensions/libxt_iprange.c     |  144 ++++++++++++++----------------------
 extensions/libxt_mac.c         |   80 +++++---------------
 include/xtables.h.in           |    3 +
 xtoptions.c                    |   26 +++++++
 12 files changed, 370 insertions(+), 611 deletions(-)
