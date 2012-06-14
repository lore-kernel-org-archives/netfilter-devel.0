From: Florian Westphal <fw@strlen.de>
Subject: [xt-addons][PATCH 0/4] psd match cleanup patches
Date: Thu, 14 Jun 2012 22:13:30 +0200
Message-ID: <1339704814-1605-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41690 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756337Ab2FNUOq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:14:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following changes since commit 7cc774641a584803f66b643c9fede7a6bf2664b8:

  all: remove trailing squatspaces (2012-06-10 22:31:10 +0200)

are available in the git repository at:
  git://git.breakpoint.cc/fw/xtables-addons.git psd_cleanups

Florian Westphal (4):
      psd: rip out scanlogd leftovers
      psd: add basic validation of userspace matchinfo data
      psd: reduce size of struct host
      psd: move defines to user/kernelspace part where possible

 doc/changelog.txt      |    3 +-
 extensions/libxt_psd.c |   26 +++++++------
 extensions/xt_psd.c    |  100 +++++++++++++++++++++--------------------------
 extensions/xt_psd.h    |   11 -----
 4 files changed, 61 insertions(+), 79 deletions(-)

Patches will follow up as reply to this email.
