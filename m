From: Jan Engelhardt <jengelh@medozas.de>
Subject: Option parsing fixes (t-10)
Date: Tue, 24 May 2011 03:21:31 +0200
Message-ID: <1306200102-12148-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41725 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030834Ab1EXBVp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 21:21:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



This goes on top of the previous series of 13.

===

The following changes since commit 11811bc2f6e7a333c32ad4b4685ac769b5f7c379:

  libxt_ipvs: restore network-byte order (2011-05-23 00:22:27 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables next

Jan Engelhardt (10):
      libxt_time: always ignore libc timezone
      libxt_time: --utc and --localtz are mutually exclusive
      doc: use .IP list for TCPMSS
      doc: remove redundant .IP calls in libxt_time
      libxt_time: remove --localtz option
      libxt_u32: --u32 option is required
      libip6t_rt: restore --rt-type storing
      libxtables: more detailed error message on multi-int parsing
      libxtables: use uintmax for xtables_strtoul
      libxtables: make multiint parser have greater range

 extensions/libip6t_rt.c     |    4 +-
 extensions/libxt_TCPMSS.man |   14 +++--------
 extensions/libxt_time.c     |   41 ++++++++++++++++++++++++-----------
 extensions/libxt_time.man   |   45 +++++++++++++++++++++++++++------------
 extensions/libxt_u32.c      |    3 +-
 include/xtables.h.in        |    4 +-
 xtables.c                   |   11 +++++----
 xtoptions.c                 |   49 +++++++++++++++++++++++++++++--------------
 8 files changed, 108 insertions(+), 63 deletions(-)
