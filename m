From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: libxt_TEE
Date: Mon, 19 Apr 2010 14:48:40 +0200
Message-ID: <1271681322-29994-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40401 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab0DSMsp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:48:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit db6d027bb9626129617ea3a3f2fe4b87ab307bf6:
  Jan Engelhardt (1):
        libxt_osf: import nfnl_osf program

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      extensions: add support for xt_TEE

 extensions/libxt_TEE.c           |  202 ++++++++++++++++++++++++++++++++++++++
 extensions/libxt_TEE.man         |   12 +++
 include/linux/netfilter/xt_TEE.h |    9 ++
 3 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_TEE.c
 create mode 100644 extensions/libxt_TEE.man
 create mode 100644 include/linux/netfilter/xt_TEE.h
