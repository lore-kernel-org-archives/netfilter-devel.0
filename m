From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/5] netfilter: nf_tables: assorted patches
Date: Sat, 21 Mar 2015 15:19:13 +0000
Message-ID: <1426951158-18168-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46419 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbbCUPTW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Mar 2015 11:19:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

following are five more or less assorted patches for nf_tables:

* fix for a minor locking issue in nft_rbtree
* move the struct net pointer from the chain to the base chain
* check for invalid NFT_SET_ELEM_INTERVAL_END centrally
* restruct struct nft_hash as preparation for following patches
* minor indentation cleanup for nft_hash

I'm sending these patches seperately from the main set changes to ease
review. Regarding the nft_rbtree fix, I'll provide a backport for
nf.git seperately.

Please apply, thanks!
