Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C25ABC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C34861177
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Oct 2021 19:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhJ2TJw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:09:52 -0400
Received: from proxmox-new.maurer-it.com ([94.136.29.106]:12144 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbhJ2TJu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Oct 2021 15:09:50 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Oct 2021 15:09:49 EDT
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id B655F46000;
        Fri, 29 Oct 2021 21:00:17 +0200 (CEST)
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: [RFC] netfilter: ipset: fix AHASH_MAX_SIZE to documented one
Date:   Fri, 29 Oct 2021 20:59:50 +0200
Message-Id: <20211029185951.987921-1-t.lamprecht@proxmox.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ran into getting a different default value applied for `bucketsize` as
documented in the man page, i.e., 12 vs. 14, for example:

`create foo hash:net family inet hashsize 64 maxelem 64`

ipset save tells me:
`create foo hash:net family inet hashsize 64 maxelem 64 bucketsize 12 initval 0xd4f64074`

But the man page states:
> Possible values are any even number between 2-14 and the default is 14.

In the kernel code the `AHASH_MAX_SIZE`, which was used to bound
check any value coming from user space and acts also as default, was
defined to `2 * 6` = 12, it almost seems like it was inteded to
define the span of valid values (2 - 14 = 12 after all) but then used
as actual upper bound everywhere, so it was lost that the range
starts on 2, not zero.

Either one should be fixed and I went for the code, seems nicer to
have a bigger tuning range, the docs are quite explicit and the
commit ccf0a4b7fc68 ("netfilter: ipset: Add bucketsize parameter to
all hash types")' that introduced the change on the kernelside
doesn't mentions any range/default values at all.

So I just added the AHASH_INIT_SIZE and checked all use sites of
`AHASH_MAX_SIZE`, but those sites basically are only the range checks
anyway.

Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
---

sending as RFC as one could still go for the docs fix instead and
because I'm not to versed with the whole netfilter code base, so may
overlook something.

 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 6e391308431d..8bc6c46403de 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -39,7 +39,7 @@
 /* Number of elements to store in an initial array block */
 #define AHASH_INIT_SIZE			2
 /* Max number of elements to store in an array block */
-#define AHASH_MAX_SIZE			(6 * AHASH_INIT_SIZE)
+#define AHASH_MAX_SIZE			(AHASH_INIT_SIZE + 6 * AHASH_INIT_SIZE)
 /* Max muber of elements in the array block when tuned */
 #define AHASH_MAX_TUNED			64
 
-- 
2.30.2


