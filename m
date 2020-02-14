Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4159BC2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A58F20637
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:14:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EvtjqYiF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389492AbgBNROk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:14:40 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60050 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403833AbgBNROi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 12:14:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581700477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HR1cXDBK2Iefu4y3SrHW/W6N9JttW8zay3uH6Q96KvM=;
        b=EvtjqYiFKgQeQSFhP4RbAldaVxc9G2W0HQfaB15/bVBUn+Hdegv71lSMOH9Kx4ZjDbDNCS
        Ou5ZhQdZEkCg2Nb/0N4aXil9no3w7yMHC0A4i35HUQP/NSfycnvrGshvYpFUs2pQYXzbeZ
        GQNhGY4Y16VSvgVADZryw4+CnhwC9ic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-syXFmYayNMGUKsupW7Ni4A-1; Fri, 14 Feb 2020 12:14:28 -0500
X-MC-Unique: syXFmYayNMGUKsupW7Ni4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEB0F8017CC;
        Fri, 14 Feb 2020 17:14:27 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1FD219C4F;
        Fri, 14 Feb 2020 17:14:26 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 2/2] netfilter: nft_set_pipapo: Don't abuse unlikely() in pipapo_refill()
Date:   Fri, 14 Feb 2020 18:14:14 +0100
Message-Id: <5208393012d9aa0b312f503dbd1dad565e92e032.1581699548.git.sbrivio@redhat.com>
In-Reply-To: <cover.1581699548.git.sbrivio@redhat.com>
References: <cover.1581699548.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I originally used unlikely() in the if (match_only) clause, which
we hit on the mapping table for the last field in a set, to ensure
we avoid branching to the rest of for loop body, which is executed
more frequently.

However, Pablo reports, this is confusing as it gives the impression
that this is not a common case, and it's actually not the intended
usage of unlikely().

I couldn't observe any statistical difference in matching rates on
x864_64 and aarch64 without it, so just drop it.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation=
 of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index 579600b39f39..feac8553f6d9 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -503,7 +503,7 @@ static int pipapo_refill(unsigned long *map, int len,=
 int rules,
 				return -1;
 			}
=20
-			if (unlikely(match_only)) {
+			if (match_only) {
 				bitmap_clear(map, i, 1);
 				return i;
 			}
--=20
2.25.0

