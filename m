From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/4] nf_tables: basic dynamic support for set intervals
Date: Tue, 12 Apr 2016 23:50:33 +0200
Message-ID: <1460497837-20693-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59296 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933609AbcDLVuv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 17:50:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6BF35E664C
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 547811B30B5
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 972C21B3065
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:50:43 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset resolves the main issues with the dynamic support for
range and its existing rb-tree implementation.

-ruleset.file-
table ip test {
        set myset {
                type ipv4_addr
                flags interval
        }

        chain input {
                type filter hook input priority 0; policy accept;
                ip daddr @myset counter packets 0 bytes 0
        }
}
-EOF-

 # nft -f ruleset.file

Then, we add range elements:

 # nft add element test myset { 127.0.0.0/24 }
 # nft add element test myset { 127.0.1.0/24 }
 # nft add element test myset { 127.0.2.0/24 }
 # nft add element test myset { 127.0.3.0/24 }

 # nft list set ip test myset
 table ip test {
        set myset {
                type ipv4_addr
                flags interval
                elements = { 127.0.0.0/24, 127.0.1.0/24, 127.0.2.0/24, 127.0.3.0/24}
        }
 }

 # nft delete element test myset { 127.0.2.0/24 }
 # nft delete element test myset { 127.0.1.0/24 }
 # nft delete element test myset { 127.0.0.0/24 }
 # nft delete element test myset { 127.0.3.0/24 }

 # nft list set ip test myset
 table ip test {
        set myset {
                type ipv4_addr
                flags interval
        }
 }

There is more work coming on this front, the bitmap set implementation
is on its way too. Will post the userspace patchset for nft soon.

Pablo Neira Ayuso (4):
  netfilter: nf_tables: introduce nft_setelem_parse_flags() helper
  netfilter: nf_tables: parse element flags from nft_del_setelem()
  netfilter: nft_rbtree: introduce nft_rbtree_interval_end() helper
  netfilter: nft_rbtree: allow adjacent intervals with dynamic updates

 net/netfilter/nf_tables_api.c | 72 +++++++++++++++++++++++++++++++++----------
 net/netfilter/nft_rbtree.c    | 49 ++++++++++++++++++++++++-----
 2 files changed, 96 insertions(+), 25 deletions(-)

-- 
2.1.4

