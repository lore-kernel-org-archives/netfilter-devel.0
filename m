From: Jan Engelhardt <jengelh@medozas.de>
Subject: Manpage updates for iptables
Date: Thu, 20 Aug 2009 17:09:34 +0200
Message-ID: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40278 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbZHTPJn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:09:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 8e4dacaed17701cb1891b962bb856e0e8cfbb5c8:
  Jan Engelhardt (1):
        Merge branch 'stable'

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (2):
      length: support semi-infinite length description
      manpages: more fixes to minuses, hyphens, dashes

Laurence J. Lane (1):
      manpage: fix lintian warnings

Trent W. Buck (1):
      ipt_set: fix a typo in the manpage

 extensions/libipt_set.man      |    2 +-
 extensions/libxt_NFLOG.man     |    2 +-
 extensions/libxt_TOS.man       |    2 +-
 extensions/libxt_connbytes.man |    2 +-
 extensions/libxt_length.c      |   18 +++++++++++-------
 extensions/libxt_length.man    |   13 ++++++++++---
 ip6tables-restore.8            |    7 +++----
 ip6tables-save.8               |    4 ++--
 ip6tables.8.in                 |    6 +++---
 iptables-restore.8             |    7 +++----
 iptables-save.8                |    4 ++--
 iptables-xml.8                 |   10 ++++------
 iptables.8.in                  |    6 +++---
 libipq/ipq_create_handle.3     |    4 ++--
 libipq/ipq_errstr.3            |    2 +-
 libipq/ipq_message_type.3      |    2 +-
 libipq/ipq_read.3              |    4 ++--
 libipq/ipq_set_mode.3          |    4 ++--
 libipq/ipq_set_verdict.3       |    4 ++--
 libipq/libipq.3                |    4 ++--
 20 files changed, 57 insertions(+), 50 deletions(-)
