Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF6CC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 10:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353594AbiDLKMJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357517AbiDLJ7S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 05:59:18 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 7E17744760;
        Tue, 12 Apr 2022 02:02:02 -0700 (PDT)
Received: from 102.localdomain (unknown [59.61.78.232])
        by app1 (Coremail) with SMTP id xjNnewBHTPjGP1ViXEIHAA--.194S2;
        Tue, 12 Apr 2022 17:00:55 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        lvs-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH nf] ipvs: correctly print the memory size of ip_vs_conn_tab
Date:   Tue, 12 Apr 2022 17:00:31 +0800
Message-Id: <1649754031-18627-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewBHTPjGP1ViXEIHAA--.194S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4kWrWDKF13tF43KFWUXFb_yoWfCwb_ZF
        9FvF1Ygr48ZrWDAw15Zan3XFWkJw48AFn3XF97XFWUt34UGw1I9as7Xr9Y9r43Kw4DtryU
        C3yktry3u342gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbsxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28E
        F7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F4
        0EFcxC0VAKzVAqx4xG6I80ewAv7VACjcxG62k0Y48FwI0_Cr0_Gr1UMcIj6x8ErcxFaVAv
        8VW8GwAv7VCY1x0262k0Y48FwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8uwCF04k20xvY
        0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26ryUZr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0x
        ZFpf9x0JU_PE-UUUUU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The memory size of ip_vs_conn_tab changed after we use hlist
instead of list.

Fixes: 731109e78415 ("ipvs: use hlist instead of list")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 2c467c4..e886c74 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
 	pr_info("Connection hash table configured "
 		"(size=%d, memory=%ldKbytes)\n",
 		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
+		(long)(ip_vs_conn_tab_size*sizeof(struct hlist_head))/1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
-- 
1.8.3.1

