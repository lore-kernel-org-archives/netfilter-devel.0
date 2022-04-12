Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129D8C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 12:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351710AbiDLMGr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 08:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354049AbiDLMEU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 08:04:20 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 93B8422B34;
        Tue, 12 Apr 2022 04:06:40 -0700 (PDT)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app1 (Coremail) with SMTP id xjNnewAn2DE2XVViqY4HAA--.413S2;
        Tue, 12 Apr 2022 19:06:31 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        lvs-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org, Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH nf,v2] ipvs: correctly print the memory size of ip_vs_conn_tab
Date:   Tue, 12 Apr 2022 19:05:45 +0800
Message-Id: <1649761545-1864-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: xjNnewAn2DE2XVViqY4HAA--.413S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Gr4kWrWDKF13tr48KF4UJwb_yoWDJrc_ZF
        92vF1Ygw48ZrWDAw45Zan3XFWkJ348AFn3XF97XFWDt34UGw17uas7Xr9Y9r43Kw4qqryU
        C3ykKry3u342gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbskFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kI
        II0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7
        xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
        z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4
        xG64xvF2IEw4CE5I8CrVC2j2WlYx0EF7xvrVAajcxG14v26r4j6F4UMcIj6x8ErcxFaVAv
        8VW8GwAv7VCY1x0262k0Y48FwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2
        IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8KwCF04k20xvY
        0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26ryUZr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E
        87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73Uj
        IFyTuYvjfUo18BUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The memory size of ip_vs_conn_tab changed after we use hlist
instead of list.

Fixes: 731109e78415 ("ipvs: use hlist instead of list")
Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
v2: use pointer dereference instead of struct types

 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 2c467c4..fb67f1c 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
 	pr_info("Connection hash table configured "
 		"(size=%d, memory=%ldKbytes)\n",
 		ip_vs_conn_tab_size,
-		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
+		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
 	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
 		  sizeof(struct ip_vs_conn));
 
-- 
1.8.3.1

