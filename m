From: Patrick McHardy <kaber@trash.net>
Subject: patch 00/02: netfilter / textsearch fixes
Date: Mon, 30 Jun 2008 17:56:09 +0200 (MEST)
Message-ID: <20080630155609.24326.34250.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39797 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYF3P4M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:56:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

these two patches fix an off-by-one if the TCP window tracking ACK sequence
validation, leading to incorrectly marked INVALID packets, and another
off-by-one in the Boyer-Moore text search algorithm. Both are also candidates
for -stable which I'll pass on once they hit upstream.

Please apply, thanks.


 lib/ts_bm.c                            |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c |   13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

Joonwoo Park (1):
      textsearch: fix Boyer-Moore text search bug

Jozsef Kadlecsik (1):
      netfilter: nf_conntrack_tcp: fixing to check the lower bound of valid ACK
