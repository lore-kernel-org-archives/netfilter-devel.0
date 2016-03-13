From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: [RFC] nft: Remove memory-leak
Date: Sun, 13 Mar 2016 17:38:43 +0530
Message-ID: <20160313120843.GA6919@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34161 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbcCMMIg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 08:08:36 -0400
Received: by mail-pf0-f179.google.com with SMTP id x3so22131378pfb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2016 05:08:28 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Memory leak due to the absence of matching free :
==4797== 189 bytes in 27 blocks are definitely lost in loss record 22 of 51
==4797==    at 0x4C2AB80: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==4797==    by 0x57A3839: strdup (strdup.c:42)
==4797==    by 0x41C00D: xstrdup (utils.c:64)
==4797==    by 0x411E4B: netlink_delinearize_chain.isra.3 (netlink.c:717)
==4797==    by 0x411F20: list_chain_cb (netlink.c:748)
==4797==    by 0x504A943: nft_chain_list_foreach (chain.c:1015)
==4797==    by 0x41455E: netlink_list_chains (netlink.c:771)
==4797==    by 0x4078EF: cache_init_objects (rule.c:90)
==4797==    by 0x4078EF: cache_init (rule.c:130)
==4797==    by 0x4078EF: cache_update (rule.c:147)
==4797==    by 0x40FB09: cmd_evaluate (evaluate.c:2475)
==4797==    by 0x4296BC: nft_parse (parser_bison.y:655)
==4797==    by 0x4064CC: nft_run (main.c:231)
==4797==    by 0x42CE57: cli_complete (cli.c:124)
==4797==
==4797== LEAK SUMMARY:
==4797==    definitely lost: 189 bytes in 27 blocks
==4797==    indirectly lost: 0 bytes in 0 blocks
==4797==      possibly lost: 0 bytes in 0 blocks
==4797==    still reachable: 112,010 bytes in 278 blocks
==4797==         suppressed: 0 bytes in 0 blocks

After removing xstrdup from src/netlink.c:717 and src/netlink.c:722:
==4545==
==4545== HEAP SUMMARY:
==4545==     in use at exit: 111,856 bytes in 269 blocks
==4545==   total heap usage: 796 allocs, 527 frees, 754,306 bytes allocated
==4545==
==4545== LEAK SUMMARY:
==4545==    definitely lost: 0 bytes in 0 blocks
==4545==    indirectly lost: 0 bytes in 0 blocks
==4545==      possibly lost: 0 bytes in 0 blocks
==4545==    still reachable: 111,856 bytes in 269 blocks
==4545==         suppressed: 0 bytes in 0 blocks

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 src/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index ba0c20a..2917288 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -714,12 +714,12 @@ static struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 		chain->priority      =
 			nftnl_chain_get_s32(nlc, NFTNL_CHAIN_PRIO);
 		chain->type          =
-			xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE));
+			nftnl_chain_get_str(nlc, NFTNL_CHAIN_TYPE);
 		chain->policy          =
 			nftnl_chain_get_u32(nlc, NFTNL_CHAIN_POLICY);
 		if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_DEV)) {
 			chain->dev	=
-				xstrdup(nftnl_chain_get_str(nlc, NFTNL_CHAIN_DEV));
+				nftnl_chain_get_str(nlc, NFTNL_CHAIN_DEV);
 		}
 		chain->flags        |= CHAIN_F_BASECHAIN;
 	}
-- 
1.9.1


-- 

With regards,
Piyush Pangtey <gokuvsvegita@gmail.com>
