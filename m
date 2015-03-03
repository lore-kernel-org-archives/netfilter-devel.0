From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] netfilter: nf_tables cleanups
Date: Tue,  3 Mar 2015 20:10:03 +0000
Message-ID: <1425413406-6804-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44979 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbCCUKK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Mar 2015 15:10:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches for -next contain some cleanups which are not directly
related to the following set patches, so I'm sending them seperately
for easier review:

 * move the reoccuring checks for skb->nf_trace to an inline function
 * consolidate similar invocations of nft_trace_packet()
 * rearrange nf_tables.h so related things are next to each other

Please apply, thanks!


Patrick McHardy (3):
      netfilter: nf_tables: minor tracing cleanups
      netfilter: nf_tables: consolidate tracing invocations
      netfilter: nf_tables: cleanup nf_tables.h

 include/net/netfilter/nf_tables.h | 174 +++++++++++++++++++-------------------
 net/netfilter/nf_tables_core.c    | 105 +++++++++++------------
 2 files changed, 138 insertions(+), 141 deletions(-)

