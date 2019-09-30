Return-Path: <SRS0=Tpyl=XZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37E8C4360C
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 08:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A62932075D
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Sep 2019 08:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729893AbfI3Ijz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Sep 2019 04:39:55 -0400
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:44084
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3Ijz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Sep 2019 04:39:55 -0400
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iErDi-000BH6-Rn; Mon, 30 Sep 2019 10:39:50 +0200
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH nft] src: obj: fix memleak in handle_free()
Date:   Mon, 30 Sep 2019 10:38:23 +0200
Message-Id: <20190930083823.43094-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Using limit object as example:

 # valgrind --leak-check=full nft list ruleset
 ==9937== Memcheck, a memory error detector
 ==9937== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
 ==9937== Using Valgrind-3.14.0 and LibVEX; rerun with -h for copyright info
 ==9937== Command: nft list ruleset
 ==9937==
 table inet raw {
         limit lim1 {
                 rate 1/second
         }
 }
 ==9937==
 ==9937== HEAP SUMMARY:
 ==9937==     in use at exit: 5 bytes in 1 blocks
 ==9937==   total heap usage: 50 allocs, 49 frees, 212,065 bytes allocated
 ==9937==
 ==9937== 5 bytes in 1 blocks are definitely lost in loss record 1 of 1
 ==9937==    at 0x4C29EA3: malloc (vg_replace_malloc.c:309)
 ==9937==    by 0x5C65AA9: strdup (strdup.c:42)
 ==9937==    by 0x4E720A3: xstrdup (utils.c:75)
 ==9937==    by 0x4E660FF: netlink_delinearize_obj (netlink.c:972)
 ==9937==    by 0x4E6641C: list_obj_cb (netlink.c:1064)
 ==9937==    by 0x50E8993: nftnl_obj_list_foreach (object.c:494)
 ==9937==    by 0x4E664EA: netlink_list_objs (netlink.c:1085)
 ==9937==    by 0x4E4FE82: cache_init_objects (rule.c:188)
 ==9937==    by 0x4E4FE82: cache_init (rule.c:221)
 ==9937==    by 0x4E4FE82: cache_update (rule.c:271)
 ==9937==    by 0x4E7716E: nft_evaluate (libnftables.c:406)
 ==9937==    by 0x4E778F7: nft_run_cmd_from_buffer (libnftables.c:447)
 ==9937==    by 0x40170F: main (main.c:326)

Fixes: 4756d92e517ae ("src: listing of stateful objects")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 src/rule.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/rule.c b/src/rule.c
index 0cc1fa595918..2d35bae44c9e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -106,6 +106,7 @@ void handle_free(struct handle *h)
 	xfree(h->chain.name);
 	xfree(h->set.name);
 	xfree(h->flowtable);
+	xfree(h->obj.name);
 }
 
 void handle_merge(struct handle *dst, const struct handle *src)
-- 
2.11.0

