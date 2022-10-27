Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3535ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Oct 2022 13:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiJ0NPt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Oct 2022 09:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiJ0NPs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2022 09:15:48 -0400
X-Greylist: delayed 313 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Oct 2022 06:15:45 PDT
Received: from smtp.wigner.hu (smtp.wigner.mta.hu [148.6.0.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE40380BF6
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2022 06:15:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 5A89967400D4;
        Thu, 27 Oct 2022 15:10:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wigner.hu; h=
        mime-version:x-mailer:message-id:date:date:from:from:received
        :received:received; s=20151130; t=1666876224; x=1668690625; bh=o
        6rILvLurvHECojsTC2RjZZQOhX1ArKArbhg0gTyq9g=; b=ARXjzvv6hw77ddy/F
        OxbBTRFj1+70dsOgAflxBKGZeaRcHmlph0eH6mps7xrAqrkpq7QRvsdV9sN+XA/G
        jnmVeA7ESqft5pnk0vrjGwruRuaYWx4di/3XRsyGEoNU0xG9g9Xp7PQ3aXhx2hcq
        0wkx7Fzn1ltY16JAMZ6dXLoBFk=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 27 Oct 2022 15:10:24 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (mentat.szhk.kfki.hu [148.6.240.34])
        (Authenticated sender: kadlecsik.jozsef@wigner.hu)
        by smtp0.kfki.hu (Postfix) with ESMTPSA id 3AD3B67400DA;
        Thu, 27 Oct 2022 15:10:23 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
        id EC0AC172; Thu, 27 Oct 2022 15:10:22 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Daniel Xu <dxu@dxuuu.xyz>
Subject: [PATCH] netfilter: ipset: enforce documented limit to prevent allocating huge memory
Date:   Thu, 27 Oct 2022 15:10:22 +0200
Message-Id: <20221027131022.212948-1-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Daniel Xu reported that the hash:net,iface type of the ipset subsystem do=
es
not limit adding the same network with different interfaces to a set, whi=
ch
can lead to huge memory usage or allocation failure.

The quick reproducer is

$ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout =
0
$ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,k=
af_$i timeout 0 -exist; done

The backtrace when vmalloc fails:

        [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848,=
 exceeds total pages
        <...>
        [Tue Oct 25 00:13:08 2022] Call Trace:
        [Tue Oct 25 00:13:08 2022]  <TASK>
        [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
        [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
        [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
        [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
        [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
        [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
        [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
        <...>

The fix is to enforce the limit documented in the ipset(8) manpage:

>  The internal restriction of the hash:net,iface set type is that the sa=
me
>  network prefix cannot be stored with more than 64 different interfaces
>  in a single set.

Reported-by: Daniel Xu <dxu@dxuuu.xyz>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 6e391308431d..3f8853ed32e9 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -61,10 +61,6 @@ tune_bucketsize(u8 curr, u32 multi)
 	 */
 	return n > curr && n <=3D AHASH_MAX_TUNED ? n : curr;
 }
-#define TUNE_BUCKETSIZE(h, multi)	\
-	((h)->bucketsize =3D tune_bucketsize((h)->bucketsize, multi))
-#else
-#define TUNE_BUCKETSIZE(h, multi)
 #endif
=20
 /* A hash bucket */
@@ -936,7 +932,11 @@ mtype_add(struct ip_set *set, void *value, const str=
uct ip_set_ext *ext,
 		goto set_full;
 	/* Create a new slot */
 	if (n->pos >=3D n->size) {
-		TUNE_BUCKETSIZE(h, multi);
+#ifdef IP_SET_HASH_WITH_MULTI
+		if (h->bucketsize >=3D AHASH_MAX_TUNED)
+			goto set_full;
+		h->bucketsize =3D tune_bucketsize(h->bucketsize, multi);
+#endif
 		if (n->size >=3D AHASH_MAX(h)) {
 			/* Trigger rehashing */
 			mtype_data_next(&h->next, d);
--=20
2.30.2

