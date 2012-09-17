From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 0/7][xt-addons] xt_psd: ipv6 support
Date: Mon, 17 Sep 2012 14:55:16 +0200
Message-ID: <1347886523-19356-1-git-send-email-fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35812 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206Ab2IQMx1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2012 08:53:27 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.72)
	(envelope-from <fw@breakpoint.cc>)
	id 1TDapK-0000In-Lu
	for netfilter-devel@vger.kernel.org; Mon, 17 Sep 2012 14:53:26 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changes since v1:
- rebased on top of xt-addons.git psd branch
- patch1: convert all int hash declarations to unsigned int
- patch7: use if (foo != NULL) instead of (!foo) where appropriate

There are no other changes.

The following changes since commit 093f3b0a975d2be97ba33426ceead8d205bca2f6:

  xt_psd: move match functionality to helpers (2012-09-17 04:44:29 +0200)

are available in the git repository at:
  git://git.breakpoint.cc/fw/xtables-addons.git psd_12

Florian Westphal (7):
      xt_psd: remove unneeded variables, make hash unsigned
      xt_psd: split struct host into generic and af-dependent structure
      xt_psd: move table cleanup into helper
      xt_psd: use tcph->dest directly
      xt_psd: move l4 header fetching into helper
      xt_psd: move ipv4 state locking responsibility to caller
      psd: add ipv6 support

 extensions/libxt_psd.c |    2 +-
 extensions/xt_psd.c    |  463 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 340 insertions(+), 125 deletions(-)
