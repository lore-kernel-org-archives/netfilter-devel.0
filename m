From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/2] netfilter: helper set support
Date: Wed,  8 Mar 2017 16:48:42 +0100
Message-ID: <20170308154844.18065-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37680 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753769AbdCHQSM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:18:12 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support to set the conntrack helper from nftables, using
nft set ct helper "foo" syntax.

Helpers are defined through the objref infrastructure.

Open question: should NFT_MSG_GETOBJ_RESET get rejected for this new type?

A future patch could extend the attributes so we can also handle module
specific settings, such as ftp loose mode, or configure the number of
allowed expectations.

 include/net/netfilter/nf_tables.h        |    3 ++-
 include/net/netfilter/nf_tables.h        |    3 
 include/uapi/linux/netfilter/nf_tables.h |   12 +-
 net/netfilter/nf_tables_api.c            |    7 -
 net/netfilter/nft_counter.c              |    3 
 net/netfilter/nft_ct.c                   |  171 +++++++++++++++++++++++++++++++
 net/netfilter/nft_quota.c                |    3 
 6 files changed, 192 insertions(+), 7 deletions(-)
