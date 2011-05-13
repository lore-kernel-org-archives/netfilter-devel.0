From: Jan Engelhardt <jengelh@medozas.de>
Subject: Guided option parser run 8
Date: Fri, 13 May 2011 02:47:24 +0200
Message-ID: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35622 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1EMAtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 59ce5bd1d05225911051a4c46ce5ccdd7c1ed078:

  Merge branch 'floating/opts' of git://dev.medozas.de/iptables (2011-05-12 11:11:51 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (12):
      src: replace old IP*T_ALIGN macros
      src: combine default_command functions
      libxt_policy: option table fixes, improved error tracking
      libxtables: avoid running into .also checks when option not used
      libxt_policy: use XTTYPE_PROTOCOL type
      libxtables: collapse double protocol parsing
      libipt_[SD]NAT: flag up module name on error
      libipt_[SD]NAT: avoid false error about multiple destinations specified
      libxt_conntrack: correct printed module name
      libxt_conntrack: fix assignment to wrong member
      libxt_conntrack: resolve erroneous rev-2 port range message
      libip6t_rt: rt-0-not-strict should take no arg

 extensions/libip6t_rt.c      |    2 +-
 extensions/libipt_DNAT.c     |   11 +++--
 extensions/libipt_SNAT.c     |   11 +++--
 extensions/libxt_conntrack.c |   24 +++++++-----
 extensions/libxt_policy.c    |   37 +++++++++++++-----
 extensions/libxt_policy.man  |    7 +++-
 include/libiptc/libip6tc.h   |    5 --
 include/libiptc/libiptc.h    |    9 ----
 ip6tables.c                  |   83 ++++-------------------------------------
 iptables.c                   |   84 ++++--------------------------------------
 libiptc/libip4tc.c           |    4 +-
 libiptc/libip6tc.c           |    4 +-
 xshared.c                    |   70 +++++++++++++++++++++++++++++++++++
 xshared.h                    |    3 +
 xtables.c                    |   49 ++++++++++--------------
 xtoptions.c                  |   17 ++------
 16 files changed, 180 insertions(+), 240 deletions(-)
