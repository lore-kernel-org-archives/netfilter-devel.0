Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11363C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 13:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKCNKC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Nov 2022 09:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiKCNKB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2022 09:10:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A764B11E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2022 06:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667480938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VWFVVjFoPh9//o9VH0sQcghYNck2hp+BNoOr8GX7Wu8=;
        b=iLQ60AcZVQvXBIu8Ids6JyA2ix58Sl96yb1pa5yW2/CCy3C3VmO/0M2EiZra3uHP5Brwr3
        qOTVtsCnnXzB6T/9UuGLpTaH7N+sMJpTOqyHw7Hb6gziYCYhn5jWkeuUKi4/YHb9rWOrr0
        ayvOOJGLkGZj4H9WmzK+Ln9+N+xHtBM=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-609-dkNMH59FMnWzYXwUCmi3rg-1; Thu, 03 Nov 2022 09:08:57 -0400
X-MC-Unique: dkNMH59FMnWzYXwUCmi3rg-1
Received: by mail-pj1-f71.google.com with SMTP id x14-20020a17090a2b0e00b002134b1401ddso881852pjc.8
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Nov 2022 06:08:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWFVVjFoPh9//o9VH0sQcghYNck2hp+BNoOr8GX7Wu8=;
        b=aAXi55WBJKwDhZWu+sVXcCK9GIBJ31oVBokD0RxlFpmn/BG51N1hOqPnLSjE2cLRSV
         0ldD8K8yW4X4IbdlPUsescF354llFlIQrRhibVM7R3+comVXbJgIA/mtbra8n6AGbp34
         c7vmnPAtKvGaoqidL0ZR8ybyfggKIaypmMVuBdEhVwdeQN2PcSP6T5oIveGYb6iqa5Se
         zkYmyRlGtiMBmMJA9QjZ2Vf91qM28f5z+5SOUmbM3zLcQbXtvZ/zdmhLw/4kxJVzYa8Q
         E4ck8uSRxnPKS+8Z5mlCNVZ8i6Z5jZ0pnnVvbIMOJHlLZTF6r91FIEJIh0/lQavcJFPJ
         oy2Q==
X-Gm-Message-State: ACrzQf3F+kQU4kV2ZeVvthRcWzEwXGmG/LGQ8b1DrFFgTW53FBUHEKpM
        ZUfuJ+NdUgEWIaomvGUiKvfwwnEWcZdWRL/gFjavOcDfw7x5R2bq+jKFU//ebGgt587tqUhzVKi
        pvLoeNEneIM85oN7O60bIgmECjzA8
X-Received: by 2002:a05:6a00:1988:b0:56d:315d:e371 with SMTP id d8-20020a056a00198800b0056d315de371mr26331627pfl.20.1667480936722;
        Thu, 03 Nov 2022 06:08:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6iSBF/0xkGlp5PD69KA5JXu9lEwVifRIL5cr6mlgd5MXUVIRiMLYuXynw7VvfkZ8niuZKrEw==
X-Received: by 2002:a05:6a00:1988:b0:56d:315d:e371 with SMTP id d8-20020a056a00198800b0056d315de371mr26331604pfl.20.1667480936442;
        Thu, 03 Nov 2022 06:08:56 -0700 (PDT)
Received: from ryzen.. ([240d:1a:c0d:9f00:fc9c:8ee9:e32c:2d9])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902a40600b0017e232b6724sm635952plq.69.2022.11.03.06.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 06:08:55 -0700 (PDT)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Shigeru Yoshida <syoshida@redhat.com>,
        syzbot+178efee9e2d7f87f5103@syzkaller.appspotmail.com
Subject: [PATCH] netfilter: Cleanup nft_net->module_list from nf_tables_exit_net()
Date:   Thu,  3 Nov 2022 22:08:49 +0900
Message-Id: <20221103130849.1624522-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

syzbot reported a warning like below [1]:

WARNING: CPU: 3 PID: 9 at net/netfilter/nf_tables_api.c:10096 nf_tables_exit_net+0x71c/0x840
Modules linked in:
CPU: 2 PID: 9 Comm: kworker/u8:0 Tainted: G        W          6.1.0-rc3-00072-g8e5423e991e8 #47
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:nf_tables_exit_net+0x71c/0x840
...
Call Trace:
 <TASK>
 ? __nft_release_table+0xfc0/0xfc0
 ops_exit_list+0xb5/0x180
 cleanup_net+0x506/0xb10
 ? unregister_pernet_device+0x80/0x80
 process_one_work+0xa38/0x1730
 ? pwq_dec_nr_in_flight+0x2b0/0x2b0
 ? rwlock_bug.part.0+0x90/0x90
 ? _raw_spin_lock_irq+0x46/0x50
 worker_thread+0x67e/0x10e0
 ? process_one_work+0x1730/0x1730
 kthread+0x2e5/0x3a0
 ? kthread_complete_and_exit+0x40/0x40
 ret_from_fork+0x1f/0x30
 </TASK>

In nf_tables_exit_net(), there is a case where nft_net->commit_list is
empty but nft_net->module_list is not empty.  Such a case occurs with
the following scenario:

1. nfnetlink_rcv_batch() is called
2. nf_tables_newset() returns -EAGAIN and NFNL_BATCH_FAILURE bit is
   set to status
3. nf_tables_abort() is called with NFNL_ABORT_AUTOLOAD
   (nft_net->commit_list is released, but nft_net->module_list is not
   because of NFNL_ABORT_AUTOLOAD flag)
4. Jump to replay label
5. netlink_skb_clone() fails and returns from the function (this is
   caused by fault injection in the reproducer of syzbot)

This patch fixes this issue by calling __nf_tables_abort() when
nft_net->module_list is not empty in nf_tables_exit_net().

Link: https://syzkaller.appspot.com/bug?id=802aba2422de4218ad0c01b46c9525cc9d4e4aa3 [1]
Reported-by: syzbot+178efee9e2d7f87f5103@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58d9cbc9ccdc..a7579d16f59f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10088,7 +10088,8 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 
 	mutex_lock(&nft_net->commit_mutex);
-	if (!list_empty(&nft_net->commit_list))
+	if (!list_empty(&nft_net->commit_list) ||
+	    !list_empty(&nft_net->module_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.37.3

