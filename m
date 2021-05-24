Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82716C04FF3
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 20:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5729A613E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 May 2021 20:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhEXUFl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 May 2021 16:05:41 -0400
Received: from mg.ssi.bg ([178.16.128.9]:35582 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232107AbhEXUFl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 May 2021 16:05:41 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2021 16:05:40 EDT
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id D15CE2EEF8;
        Mon, 24 May 2021 22:55:27 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id BD6FB2EEF7;
        Mon, 24 May 2021 22:55:26 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 952233C0332;
        Mon, 24 May 2021 22:55:25 +0300 (EEST)
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 14OJtPOm125619;
        Mon, 24 May 2021 22:55:25 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.16.1/8.16.1/Submit) id 14OJtNKT125612;
        Mon, 24 May 2021 22:55:23 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     Simon Horman <horms@verge.net.au>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH net] ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service
Date:   Mon, 24 May 2021 22:54:57 +0300
Message-Id: <20210524195457.125514-1-ja@ssi.bg>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot reported memory leak [1] when adding service with
HASHED flag. We should ignore this flag both from sockopt
and netlink provided data, otherwise the service is not
hashed and not visible while releasing resources.

[1]
BUG: memory leak
unreferenced object 0xffff888115227800 (size 512):
  comm "syz-executor263", pid 8658, jiffies 4294951882 (age 12.560s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83977188>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff83977188>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff83977188>] ip_vs_add_service+0x598/0x7c0 net/netfilter/ipvs/ip_vs_ctl.c:1343
    [<ffffffff8397d770>] do_ip_vs_set_ctl+0x810/0xa40 net/netfilter/ipvs/ip_vs_ctl.c:2570
    [<ffffffff838449a8>] nf_setsockopt+0x68/0xa0 net/netfilter/nf_sockopt.c:101
    [<ffffffff839ae4e9>] ip_setsockopt+0x259/0x1ff0 net/ipv4/ip_sockglue.c:1435
    [<ffffffff839fa03c>] raw_setsockopt+0x18c/0x1b0 net/ipv4/raw.c:857
    [<ffffffff83691f20>] __sys_setsockopt+0x1b0/0x360 net/socket.c:2117
    [<ffffffff836920f2>] __do_sys_setsockopt net/socket.c:2128 [inline]
    [<ffffffff836920f2>] __se_sys_setsockopt net/socket.c:2125 [inline]
    [<ffffffff836920f2>] __x64_sys_setsockopt+0x22/0x30 net/socket.c:2125
    [<ffffffff84350efa>] do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
    [<ffffffff84400068>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-and-tested-by: syzbot+e562383183e4b1766930@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index d45dbcba8b49..c25097092a06 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1367,7 +1367,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	ip_vs_addr_copy(svc->af, &svc->addr, &u->addr);
 	svc->port = u->port;
 	svc->fwmark = u->fwmark;
-	svc->flags = u->flags;
+	svc->flags = u->flags & ~IP_VS_SVC_F_HASHED;
 	svc->timeout = u->timeout * HZ;
 	svc->netmask = u->netmask;
 	svc->ipvs = ipvs;
-- 
2.31.1


