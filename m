From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: connlimit dstaddr support
Date: Wed, 19 Jan 2011 18:32:25 +0100
Message-ID: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40834 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab1ASRcc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:32:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 9c60365e043a430f74115bbfaf58ce0df7585f49:

  libxt_quota: print negation when it has been selected (2011-01-18 11:02:04 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      libxt_connlimit: reword help text to say prefix length
      libxt_connlimit: add a --connlimit-upto option
      libxt_connlimit: support for dstaddr-supporting revision 1

 extensions/libxt_connlimit.c           |  157 ++++++++++++++++++++++++--------
 extensions/libxt_connlimit.man         |   26 ++++-
 include/linux/netfilter/xt_connlimit.h |   14 +++-
 3 files changed, 152 insertions(+), 45 deletions(-)
