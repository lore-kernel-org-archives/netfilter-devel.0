Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B8DC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 11:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2FAC6139F
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Oct 2021 11:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbhJDLw4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Oct 2021 07:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhJDLwz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Oct 2021 07:52:55 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7B7C061745
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Oct 2021 04:51:07 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g184so16288517pgc.6
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Oct 2021 04:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PWaXoRWNZIyTcXpFaqrWf6aNoUMQ1rwaDvmvUEsPDpw=;
        b=OwFPfsZngHt7a8oJzQIHoBNgwzg5XlrcSNFamdjHXLtfAtljmvw/qEc23lX6bR1zi3
         +i35sJNIBIeFT9u/A4vpJ4B1H3jx2vxhvodeiSt2feKWgHpjTR2s6Ne+TbKb1UraD96K
         1u7oZSr/DS8x4LGQLpXL4UTQc5CCjIzIYNWN1U7GGol/X10HMtZfh3GXtmFeoL/yrIyX
         hs4nb1jA5MIqIrVNnCFLd7vfCBcrd7M8ZCSI9HjVJRr7kFvnUfR9PIxQD0/S4GP4To2G
         GNV5PZvmeFGXTaZ935i1iut/NAESUadL1VPqoeU+6uaVXnVEgJixQtmxwz3snSjP4vr1
         295Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PWaXoRWNZIyTcXpFaqrWf6aNoUMQ1rwaDvmvUEsPDpw=;
        b=LCBHTe/n6JZ3zLdgPpPXn3d4LBSrkOCRN1bDXbEfsflyyLWwdr+xzp766cG4L3Xofl
         jqIIT5U0ptym0yDDyKHEhnETlBveuqwBNvF3e3OLXK9IYdcWRg3jck4Ncb+0p/J5z/y3
         FATab2MQQG/vHzqNqnhQBWfkEInfmOmgec8YMA3ByHDogq1OAE3lfjhAxzLIehsgQGBf
         dAtkBe0y4g/Wi+zkpCa0YKdapxgeWdOTSLxHeWf1jUaywzCJNJFfw8a2QcWS/qhPHIyZ
         rZYv42PyzgjswbxBNU3BWZdK2XZXm5w6fo0RLtvsvnkr+SvCTv4xaIUpJASHQmyS9QoK
         F4PA==
X-Gm-Message-State: AOAM533Yg3jAOBB0sKeuwyJ0HX6+YyVj68zfBiZ0zyZEI+Lx83iYmR0K
        9LxOaGqDu4IcMdwLhT/j41EHwqhDfXEYGIN//Bw=
X-Google-Smtp-Source: ABdhPJyJfU2gVnR/lATOII7ltXhP/p9WJAEkpLecJsPyAIAbE2xp6o52duXSwHM6b8R3Jbvx2VyTlg==
X-Received: by 2002:a05:6a00:983:b0:444:ac28:1ee1 with SMTP id u3-20020a056a00098300b00444ac281ee1mr25675180pfg.49.1633348266727;
        Mon, 04 Oct 2021 04:51:06 -0700 (PDT)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id t6sm14458469pfh.63.2021.10.04.04.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 04:51:06 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, luciano.coelho@nokia.com
Subject: [PATCH nf] netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value
Date:   Mon,  4 Oct 2021 20:51:01 +0900
Message-Id: <20211004115101.1579-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, when the rule related to IDLETIMER is added, idletimer_tg timer 
structure is initialized by kmalloc on executing idletimer_tg_create 
function. However, in this process timer->timer_type is not defined to 
a specific value. Thus, timer->timer_type has garbage value and it occurs 
kernel panic. So, this commit fixes the panic by initializing 
timer->timer_type using kzalloc instead of kmalloc.

Test commands:
    # iptables -A OUTPUT -j IDLETIMER --timeout 1 --label test
    $ cat /sys/class/xt_idletimer/timers/test
      Killed

Splat looks like:
    BUG: KASAN: user-memory-access in alarm_expires_remaining+0x49/0x70
    Read of size 8 at addr 0000002e8c7bc4c8 by task cat/917
    CPU: 12 PID: 917 Comm: cat Not tainted 5.14.0+ #3 79940a339f71eb14fc81aee1757a20d5bf13eb0e
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
    Call Trace:
     dump_stack_lvl+0x6e/0x9c
     kasan_report.cold+0x112/0x117
     ? alarm_expires_remaining+0x49/0x70
     __asan_load8+0x86/0xb0
     alarm_expires_remaining+0x49/0x70
     idletimer_tg_show+0xe5/0x19b [xt_IDLETIMER 11219304af9316a21bee5ba9d58f76a6b9bccc6d]
     dev_attr_show+0x3c/0x60
     sysfs_kf_seq_show+0x11d/0x1f0
     ? device_remove_bin_file+0x20/0x20
     kernfs_seq_show+0xa4/0xb0
     seq_read_iter+0x29c/0x750
     kernfs_fop_read_iter+0x25a/0x2c0
     ? __fsnotify_parent+0x3d1/0x570
     ? iov_iter_init+0x70/0x90
     new_sync_read+0x2a7/0x3d0
     ? __x64_sys_llseek+0x230/0x230
     ? rw_verify_area+0x81/0x150
     vfs_read+0x17b/0x240
     ksys_read+0xd9/0x180
     ? vfs_write+0x460/0x460
     ? do_syscall_64+0x16/0xc0
     ? lockdep_hardirqs_on+0x79/0x120
     __x64_sys_read+0x43/0x50
     do_syscall_64+0x3b/0xc0
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    RIP: 0033:0x7f0cdc819142
    Code: c0 e9 c2 fe ff ff 50 48 8d 3d 3a ca 0a 00 e8 f5 19 02 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
    RSP: 002b:00007fff28eee5b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
    RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f0cdc819142
    RDX: 0000000000020000 RSI: 00007f0cdc032000 RDI: 0000000000000003
    RBP: 00007f0cdc032000 R08: 00007f0cdc031010 R09: 0000000000000000
    R10: 0000000000000022 R11: 0000000000000246 R12: 00005607e9ee31f0
    R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000

Fixes: 0902b469bd250 ("netfilter: xtables: idletimer target implementation")
Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 net/netfilter/xt_IDLETIMER.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 7b2f359bfce4..2f7cf5ecebf4 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -137,7 +137,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 {
 	int ret;
 
-	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
+	info->timer = kzalloc(sizeof(*info->timer), GFP_KERNEL);
 	if (!info->timer) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.25.1


