From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH v2] netfilter: payload mangling
Date: Tue, 24 Nov 2015 10:00:21 +0000
Message-ID: <1448359222-5509-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:44373 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752744AbbKXKA2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 05:00:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following is the latest version of the payload mangling patch. Changes
to the last version are:

* Make checksum updates optional, required for some protocols

* Fix mangling headers before skb->data. Previously skb_make_writable() would
  fail due to negative lengths.

* Add new struct for set operation to avoid bloating the regular payload struct

The patch has been tested with headers on all header bases.

The last remaining question is how to react to failure. For data loading
expressions we simply NFT_BREAK, which is reasonable since they're used in
match like constructs.

For statements that are actions on the packet, I'd say we should drop the
packet if the action fails. However we don't do this so far anywhere else,
so I wanted to bring it up first since it might also be relevant for other
actions, "ct" comes to mind.


Patrick McHardy (1):
  netfilter: nft_payload: add packet mangling support

 include/net/netfilter/nf_tables_core.h   |   9 +++
 include/uapi/linux/netfilter/nf_tables.h |  17 ++++
 net/netfilter/nft_payload.c              | 135 +++++++++++++++++++++++++++++--
 3 files changed, 155 insertions(+), 6 deletions(-)

-- 
2.5.0

