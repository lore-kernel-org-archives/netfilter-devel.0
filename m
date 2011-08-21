From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables-1.4.12 fixes (2)
Date: Sun, 21 Aug 2011 13:09:15 +0200
Message-ID: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38718 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1HULJk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 3716dfd7eac3afa7fb3098952550e510c8df0220:

  libxt_string: fix space around arguments (2011-08-20 21:16:17 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (21):
      doc: clarify libxt_connlimit defaults
      libxt_conntrack: remove one misleading comment
      libxt_dccp: restore missing XTOPT_INVERT tags for options
      libxt_dccp: fix deprecated intrapositional ordering of !
      libxt_dccp: spell out option name on save
      libxt_dccp: provide man pages options in short help too
      libxt_dccp: fix random output of ! on --dccp-option
      libxt_dscp: restore inversion support
      libxt_hashlimit: default htable-expire must be in milliseconds
      libxt_conntrack: fix --ctproto 0 output
      xtoptions: flag use of XTOPT_POINTER without XTOPT_PUT
      libip6t_frag: restore inversion support
      libxt_hashlimit: remove inversion from hashlimit rev 0
      libip6t_hbh: restore setting IP6T_OPTS_LEN flag
      libip6t_dst: restore setting IP6T_OPTS_LEN flag
      libipt_ttl: document that negation is available
      libxt_owner: restore inversion support
      libxt_physdev: restore inversion support
      libxt_policy: remove superfluous inversion
      tests: add negation tests for libxt_statistic
      libxt_hashlimit: observe new default gc-expire time when saving

 extensions/libip6t_dst.c       |    3 ++
 extensions/libip6t_frag.c      |   16 ++++++++++++
 extensions/libip6t_hbh.c       |    1 +
 extensions/libipt_ttl.c        |    2 +-
 extensions/libipt_ttl.man      |    2 +-
 extensions/libxt_connlimit.man |    3 +-
 extensions/libxt_conntrack.c   |   13 +++++----
 extensions/libxt_dccp.c        |   19 +++++++++-----
 extensions/libxt_dccp.man      |    2 +-
 extensions/libxt_dscp.c        |    5 ++-
 extensions/libxt_hashlimit.c   |   50 +++++++++++++++++++--------------------
 extensions/libxt_owner.c       |    3 +-
 extensions/libxt_physdev.c     |    7 +++--
 extensions/libxt_policy.c      |    3 +-
 iptables/xtoptions.c           |    8 +++++-
 tests/options-most.rules       |   19 +++++++++++++-
 16 files changed, 102 insertions(+), 54 deletions(-)
