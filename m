From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: guided option parser, run 4
Date: Sun,  1 May 2011 13:50:20 +0200
Message-ID: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49992 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1EALuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 May 2011 07:50:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 26ed9ea93564bb5ffdb5238eaa202cd9bcf6d6d1:

  combine ip6?tables-multi into xtables-multi (2011-04-19 18:22:11 -0700)

are available in the git repository at:
  git://dev.medozas.de/iptables opts

Jan Engelhardt (9):
      build: bump libxtables ABI version
      libxt_TEE: use guided option parser
      xtoptions: respect return value in xtables_getportbyname
      libxt_TOS: use guided option parser
      libxt_tos: use guided option parser
      extensions: remove unused TOS code
      libxtables: XTTYPE_PORTRC support
      libxt_udp: use guided option parser
      libxt_dccp: use guided option parser

 configure.ac            |    2 +-
 extensions/libxt_TEE.c  |  103 +++++-----------------------------
 extensions/libxt_TOS.c  |  137 +++++++++++++++++++--------------------------
 extensions/libxt_dccp.c |  134 +++++++++++++-------------------------------
 extensions/libxt_tos.c  |   88 +++++++++++------------------
 extensions/libxt_udp.c  |   95 ++++++++++---------------------
 extensions/tos_values.c |   58 -------------------
 include/xtables.h.in    |   11 +++-
 xtoptions.c             |  142 +++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 327 insertions(+), 443 deletions(-)
