Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD847C25B48
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 11:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjJXLoH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 07:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjJXLoG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 07:44:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027F5F9
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 04:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MZQr1HBWKIWeJkzoLvqnhIgl3kREko2jFG2VzPshWtA=; b=BFNnmzcvGw5bAKF7IV0IDbry4a
        vB93xE8azdjFZ74U22p5seenMqjE1JbjNvZchHX7n9ffVbU2O/4oGeyoypd5MZIvfUcj1FnwpZwDc
        2FqYN9+P8oAMmmBpghk6O3N1EvkXpfH0H5qI2GI7Qa566iCh6HyvNVzpv20+DWwklnBlnQrqypFKp
        MR3D1gvBzCqRQ1i6KdeYJjbKDpgKs00a+hnImKVA2eSKFJU2I3uwl/2cK2mquaYb/lmawrmyQw/+m
        onKKOnmYaFT97TBLp/ptF247Ot6gmyr65yLPzF2B/lH0SNyx6Qq5201jiPCpNWdz/eyPiiSqezGai
        Pgy0TX7w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qvFpJ-00007E-Eq; Tue, 24 Oct 2023 13:44:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 2/2] extensions: string: Clarify description of --to
Date:   Tue, 24 Oct 2023 13:43:57 +0200
Message-ID: <20231024114357.23271-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231024114357.23271-1-phil@nwl.cc>
References: <20231024114357.23271-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since kernel commit c4eee56e14fe ("net: skb_find_text: Ignore patterns
extending past 'to'"), pattern scanning no longer happens past --to
offset even if skb_seq_read() returned a larger block. Point this out in
the description and also drop the '-1' offset which is not true as
kernel's selftest in tools/testing/selftests/netfilter/xt_string.sh
shows.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1707
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_string.man | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 2a470ece19c9d..bdeb0a6200a88 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -7,8 +7,9 @@ Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morri
 Set the offset from which it starts looking for any matching. If not passed, default is 0.
 .TP
 \fB\-\-to\fP \fIoffset\fP
-Set the offset up to which should be scanned. That is, byte \fIoffset\fP-1
-(counting from 0) is the last one that is scanned.
+Set the offset up to which should be scanned. That is, byte \fIoffset\fP
+(counting from 0) is the last one that is scanned and the maximum position of
+\fIpattern\fP's last character.
 If not passed, default is the packet size.
 .TP
 [\fB!\fP] \fB\-\-string\fP \fIpattern\fP
-- 
2.41.0

