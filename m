From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/4] netfilter: minor cleanups and improvements
Date: Tue, 18 Feb 2014 18:06:46 +0000
Message-ID: <1392746810-22456-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62020 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaBRSHD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:07:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following four patches have been sitting in my tree for a while, I
need them as preconditions for following patches, but they also make
sense on their own, so I'd like to get rid of them.

The second patch adds a nfnl_dereference() helper, which is a wrapper
around rcu_dereference_protected() that checks that the nfnetlink
subsys mutex is actually held. This is similar to rtnl_dereference()
except that we need to check subsys-specific mutexes.

The first patch renamed a similar named ip_set function, the third patch
introduces a nft_dereference() macro that is to be used in nftables.

The fourth patch is unrelated to this, it changes verdict validation in
nftables to accept flags to NF_QUEUE or errno codes to NF_DROP.

Please apply.
