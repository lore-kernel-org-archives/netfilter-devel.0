From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables fixes 2011-08-26
Date: Fri, 26 Aug 2011 15:15:10 +0200
Message-ID: <1314364516-7875-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41478 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495Ab1HZNRy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Aug 2011 09:17:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 4a56bcbd49ef20a0203017c15ab1cec9bb14=
0d1a:

  libxt_hashlimit: observe new default gc-expire time when saving (2011=
-08-21 13:04:40 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables fixes

=46ernando Luis V=C3=A1zquez Cao (1):
      libxt_TOS: update linux kernel version list for backported fix

Jan Engelhardt (4):
      libxt_string: simplify hex output routine
      libxt_string: replace hex codes by char equivalents
      src: remove unused IPTABLES_MULTI define
      libxt_string: escape the escaping char too

 extensions/libxt_TOS.man        |    8 ++++----
 extensions/libxt_string.c       |   15 +++++----------
 iptables/Makefile.am            |    2 +-
 iptables/ip6tables-restore.c    |    4 ----
 iptables/ip6tables-save.c       |    4 ----
 iptables/ip6tables-standalone.c |    5 -----
 iptables/iptables-restore.c     |    5 -----
 iptables/iptables-save.c        |    5 -----
 iptables/iptables-standalone.c  |    5 -----
 iptables/iptables-xml.c         |    9 ---------
 tests/options-most.rules        |    4 ++++
 11 files changed, 14 insertions(+), 52 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
