From: Hongxu Jia <hongxu.jia@windriver.com>
Subject: [PATCH] netfilter: arp_tables: fix invoking 32bit "iptable -P INPUT ACCEPT" failed in 64bit kernel
Date: Tue, 29 Nov 2016 21:56:26 -0500
Message-ID: <1480474586-205429-1-git-send-email-hongxu.jia@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <netfilter-devel@vger.kernel.org>
To: <fw@strlen.de>, <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:56120 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753751AbcK3C44 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 21:56:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since the following commit applied in kernel (https://git.kernel.org/cgit/
linux/kernel/git/torvalds/linux.git/commit/?id=09d9686047dbbe1cf4faa558d3ecc4aae2046054)
--------------------------------------
commit 09d9686047dbbe1cf4faa558d3ecc4aae2046054
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Apr 1 14:17:34 2016 +0200

    netfilter: x_tables: do compat validation via translate_table
--------------------------------------
It used compatr structure to assign newinfo structure.
In translate_compat_table of ip_tables.c and ip6_tables.c, it used
compatr->hook_entry to replace info->hook_entry and
compatr->underflow to replace info->underflow, but not do the same
replacement in arp_tables.c.

It caused invoking 32-bit "arptbale -P INPUT ACCEPT" failed in 64bit kernel.
--------------------------------------
root@qemux86-64:~# arptables -P INPUT ACCEPT
root@qemux86-64:~# arptables -P INPUT ACCEPT
ERROR: Policy for `INPUT' offset 448 != underflow 0
arptables: Incompatible with this kernel
--------------------------------------

Signed-off-by: Hongxu Jia <hongxu.jia@windriver.com>
---
 net/ipv4/netfilter/arp_tables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b31df59..6975384 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1201,8 +1201,8 @@ static int translate_compat_table(struct xt_table_info **pinfo,
 
 	newinfo->number = compatr->num_entries;
 	for (i = 0; i < NF_ARP_NUMHOOKS; i++) {
-		newinfo->hook_entry[i] = info->hook_entry[i];
-		newinfo->underflow[i] = info->underflow[i];
+		newinfo->hook_entry[i] = compatr->hook_entry[i];
+		newinfo->underflow[i] = compatr->underflow[i];
 	}
 	entry1 = newinfo->entries;
 	pos = entry1;
-- 
2.8.1

