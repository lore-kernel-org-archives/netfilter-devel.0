From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nf-next 0/1] payload mangling support
Date: Mon,  9 Nov 2015 14:10:33 +0000
Message-ID: <1447078234-21628-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:48345 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667AbbKIOKi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 09:10:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch adds support for payload mangling. It supports updating
all fields except those included in pseudo headers since it only supports a
single checksum update operation. So it can not be used for stateless NAT.

Checksum updates currently only support internet checksums and assume the
mangled data is actually covered by the checksum. Userspace only allows use
for these protocols.

So the main questions is basically, do we want to support stateless NAT?
The downside is that we have to add protocol specific checksumming functions.


Patrick McHardy (1):
  netfilter: nft_payload: add packet mangling support

 include/net/netfilter/nf_tables_core.h   |   1 +
 include/uapi/linux/netfilter/nf_tables.h |   4 ++
 net/netfilter/nft_payload.c              | 116 +++++++++++++++++++++++++++++--
 3 files changed, 115 insertions(+), 6 deletions(-)

-- 
2.5.0

