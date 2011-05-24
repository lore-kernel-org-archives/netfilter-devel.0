From: Jan Engelhardt <jengelh@medozas.de>
Subject: Doc/Option parser fixes
Date: Wed, 25 May 2011 01:08:01 +0200
Message-ID: <1306278506-11463-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40914 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728Ab1EXXI3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Notes:
 - libxt_time's --localtz remains being recognized, albeit with a warning
 - no changes to libxt_rateest parser

With this applied, I have cleared my stash of fixes, and release can
proceed.

=-=-=
The following changes since commit 17f7937f79af4d260c60cb800e56fc0df0a48b37:

  libxt_devgroup: actually set XT_DEVGROUP_OPT_???GROUP flags (2011-05-23 16:28:25 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

JP Abgrall (1):
      libxt_quota: make sure uint64 is not truncated

Jan Engelhardt (22):
      libxtables: retract _NE types and use a flag instead
      libxt_quota: readd missing XTOPT_PUT request
      libxtables: check for negative numbers in xtables_strtou*
      libxt_rateest: streamline case display of units
      doc: add some coded option examples to libxt_hashlimit
      doc: make usage of libxt_rateest more obvious
      doc: clarify that -p all is a special keyword only
      doc: use .IP list for TCPMSS
      doc: remove redundant .IP calls in libxt_time
      libxt_ipvs: restore network-byte order
      libxt_u32: --u32 option is required
      libip6t_rt: restore --rt-type storing
      libxtables: more detailed error message on multi-int parsing
      libxtables: use uintmax for xtables_strtoul
      libxtables: make multiint parser have greater range
      libxtables: unclutter xtopt_parse_mint
      libxtables: have xtopt_parse_mint interpret partially-spec'd ranges
      libxt_NFQUEUE: avoid double attempt at parsing
      libxt_NFQUEUE: add mutual exclusion between qnum and qbal
      libxt_time: always ignore libc timezone
      libxt_time: --utc and --localtz are mutually exclusive
      libxt_time: deprecate --localtz option, document kernel TZ caveats

Lutz Jaenicke (1):
      libipt_REDIRECT: "--to-ports" is not mandatory

 extensions/libip6t_ah.c        |   10 +--
 extensions/libip6t_frag.c      |   12 +--
 extensions/libip6t_rt.c        |   14 +--
 extensions/libipt_REDIRECT.c   |    3 +-
 extensions/libipt_ah.c         |   10 +--
 extensions/libxt_NFQUEUE.c     |   12 +-
 extensions/libxt_TCPMSS.man    |   14 +--
 extensions/libxt_TPROXY.c      |    8 +-
 extensions/libxt_conntrack.c   |   73 ++------------
 extensions/libxt_esp.c         |   10 +--
 extensions/libxt_hashlimit.man |   26 +++--
 extensions/libxt_ipvs.c        |    6 +-
 extensions/libxt_length.c      |    4 +-
 extensions/libxt_quota.c       |    3 +-
 extensions/libxt_rateest.c     |    6 +-
 extensions/libxt_rateest.man   |   71 ++++++++++---
 extensions/libxt_time.c        |   38 +++++--
 extensions/libxt_time.man      |   45 ++++++---
 extensions/libxt_u32.c         |    3 +-
 include/xtables.h.in           |   16 ++--
 ip6tables.8.in                 |    5 +-
 iptables.8.in                  |    5 +-
 xtables.c                      |   20 +++--
 xtoptions.c                    |  226 +++++++++++++++++++++++++---------------
 24 files changed, 348 insertions(+), 292 deletions(-)
