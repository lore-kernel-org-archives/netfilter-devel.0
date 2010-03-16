From: Jan Engelhardt <jengelh@medozas.de>
Subject: Three patches for iptables
Date: Tue, 16 Mar 2010 20:02:16 +0100
Message-ID: <1268766140-28435-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33731 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933648Ab0CPTCW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:02:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 9fdbaa71452edaac9d5906716c15937f670341fa:
  Patrick McHardy (1):
        extensions: add CT extension

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      libxt_comment: avoid use of IPv4-specific examples
      libxt_CT: add a manpage
      iptables: correctly check for too-long chain/target/match names

 extensions/libxt_CT.c        |    2 +-
 extensions/libxt_CT.man      |   25 +++++++++++++++++++++++++
 extensions/libxt_comment.man |    2 +-
 ip6tables-restore.c          |    6 ++++++
 ip6tables.c                  |    4 ++--
 iptables-restore.c           |    6 ++++++
 iptables.c                   |    4 ++--
 xtables.c                    |    5 +++++
 8 files changed, 48 insertions(+), 6 deletions(-)
 create mode 100644 extensions/libxt_CT.man
