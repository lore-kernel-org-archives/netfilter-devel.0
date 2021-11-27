Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD3DC4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Nov 2021 10:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbhK0KjO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Nov 2021 05:39:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57404 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239184AbhK0KhN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Nov 2021 05:37:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638009239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OVuAk298/Ida9SlJtQUnhBQrrLWLnpK6TTTaXfrF7NI=;
        b=HsVEahdOot1fCkHTOMTA8Nl81P+/0O3aBKlDzfPVVsMju3NnpV66l/uxcBEryatK9lS7v+
        VW7AkzTbBrk1yjFvFg9wgAWlSxAJDBl9tIX3HJtKvAKBkl2idm61K0QkFIbNUSkaK7AJR0
        ozE5R5jHQGfF9tbz/G594o8bBMkN6a4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-565-p2OLfCNLPmiqKs3pfkUOvw-1; Sat, 27 Nov 2021 05:33:57 -0500
X-MC-Unique: p2OLfCNLPmiqKs3pfkUOvw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85CDA835B47;
        Sat, 27 Nov 2021 10:33:56 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AD0918A50;
        Sat, 27 Nov 2021 10:33:53 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Nikita Yushchenko <nikita.yushchenko@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH nf 0/2] nft_set_pipapo: Fix AVX2 MAC address match, add test
Date:   Sat, 27 Nov 2021 11:33:36 +0100
Message-Id: <cover.1637976889.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1/2 fixes the issue reported by Nikita where a MAC address
wouldn't match if given as first field of a set, and patch 2/2 adds
the corresponding test.

Stefano Brivio (2):
  nft_set_pipapo: Fix bucket load in AVX2 lookup routine for six 8-bit
    groups
  selftests: netfilter: Add correctness test for mac,net set type

 net/netfilter/nft_set_pipapo_avx2.c           |  2 +-
 .../selftests/netfilter/nft_concat_range.sh   | 24 ++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

-- 
2.30.2

