From: Jan Engelhardt <jengelh@medozas.de>
Subject: xtables: connlimit with dstaddr support
Date: Wed, 19 Jan 2011 18:31:30 +0100
Message-ID: <1295458292-13884-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40811 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab1ASRbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:31:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 93557f53e1fbd9e2b6574ab0a9b5852628fde9e3:

  netfilter: nf_conntrack: nf_conntrack snmp helper (2011-01-18 18:12:24 +0100)

are available in the git repository at:
  git://dev.medozas.de/linux connlimit

Jan Engelhardt (1):
      netfilter: xtables: connlimit revision 1

 Documentation/feature-removal-schedule.txt |    7 ++++
 include/linux/netfilter/xt_connlimit.h     |   12 +++++++
 net/netfilter/xt_connlimit.c               |   44 +++++++++++++++++++---------
 3 files changed, 49 insertions(+), 14 deletions(-)
