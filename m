Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D31C3DA6B
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Aug 2022 13:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiH3Nhu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Aug 2022 09:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiH3Nhs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2022 09:37:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262866612A
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 06:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=37RGivsyVVdiLmg4GL0JzLmH/5toyhTIPeBc6pIiFKI=; b=X1LOvkllUvc2TG2dhQdeBFE0uy
        A/NpmjzQzEIxhDaIygHIHFTB9JXjbIGD3U2zrHyH/uTX4qDnaJndOTq0CNnj7SzCJlpvGK8wPqjSB
        OPA+I0LhF48reJet27bF8fmxX9UlNYmJFAw3tu39wIuUgih7rUYYH0qf7K1DuTot6VMtJPr3FqaOy
        XEcQX2BvUVefaWAHwLJrrwzW9S2zGRiDfJY5gIBosIESjx/f0TXQF+IBNDnrcUB2RlMgsI7L6CEwE
        PdGVTcL0wDMNYH0Z03ZHuWlQhAG2Q5VQLXg5LNzJT1vdLMyPHgw03pEKpTwavbvj/ad+WDXgjC/U6
        ljw2ObVg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oT1R3-0004hR-IK; Tue, 30 Aug 2022 15:37:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: nft.8: Add missing '-T' in synopsis
Date:   Tue, 30 Aug 2022 15:37:40 +0200
Message-Id: <20220830133740.27142-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Originally a typo in fixed commit: It added 't' in lower case, but
meanwhile '-t' was added as well.

Fixes: f8f32deda31df ("meta: Introduce new conditions 'time', 'day' and 'hour'")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index f7a53ac924844..16c68322ffe5b 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -9,7 +9,7 @@ nft - Administration tool of the nftables framework for packet filtering and cla
 SYNOPSIS
 --------
 [verse]
-*nft* [ *-nNscaeSupyjt* ] [ *-I* 'directory' ] [ *-f* 'filename' | *-i* | 'cmd' ...]
+*nft* [ *-nNscaeSupyjtT* ] [ *-I* 'directory' ] [ *-f* 'filename' | *-i* | 'cmd' ...]
 *nft* *-h*
 *nft* *-v*
 
-- 
2.34.1

