From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 0/4] Interval overlap detection for named sets
Date: Sat, 23 Apr 2016 18:08:36 +0200
Message-ID: <1461427720-4939-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33747 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbcDWQIv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Apr 2016 12:08:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 054C8114812
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EC0AB9D119
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C3ADB9D119
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Apr 2016 18:08:45 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset adds the missing code to reject overlapping intervals.

 # nft add table ip filter
 # nft add set ip filter myset { type ipv4_addr\; flags interval\; }
 # nft add chain ip filter output { type filter hook output priority 0\; }
 # nft add rule ip daddr @myset counter packets 0 bytes 0
 # nft add element ip filter myset { 127.0.0.0/16 }

Then, if you add an overlapping element:

 # nft add element ip filter myset { 127.0.0.0/24 }
 <cmdline>:1:31-42: Error: interval overlaps with an existing one
 add element ip filter myset { 127.0.0.0/24 }
                               ^^^^^^^^^^^^

The new validation code from userspace rejects this to avoid shadowing
issues.

Pablo Neira Ayuso (4):
  segtree: set expr->len for prefix expression from interval_map_decompose()
  segtree: add expr_to_intervals()
  segtree: rename set expression set_to_segtree()
  segtree: add interval overlap detection for dynamic updates

 src/segtree.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 80 insertions(+), 12 deletions(-)

-- 
2.1.4

