Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E2B9C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Nov 2022 19:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbiKVTZy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 14:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVTZx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 14:25:53 -0500
X-Greylist: delayed 408 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 11:25:50 PST
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6C98E0B2
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Nov 2022 11:25:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id A83E3CC02A7;
        Tue, 22 Nov 2022 20:19:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:from:from:received:received
        :received; s=20151130; t=1669144738; x=1670959139; bh=iirndrggEw
        bFpu0sMetJINoF0m4Hg2K3JwxGq+snHus=; b=pMRpQhdhuuWFAOU7wWlqnMff1W
        j/ntirzm3FZXXFwylAiANY8/p6rSaHUg52j1viN09oRPf+lkqLveI+9CfsdDjfW6
        Y03b32cV5FYEwhti75Hu0DqVfQ2AHUC6TORkV4L6ZIPO4iXR5+VriuWGURIsAkJv
        hEXcF6/G+mw8+SXC4=
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Tue, 22 Nov 2022 20:18:58 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id B3EC0CC02A4;
        Tue, 22 Nov 2022 20:18:58 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id AD3F4343156; Tue, 22 Nov 2022 20:18:58 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/1] netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface
Date:   Tue, 22 Nov 2022 20:18:58 +0100
Message-Id: <20221122191858.1051777-2-kadlec@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221122191858.1051777-1-kadlec@netfilter.org>
References: <20221122191858.1051777-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patch "netfilter: ipset: enforce documented limit to prevent allocati=
ng
huge memory" was too strict and prevented to add up to 64 clashing elemen=
ts
to a hash:net,iface type of set. This patch fixes the issue and now the t=
ype
behaves as documented.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/=
ip_set_hash_gen.h
index 3adc291d9ce1..7499192af586 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -916,7 +916,7 @@ mtype_add(struct ip_set *set, void *value, const stru=
ct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >=3D AHASH_MAX_TUNED)
 			goto set_full;
-		else if (h->bucketsize < multi)
+		else if (h->bucketsize <=3D multi)
 			h->bucketsize +=3D AHASH_INIT_SIZE;
 #endif
 		if (n->size >=3D AHASH_MAX(h)) {
--=20
2.30.2

