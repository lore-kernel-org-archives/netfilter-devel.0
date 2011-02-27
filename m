From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: docs & address parsing
Date: Sun, 27 Feb 2011 02:31:10 +0100
Message-ID: <1298770280-7652-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52511 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab1B0Bb1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 20:31:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 094f104af71ca859c7c44406baed401659ad9421:

  libipt_ECN: set proper option flags (2011-02-19 20:08:29 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (5):
      doc: mention other possible nf_loggers for TRACE
      doc: fix odd partial sentence in libipt_TTL
      libxt_quota: require --quota to be specified
      doc: rateest options can be optional
      libxtables: fix memory scribble beyond end of array

Wes Campaigne (4):
      libxtables: avoid confusing use of ai_protocol=IPPROTO_IPV6
      xtables: fix excessive memory allocation in host_to_ipaddr
      xtables: fix the broken detection/removal of redundant addresses
      xtables: use all IPv6 addresses resolved from a hostname

 extensions/libipt_TTL.man    |    6 ++--
 extensions/libxt_TRACE.man   |    8 ++++--
 extensions/libxt_quota.c     |   10 +++++++-
 extensions/libxt_rateest.man |    8 +++---
 xtables.c                    |   55 ++++++++++++++++++++++-------------------
 5 files changed, 50 insertions(+), 37 deletions(-)
