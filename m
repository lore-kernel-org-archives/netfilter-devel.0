Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98667C3B1A6
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66239206CC
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:14:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EjIv9+om"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394566AbgBNROd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:14:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58150 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390916AbgBNROb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 12:14:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581700471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3wwO+rW7P0ejMmgEWl/YEs1ldSEP2ahOQL5bWND7zYM=;
        b=EjIv9+omWA6wviAYbHWLbhqFCmvOdK/LuFHrzIMfgrMIsjcR14tW/8EqrjIQr0DJnBa11+
        FcgCYKQWVo+CcD2vtbpRKGkuLCLgiOuEt2E0N5VSIR0R3YQMCReYx1rojgWyiHtMpvClw+
        ACqfBWkJ9K1QWcPUTDHWnMw2S2Pkp2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-vYkk8gK5OJuQuGvKhGG_aw-1; Fri, 14 Feb 2020 12:14:27 -0500
X-MC-Unique: vYkk8gK5OJuQuGvKhGG_aw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37020800D4E;
        Fri, 14 Feb 2020 17:14:26 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E42319C4F;
        Fri, 14 Feb 2020 17:14:24 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: nft_set_pipapo: Fix mapping table example in comments
Date:   Fri, 14 Feb 2020 18:14:13 +0100
Message-Id: <c658f8e530aaf98fbdc4ad167e3d49fdad1db3de.1581699548.git.sbrivio@redhat.com>
In-Reply-To: <cover.1581699548.git.sbrivio@redhat.com>
References: <cover.1581699548.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In both insertion and lookup examples, the two element pointers
of rule mapping tables were swapped. Fix that.

Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation=
 of ranges")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipap=
o.c
index f0cb1e13af50..579600b39f39 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -203,7 +203,7 @@
  * ::
  *
  *       rule indices in last field:    0    1
- *       map to elements:             0x42  0x66
+ *       map to elements:             0x66  0x42
  *
  *
  * Matching
@@ -298,7 +298,7 @@
  * ::
  *
  *       rule indices in last field:    0    1
- *       map to elements:             0x42  0x66
+ *       map to elements:             0x66  0x42
  *
  *      the matching element is at 0x42.
  *
--=20
2.25.0

