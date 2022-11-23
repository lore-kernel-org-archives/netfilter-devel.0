Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E0AC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239082AbiKWQoa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239140AbiKWQoW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A056488F82
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uPOaYyEpjRmI/CcWzxez884C3cOLcpwwgqRrl5LaA08=; b=EHThgDoMv3mGWv8MCgTLQHj1wU
        wR15BLf+A7ba2B7vQvjwBJHNU1snZst5qugC1JKmm1lHcVzqMJaKykOZjuxYfTF4hII/aWLZs6mxj
        vJSA00V+X3w9qSMgeCzu4IT1lGR2GZzwAEqLxWG2Uc70sZeGJtgx0d+IFwFwR1K3H41NORPTtr0rk
        YzSB5wV93tyuZLNC7u/jlURVLtGzyD670OaqlkUBNpw/OTK7PXkx4g+e6n/ewYFBxyNlRE7/xWQis
        g37+/W2xDRl0GKwJ4KEI5y97GUciSwBRwJlCPnUSK7EYfBllRNxlkgFmDWZR/XJfTAS/2wWd2Praq
        RR5DZtew==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsrE-0003xB-3T
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:20 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 09/13] extensions: ecn: Sanitize xlate callback
Date:   Wed, 23 Nov 2022 17:43:46 +0100
Message-Id: <20221123164350.10502-10-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Catch unexpected values in einfo->ip_ect.

Fixes: ca42442093d3d ("iptables: extensions: libxt_ecn: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_ecn.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
index ad3c7a0307a0d..83a4acfab7da7 100644
--- a/extensions/libxt_ecn.c
+++ b/extensions/libxt_ecn.c
@@ -156,6 +156,8 @@ static int ecn_xlate(struct xt_xlate *xl,
 		case 3:
 			xt_xlate_add(xl, "ce");
 			break;
+		default:
+			return 0;
 		}
 	}
 	return 1;
-- 
2.38.0

