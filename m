From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 00/11][xt-addons] xt_psd: ipv6 support
Date: Sun, 16 Sep 2012 23:29:44 +0200
Message-ID: <1347830995-19226-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33801 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab2IPVca (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 17:32:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following changes since commit 35ce1adf5ee4e8efd91d11b0dd107d51610b82cc:

  Xtables-addons 1.46 (2012-08-23 15:54:21 +0200)

are available in the git repository at:
  git://git.breakpoint.cc/fw/xtables-addons.git psd_10

Florian Westphal (11):
      xt_psd: consider protocol when searching port list
      xt_psd: move parts of main match function to helpers
      xt_psd: avoid if (c=h) do {..} while (c = c->next)
      xt_psd: move match functionality to helpers
      xt_psd: remove unneeded variables
      xt_psd: split struct host into generic and af-dependent structure
      xt_psd: move table cleanup into helper
      xt_psd: use tcph->dest directly
      xt_psd: move l4 header fetching into helper
      xt_psd: move ipv4 state locking responsibility to caller
      psd: add ipv6 support

 extensions/libxt_psd.c |    2 +-
 extensions/xt_psd.c    |  560 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 405 insertions(+), 157 deletions(-)
gIT: [PATCH 11/11] psd: add ipv6 support
