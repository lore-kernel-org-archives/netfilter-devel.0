From: Jan Engelhardt <jengelh@medozas.de>
Subject: June 11 iptables pull
Date: Thu, 11 Jun 2009 13:11:17 +0200
Message-ID: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38292 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762727AbZFKLLX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:11:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


a couple more fixes to the iptables proper. Please pull from
the "stable" branch at
	git://dev.medozas.de/iptables stable

to receive

Frank Tobin (1):
      libxt_tcp: fix a manpage syntax typo

Ian Bruce (1):
      libxt_tcp: manpage corrections and suggestions

Jan Engelhardt (2):
      iptables: close open file descriptors
      manpages: markup corrections

kd6lvw (1):
      libxt_connlimit: initialize v6_mask


 extensions/libxt_TCPMSS.man    |    5 ++---
 extensions/libxt_TPROXY.man    |    2 +-
 extensions/libxt_cluster.man   |   38 +++++++++++++++++++-------------------
 extensions/libxt_connlimit.c   |    4 +++-
 extensions/libxt_connlimit.man |    2 +-
 extensions/libxt_recent.man    |    4 ++--
 extensions/libxt_tcp.man       |    6 +++---
 ip6tables-restore.c            |    2 ++
 ip6tables-save.c               |    1 +
 iptables-restore.c             |    2 ++
 iptables-save.c                |    1 +
 iptables-xml.c                 |    2 ++
 12 files changed, 39 insertions(+), 30 deletions(-)
