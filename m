Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2BE2C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Jun 2023 11:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjFKLch (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Jun 2023 07:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjFKLcf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Jun 2023 07:32:35 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CEFE74
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jun 2023 04:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+NA/uuGlN3tFL07fO1/gbFiLn01hs1oxOeEwUMhmmNg=; b=pzRIwk8WmWL7LN6dP6PZBcnXaF
        hT0aySwEM/apMh6kZWc1tOjyP8hCJfSoqQRaqslTDiawexZmTXdof2B08GwXt1tw0i8sLCcMyRvS0
        QCMvDAoFhhHtfkNIxcjrLFRPelv0l5XgrpwU37QWThCoM5aKphHg/SgUiu4NsCmRM+3w4DXwlSOi/
        7UL+xiMnhpTalWNA+9gb3YYg+524p/FacbiXIb0kXgyu9ebZ7sgE8FlwhSglDHZUcgX9clGe+/G1E
        Lj5DgXuaDZB8tKEfm9eV3JANzSF6MmLOc6Hll7g0XyHC06JbpyoQoqGIdYRQULoQ21nbDjhsTl0Cx
        tK4NTsJQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q8JJ8-005h2r-LY
        for netfilter-devel@vger.kernel.org; Sun, 11 Jun 2023 12:32:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables] man: string: document BM false negatives
Date:   Sun, 11 Jun 2023 12:31:13 +0100
Message-Id: <20230611113113.633418-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230611083805.622038-1-jeremy@azazel.net>
References: <20230611083805.622038-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For non-linear skb's there's a possibility that the kernel's Boyer-Moore
text-search implementation may miss matches.  There's a warning about
this in the kernel source.  Include that warning in the man-page.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_string.man | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 5f1a993c57eb..34a8755ba14e 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -29,3 +29,18 @@ iptables \-A INPUT \-p tcp \-\-dport 80 \-m string \-\-algo bm \-\-string 'GET /
 # The hex string pattern can be used for non-printable characters, like |0D 0A| or |0D0A|.
 .br
 iptables \-p udp \-\-dport 53 \-m string \-\-algo bm \-\-from 40 \-\-to 57 \-\-hex\-string '|03|www|09|netfilter|03|org|00|'
+.P
+Note: Since Boyer-Moore (BM) performs searches for matchings from right to left
+and the kernel may store a packet in multiple discontiguous blocks, it's still
+possible that a match could be spread over multiple blocks, in that case this
+algorithm won't find it.
+.P
+If you wish to ensure that such thing won't ever happen, use the
+Knuth-Pratt-Morris (KMP) implementation instead. In conclusion, choose the
+proper string search algorithm depending on your setting.
+.P
+Say you're using the textsearch infrastructure for filtering, NIDS or any
+similar security focused purpose, then go KMP. Otherwise, if you really care
+about performance, say you're classifying packets to apply Quality of Service
+(QoS) policies, and you don't mind about possible matchings spread over multiple
+fragments, then go BM.
-- 
2.39.2

