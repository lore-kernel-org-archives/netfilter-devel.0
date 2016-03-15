From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: [PATCH v2] nft: Remove memory-leak
Date: Tue, 15 Mar 2016 08:37:41 +0530
Message-ID: <20160315030741.GA3900@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33160 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932070AbcCODHb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 23:07:31 -0400
Received: by mail-pf0-f196.google.com with SMTP id x3so754497pfb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Mar 2016 20:07:31 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added matching xfree calls in chain_free(), for the chain members 'type' and
'dev'.

It can be reproduced by :
$ nft <commands>
$ nft -i

For example :
$ sudo valgrind --leak-check=full nft list tables

==2899== HEAP SUMMARY:
==2899==     in use at exit: 327 bytes in 10 blocks
==2899==   total heap usage: 145 allocs, 135 frees, 211,462 bytes allocated
==2899==
==2899== 63 bytes in 9 blocks are definitely lost in loss record 1 of 2
==2899==    at 0x4C2AB80: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==2899==    by 0x57A3839: strdup (strdup.c:42)
==2899==    by 0x41C05D: xstrdup (utils.c:64)
==2899==    by 0x411E9B: netlink_delinearize_chain.isra.3 (netlink.c:717)
==2899==    by 0x411F70: list_chain_cb (netlink.c:748)
==2899==    by 0x504A943: nft_chain_list_foreach (chain.c:1015)
==2899==    by 0x4145AE: netlink_list_chains (netlink.c:771)
==2899==    by 0x40793F: cache_init_objects (rule.c:90)
==2899==    by 0x40793F: cache_init (rule.c:130)
==2899==    by 0x40793F: cache_update (rule.c:147)
==2899==    by 0x40FB59: cmd_evaluate (evaluate.c:2475)
==2899==    by 0x429A1C: nft_parse (parser_bison.y:655)
==2899==    by 0x40651C: nft_run (main.c:231)
==2899==    by 0x40618C: main (main.c:357)
==2899==
==2899== LEAK SUMMARY:
==2899==    definitely lost: 63 bytes in 9 blocks
==2899==    indirectly lost: 0 bytes in 0 blocks
==2899==      possibly lost: 0 bytes in 0 blocks
==2899==    still reachable: 264 bytes in 1 blocks
==2899==         suppressed: 0 bytes in 0 blocks
==2899== Reachable blocks (those to which a pointer was found) are not shown.
==2899== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==2899==
==2899== For counts of detected and suppressed errors, rerun with: -v
==2899== Use --track-origins=yes to see where uninitialised values come from
==2899== ERROR SUMMARY: 4 errors from 2 contexts (suppressed: 0 from 0)

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
v2:
	- Added valgrind output, as suggested by Pablo Neira Ayuso.

 src/rule.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 0b78549..85987b9 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -510,6 +510,9 @@ void chain_free(struct chain *chain)
 		rule_free(rule);
 	handle_free(&chain->handle);
 	scope_release(&chain->scope);
+	xfree(chain->type);
+	if (chain->dev != NULL)
+		xfree(chain->dev);
 	xfree(chain);
 }
 
-- 
1.9.1


-- 

With regards,
Piyush Pangtey <gokuvsvegita@gmail.com>
