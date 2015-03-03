From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] netfilter: nf_tables fixes
Date: Tue,  3 Mar 2015 20:04:17 +0000
Message-ID: <1425413060-6187-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbbCCUEZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 15:04:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm starting to push over my nftables set patches, as a first
batch these three patches fix some bugs I noticed in the process:

* a race condition in the transaction code
* a possible rule dlen overflow
* a possible userdata ulen overflow

Since they will probably go through nf.git and I also require them
in nf-next.git for my following patches, I'd appreciate if you
could merge them into nf-next as soon as possible.

Thanks!


Patrick McHardy (3):
      netfilter: nf_tables: fix transaction race condition
      netfilter: nf_tables: check for overflow of rule dlen field
      netfilter: nf_tables: fix userdata length overflow

 include/net/netfilter/nf_tables.h | 22 +++++++++++++++++++---
 net/netfilter/nf_tables_api.c     | 34 ++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 13 deletions(-)

