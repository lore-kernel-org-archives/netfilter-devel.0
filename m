From: Jan Engelhardt <jengelh@medozas.de>
Subject: xt_hashlimit: restore per-rule effectiveness
Date: Wed,  6 Oct 2010 08:28:41 +0200
Message-ID: <1286346523-9476-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47954 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200Ab0JFG2p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:28:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit eecc545856c8a0f27783a440d25f4ceaa1f95ce8:

  netfilter: add missing xt_log.h file (2010-10-04 23:24:21 +0200)

are available in the git repository at:
  git://dev.medozas.de/linux hashlimit

Jan Engelhardt (1):
      netfilter: xt_hashlimit: restore per-rule effectiveness

 net/netfilter/xt_hashlimit.c |   50 ++++++++++++++++++++++-------------------
 1 files changed, 27 insertions(+), 23 deletions(-)
