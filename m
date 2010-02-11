From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 0/10] netfilter: ebtables: CONFIG_COMPAT support
Date: Thu, 11 Feb 2010 15:12:30 +0100
Message-ID: <1265897559-10610-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53713 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397Ab0BKOMh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:12:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everyone,

this is version 2 of the ebtables CONFIG_COMPAT patch set.

First patches are minor bug fixes/preparation patches.  Patch 7 is the
main CONFIG_COMPAT hunk, 8 handles those ebtables binaries specifically
built for 64 bit kernel (i.e. pad in userspace).

Last two patches add CONFIG_COMPAT support to the targets/matches that
need special handling (maybe I missed some, though).

Tested on x86_64 with x86 userland by comparing output of 32 and 64 bit ebtables binaries.

Changes since v1:
 - also move handling of ebt counter set/getsockopt handling to helper functions to avoid
   copy & pasting the same code in the COMPAT handlers.
 - add missing length check to compat_do_ebt_get_ctl().
 - add a patch to handle "userspace-side-padding" in some ebtables 32bit userspace binaries.
 - add "const *" qualifiers to the compat_from/to user functions.

At the moment this tree adds a few compiler warnings due to the presence of "const" qualifiers;
those warnings should all go away once Jan Engelhardts patch that adds the qualifier to the
declarations ("netfilter: xtables: constify args in compat copying functions") is merged.

The following changes since commit a8c28d05150f758625c5da38199b247887735e65:
  Patrick McHardy (1):
        Merge branch 'master' of git://dev.medozas.de/linux

are available in the git repository at:

  git://chamillionaire.breakpoint.cc/fw/nf-next-2.6.git ebt_config_compat

Florian Westphal (10):
      netfilter: ebtables: abort if next_offset is too small
      netfilter: ebtables: avoid explicit XT_ALIGN() in match/targets
      netfilter: CONFIG_COMPAT: allow delta to exceed 32767
      netfilter: ebtables: split do_replace into two functions
      netfilter: ebtables: split copy_everything_to_user into two functions
      netfilter: ebtables: split update_counters into two functions
      netfilter: ebtables: add CONFIG_COMPAT support
      netfilter: ebtables: try native set/getsockopt handlers, too
      netfilter: ebt_limit: add CONFIG_COMPAT support
      netfilter: ebtables: mark: add CONFIG_COMPAT support

 include/linux/netfilter/x_tables.h  |    2 +-
 net/bridge/netfilter/ebt_802_3.c    |    2 +-
 net/bridge/netfilter/ebt_arp.c      |    2 +-
 net/bridge/netfilter/ebt_arpreply.c |    2 +-
 net/bridge/netfilter/ebt_dnat.c     |    2 +-
 net/bridge/netfilter/ebt_ip.c       |    2 +-
 net/bridge/netfilter/ebt_ip6.c      |    2 +-
 net/bridge/netfilter/ebt_limit.c    |   18 +-
 net/bridge/netfilter/ebt_log.c      |    2 +-
 net/bridge/netfilter/ebt_mark.c     |   33 +-
 net/bridge/netfilter/ebt_mark_m.c   |   39 ++-
 net/bridge/netfilter/ebt_nflog.c    |    2 +-
 net/bridge/netfilter/ebt_pkttype.c  |    2 +-
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_snat.c     |    2 +-
 net/bridge/netfilter/ebt_stp.c      |    2 +-
 net/bridge/netfilter/ebt_ulog.c     |    2 +-
 net/bridge/netfilter/ebt_vlan.c     |    2 +-
 net/bridge/netfilter/ebtables.c     | 1110 +++++++++++++++++++++++++++++++----
 net/netfilter/x_tables.c            |    6 +-
 20 files changed, 1103 insertions(+), 133 deletions(-)

