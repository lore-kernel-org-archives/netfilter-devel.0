From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v5 nf-next 0/4] netfilter: nftables: add connlabel set support
Date: Tue, 12 Apr 2016 18:14:22 +0200
Message-ID: <1460477666-17823-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37351 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbcDLQOM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 12:14:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

This is round 5 of the connlabel set support set.
I'm only sending the kernel patches for now.

First 4 patches are preparation changes, patch #4 adds set support.
I added a more generic CT_IMM nested attr that expects a nft_data struct.

Its up to the kernel to (using the key) to figure out how to interpret it.
This approach is hopefully generic enough so it can be re-used for other
set options that want to use an immediate value.

Florian Westphal (4):
      netfilter: connlabels: move helpers to xt_connlabel
      netfilter: labels: don't emit ct event if labels were not changed
      netfilter: connlabels: change nf_connlabels_get bit arg to 'highest used'
      netfilter: nftables: add connlabel set support

 include/net/netfilter/nf_conntrack_labels.h |    5 -
 include/uapi/linux/netfilter/nf_tables.h    |    2 
 net/netfilter/nf_conntrack_labels.c         |   44 +++++----------
 net/netfilter/nft_ct.c                      |   78 ++++++++++++++++++++++++++--
 net/netfilter/xt_connlabel.c                |   14 ++++-
 net/openvswitch/conntrack.c                 |    2 
 6 files changed, 108 insertions(+), 37 deletions(-)

