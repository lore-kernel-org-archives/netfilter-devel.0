From: tcharding <me@tobin.cc>
Subject: [PATCH 0/3] bridge: netfilter: checkpatch fixes
Date: Tue, 10 May 2016 11:26:55 +1000
Message-ID: <1462843618-21914-1-git-send-email-me@tobin.cc>
Cc: Tobin C Harding <me@tobin.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:33333 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752990AbcEJB1H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2016 21:27:07 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by mailout.nyi.internal (Postfix) with ESMTP id 41AA520909
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 21:27:05 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Tobin C Harding <me@tobin.cc>

checkpatch produces 32 'checks'. This patch set amends them all.

Patch one is white space only.
Patch two changes data types e.g uint8_t -> u8.
Patch three amends comparison to null.

Tobin C Harding (3):
  bridge: netfilter: checkpatch whitespace fixes
  bridge: netfilter: checkpatch data type fixes
  bridge: netfilter: checkpatch null comparison fixes

 net/bridge/netfilter/ebt_stp.c | 68 +++++++++++++++++++++---------------------
 1 file changed, 34 insertions(+), 34 deletions(-)

-- 
2.8.2

