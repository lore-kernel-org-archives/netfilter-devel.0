Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D00C2BA83
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9BD8206CC
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:14:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ROGRTinB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391944AbgBNROe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:14:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23401 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2394515AbgBNROa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 12:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581700469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SbHGvcXGZmLVerCAE4java8QrKM03Stei+F4Y+PUPsk=;
        b=ROGRTinB1EUzaBW0Y8gO3zqjlSHLOAjfxJcSdnhaw8Kj1X/eJnVOWiqLCYzYiK2iNorcCj
        CtWMefEXGUQZWEhAPRyzOp0rM8FbpU+rurrBXlDsKo6gk5FXqAJE9AHk/H2cvjFX02uEcK
        ua3bCwXc4VQ2oy2WvB4CJUAPutXP1Xs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-_l5CvvFKMtSAm3MXHSxNVA-1; Fri, 14 Feb 2020 12:14:25 -0500
X-MC-Unique: _l5CvvFKMtSAm3MXHSxNVA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EFA6189F763;
        Fri, 14 Feb 2020 17:14:24 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 857F719C4F;
        Fri, 14 Feb 2020 17:14:23 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/2] Two non-functional fixes for nft_set_pipapo
Date:   Fri, 14 Feb 2020 18:14:12 +0100
Message-Id: <cover.1581699548.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1/2 fixes examples of mapping table values in comments,
patch 2/2 drops an abuse of unlikely(), both reported by Pablo.

No functional changes are intended here. I'm not entirely sure
these should be for nf-next, but I guess so as they don't carry
any functional fix.

Stefano Brivio (2):
  netfilter: nft_set_pipapo: Fix mapping table example in comments
  netfilter: nft_set_pipapo: Don't abuse unlikely() in pipapo_refill()

 net/netfilter/nft_set_pipapo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--=20
2.25.0

