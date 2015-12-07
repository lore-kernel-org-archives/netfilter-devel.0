From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/3] netfilter: nftables: add set support for conntrack labels
Date: Mon,  7 Dec 2015 13:05:05 +0100
Message-ID: <1449489908-10205-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37328 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754620AbbLGMFM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Dec 2015 07:05:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

make "add rule filter input ct label set ct label | bar" work.

First patch is a cleanup and moves xt specific code to xt_connlabel.

Second patch is a fix to the clabel replace function to not emit
an event in case old and new are the same (this isn't a problem
for xtables since it doesn't use nf_connlabels_replace).

Last patch adds nft_ct set support.

Let me know if you spot any problems with this approach.
I'm especially interested in the userspace side, see patch
#3 for example.

 include/net/netfilter/nf_conntrack_labels.h |    3 -
 net/netfilter/nf_conntrack_labels.c         |   50 +++++-----------------------
 net/netfilter/nft_ct.c                      |   31 +++++++++++++++++
 net/netfilter/xt_connlabel.c                |   38 ++++++++++++++++++++-
 4 files changed, 77 insertions(+), 45 deletions(-)

