From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft 0/5] src: Removes unused functions.
Date: Wed, 16 Aug 2017 19:48:12 +0530
Message-ID: <20170816141817.20179-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:38175 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbdHPOS5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2017 10:18:57 -0400
Received: by mail-pf0-f196.google.com with SMTP id h75so1495213pfh.5
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2017 07:18:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set removes structure xt_stmt_ops and the following
functions, as they are not used.

chain_get_cb
cli_display
mnl_nft_chain_get
mnl_nft_rule_add
mnl_nft_rule_delete
mnl_nft_set_get
mnl_nft_table_get
mpz_get_be64
netlink_add_rule_list
netlink_dump_table
netlink_get_chain
netlink_get_set
netlink_get_table
netlink_list_chain
set_get_cb
table_get_cb
xt_stmt_alloc
xt_stmt_destroy
xt_stmt_print
xt_stmt_release
xt_stmt_xlate

Varsha Rao (5):
  src: Remove xt_stmt_() functions.
  src: gmputil: Remove mpz_get_be64() function.
  src: cli: Remove cli_display() function.
  src: netlink: Remove unused functions.
  src: mnl: Remove unused functions.

 include/cli.h       |   1 -
 include/gmputil.h   |   1 -
 include/mnl.h       |  10 -----
 include/netlink.h   |  11 ------
 include/statement.h |   2 -
 include/xt.h        |   7 ----
 src/cli.c           |  26 -------------
 src/gmputil.c       |   5 ---
 src/mnl.c           |  94 -----------------------------------------------
 src/netlink.c       | 104 ----------------------------------------------------
 src/statement.c     |  23 ------------
 src/xt.c            |  74 -------------------------------------
 12 files changed, 358 deletions(-)

-- 
2.13.5

