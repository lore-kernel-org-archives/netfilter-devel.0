From: Jan Engelhardt <jengelh@medozas.de>
Subject: (unknown)
Date: Fri, 26 Jun 2009 21:19:42 +0200
Message-ID: <1246043992-379-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39664 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761310AbZFZTUJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:20:09 -0400
Subject: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


here are a number of patches I am suggesting for the -master branch
(-stable is separate in my view and my management, but see other
discussion thread).
Pullable from
	git://dev.medozas.de/iptables master


Jan Engelhardt (9):
      libiptc: split v4 and v6
      extensions: collapse registration structures
      iptables: allow for parse-less extensions
      iptables: allow for help-less extensions
      extensions: remove empty help and parse functions
      xtables: add multi-registration functions
      extensions: collapse data variables to use multi-reg calls
      xtables: warn of missing version identifier in extensions
      COMMIT_NOTES: notice to check for soversion bumps

Michael Granzow (1):
      iptables: accept multiple IP address specifications for -s, -d


(Shall I post the entire mergestat, or just the "X files changed" line?)

 COMMIT_NOTES                   |    6 +-
 Makefile.am                    |   35 ++++---
 configure.ac                   |    4 +-
 extensions/libip6t_eui64.c     |   26 -----
 extensions/libipt_MIRROR.c     |   20 ----
 extensions/libipt_addrtype.c   |   58 ++++++------
 extensions/libipt_unclean.c    |   16 ---
 extensions/libxt_CONNMARK.c    |   98 +++++++-------------
 extensions/libxt_CONNSECMARK.c |   18 +----
 extensions/libxt_DSCP.c        |   17 +---
 extensions/libxt_MARK.c        |  106 +++++++++-------------
 extensions/libxt_NFLOG.c       |   17 +---
 extensions/libxt_NFQUEUE.c     |   16 +---
 extensions/libxt_NOTRACK.c     |   33 +-------
 extensions/libxt_TCPOPTSTRIP.c |   18 +----
 extensions/libxt_TOS.c         |   76 ++++++---------
 extensions/libxt_TRACE.c       |   13 ---
 extensions/libxt_comment.c     |   17 +---
 extensions/libxt_connbytes.c   |   17 +---
 extensions/libxt_connlimit.c   |   60 ++++++------
 extensions/libxt_connmark.c    |   92 ++++++-------------
 extensions/libxt_conntrack.c   |   90 +++++++++---------
 extensions/libxt_dccp.c        |   17 +---
 extensions/libxt_dscp.c        |   17 +---
 extensions/libxt_esp.c         |   17 +---
 extensions/libxt_hashlimit.c   |  113 ++++++++++-------------
 extensions/libxt_helper.c      |   16 +---
 extensions/libxt_iprange.c     |   90 +++++++++---------
 extensions/libxt_mac.c         |   17 +---
 extensions/libxt_mark.c        |   60 ++++++------
 extensions/libxt_multiport.c   |  120 ++++++++++++-------------
 extensions/libxt_owner.c       |  106 +++++++++-------------
 extensions/libxt_physdev.c     |   17 +---
 extensions/libxt_policy.c      |   56 ++++++------
 extensions/libxt_recent.c      |   19 +----
 extensions/libxt_sctp.c        |   17 +---
 extensions/libxt_socket.c      |   20 ----
 extensions/libxt_standard.c    |   12 ---
 extensions/libxt_state.c       |   17 +---
 extensions/libxt_string.c      |   64 +++++++-------
 extensions/libxt_tcp.c         |   17 +---
 extensions/libxt_tcpmss.c      |   17 +---
 extensions/libxt_tos.c         |   76 ++++++---------
 extensions/libxt_udp.c         |   17 +---
 include/xtables.h.in           |    7 ++
 ip6tables.8.in                 |    3 +
 ip6tables.c                    |   76 ++++++++--------
 iptables.8.in                  |    7 +-
 iptables.c                     |   69 ++++++++-------
 xshared.c                      |   31 ++++++
 xshared.h                      |   10 ++
 xtables.c                      |  199 ++++++++++++++++++++++++++++++++++++++++
 52 files changed, 929 insertions(+), 1248 deletions(-)
 create mode 100644 xshared.c
 create mode 100644 xshared.h
