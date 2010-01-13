From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6] ulogd2 updates for NFCT
Date: Wed, 13 Jan 2010 12:42:00 +0100
Message-ID: <20100113114009.12994.26386.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37063 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab0AMLsV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:48:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset includes a set of updates for ulogd2's NFCT plugin.
I'm posting them here since there are other involved in the ulogd2
development, to let them know.

If nobody complains, I'll push it in some days.

---

Pablo Neira Ayuso (6):
      NFCT: cleanup constructor and destructor functions
      NFCT: change `pollinterval' behaviour
      NFCT: use new hashtable implementation for better performance
      NFCT: split event handler if hashtable is used or not
      NFCT: fix number of options (missing one)
      NFCT: fix reset counters via SIGUSR2 signal


 include/ulogd/hash.h            |   34 +--
 input/flow/ulogd_inpflow_NFCT.c |  430 ++++++++++++++++++++++++++++++---------
 src/hash.c                      |  168 +++++----------
 ulogd.conf.in                   |    1 
 4 files changed, 402 insertions(+), 231 deletions(-)
