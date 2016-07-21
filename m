From: Florian Westphal <fw@strlen.de>
Subject: netfilter: connlabels: get rid of variable-size support
Date: Thu, 21 Jul 2016 12:51:15 +0200
Message-ID: <1469098277-1227-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57280 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbcGUKvB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 06:51:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As discussed earlier, lets make the current 128bit upper size
the fixed standard size.

It allows to get rid of a few run-time tests and also reduces
needed extension size with both openvswitch and nftables.

While at it, also move a helper that is only needed by the
xt_connlabel match there.  Originally I kept this in the core
because it wasn't yet clear if nft would needed it later.

 include/net/netfilter/nf_conntrack_labels.h |   18 +++--------------
 net/netfilter/nf_conntrack_labels.c         |   28 +--------------------------
 net/netfilter/nf_conntrack_netlink.c        |   10 ++++-----
 net/netfilter/nft_ct.c                      |   13 ++----------
 net/netfilter/xt_connlabel.c                |   29 +++++++++++++++-------------
 net/openvswitch/conntrack.c                 |    4 +--
 6 files changed, 32 insertions(+), 70 deletions(-)

