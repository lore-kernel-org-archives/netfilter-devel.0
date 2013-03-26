From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [RFC] Atomic rule manipulation part of transactions
Date: Tue, 26 Mar 2013 12:19:03 +0200
Message-ID: <1364293144-4147-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, pablo@netfilter.org,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49393 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab3CZKTM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:19:12 -0400
In-Reply-To: <1362092898-23306-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I took the patch "[PATCH 1/2] netfilter: nf_tables: partially rework commit and abort operation" of Pablo and quickly did the changes on top of it.

Basically if you need to do atomic rule manipulation, it will go in a transaction (like on a database).
And it's enabled per-nfnetlink connection. Any connection should be able to do such manipulation.
For that, I used the struct sock { sk_user_data } attribute... Afaik, nothing is using it on nfnetlink, so it looks safe to use it.
But if it should not be used, due to some reasons, let's find another way.

It remove the rule flags as well. It always sounded weird to add such flags, and the commit flag was just semantically wrong.

Besides that, I have a question about style issue: what naming rule is applied if the functions is static and not exposed anywhere?
For instance static function exposed as struct nfnl_callback callbacks are always following nf_tables_ prefix
But what about other functions? I have seen some with __nf_tables, nft_  or nf_tables_ ... 

It's a proposal, not a patch since it's made on top of previous patch proposal.

Please review,

Tomasz Bursztyka (1):
  nf_tables: Transaction API proposal

 include/net/netfilter/nf_tables.h        |   9 ++
 include/uapi/linux/netfilter/nf_tables.h |  11 +-
 net/netfilter/nf_tables_api.c            | 170 +++++++++++++++++--------------
 3 files changed, 106 insertions(+), 84 deletions(-)

-- 
1.8.1.5

