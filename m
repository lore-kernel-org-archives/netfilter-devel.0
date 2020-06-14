Return-Path: <SRS0=cPjr=73=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29914C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03DA206B7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Jun 2020 21:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z8s1zdlS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgFNVmW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Jun 2020 17:42:22 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32585 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgFNVmW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Jun 2020 17:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592170941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5VnfDEpiw9OLyljQaFvR1hkE76w/0y6y1oTWPlFTwSo=;
        b=Z8s1zdlSbPLKjN/nt/3YxURikcI+K3NrD4Vg9yTu3Tx7C8AdvJmOk3ByPy/DiEvnmTKszH
        rM/2dtRz6zW9Uq7EPpUT1DoI6X+JL9DIKVCwOZacYTMvSteMVJPfQa/89X5wtziED/4FFN
        9fFkVfB52a21fN/Rks5NQKoTzGA67xg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-k-QxKcjlOzqnuYABCsLJrA-1; Sun, 14 Jun 2020 17:42:17 -0400
X-MC-Unique: k-QxKcjlOzqnuYABCsLJrA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39525107ACCA;
        Sun, 14 Jun 2020 21:42:16 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C1537CAAC;
        Sun, 14 Jun 2020 21:42:14 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] nft_set_pipapo: Drop useless assignment of scratch map index on insert
Date:   Sun, 14 Jun 2020 23:42:07 +0200
Message-Id: <033bc756cdecd4e8cbe01be3bcd50e59a844665c.1592167414.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In nft_pipapo_insert(), we need to reallocate scratch maps that will
be used for matching by lookup functions, if they have never been
allocated or if the bucket size changes as a result of the insertion.

As pipapo_realloc_scratch() provides a pair of fresh, zeroed out
maps, there's no need to select a particular one after reallocation.

Other than being useless, the existing assignment was also troubled
by the fact that the index was set only on the CPU performing the
actual insertion, as spotted by Florian.

Simply drop the assignment.

Reported-by: Florian Westphal <fw@strlen.de>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
This might cause a conflict on merge from nf.git with commit
c3829285b2e6 ("netfilter: nft_set_pipapo: Disable preemption before
getting per-CPU pointer") -- the resolution is to just drop the call
to this_cpu_write() like this patch does. I can send an explicit
conflict resolution patch if needed.

 net/netfilter/nft_set_pipapo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 8b5acc6910fd..9aa2bb3982e8 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1247,8 +1247,6 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 		if (err)
 			return err;
 
-		this_cpu_write(nft_pipapo_scratch_index, false);
-
 		m->bsize_max = bsize_max;
 	}
 
-- 
2.27.0

