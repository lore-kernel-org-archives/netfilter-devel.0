From: Jan Engelhardt <jengelh@medozas.de>
Subject: [pull] all patches complete
Date: Fri, 13 Feb 2009 16:45:15 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902131642300.17695@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34262 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZBMPpU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:45:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



All patches have been gathered and collected, pullable at the usual 
place of
	git://dev.medozas.de/iptables master

with contents:
Jamal Hadi Salim (5):
      libxtables: set names of programs
      libxtables: add xtables_set_revision
      libxtables: make iptables and ip6tables use xtables_free_opts
      libxtables: consolidate merge_options into xtables_merge_options
      libxtables: consolidate init calls into one function

Jan Engelhardt (4):
      libipq: add missing doc for NF_ values
      build: restructure Makefile for include/ directory
      libipq: fix compile error
      build: remove unneeded -ldl from iptables_xml_LDADD

Marc Fournier (1):
      doc: fix option typo in libxt_multiport

Shaul Karl (1):
      doc: fix one layout issue in iptables-restore.8


 Makefile.am                    |    8 ++--
 configure.ac                   |    3 +-
 extensions/libxt_multiport.man |    4 +-
 include/Makefile.am            |    8 +++
 include/ip6tables.h            |    2 +
 include/iptables.h             |    2 +
 include/xtables.h.in           |    9 +++-
 ip6tables-restore.c            |   10 +++-
 ip6tables-save.c               |   10 +++-
 ip6tables-standalone.c         |   11 ++++-
 ip6tables.c                    |   70 ++++------------------------
 iptables-restore.8             |    1 -
 iptables-restore.c             |   10 +++-
 iptables-save.c                |   10 +++-
 iptables-standalone.c          |   10 +++-
 iptables.c                     |   76 +++++--------------------------
 libipq/Makefile.am             |    1 -
 libipq/ipq_set_verdict.3       |    7 +++
 libipq/libipq.c                |    2 +
 xtables.c                      |   99 +++++++++++++++++++++++++++++-----------
 20 files changed, 180 insertions(+), 173 deletions(-)
