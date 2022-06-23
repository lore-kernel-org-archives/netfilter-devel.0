Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7A6C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 15:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiFWPtg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 11:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiFWPtd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 11:49:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A89F43EE7
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 08:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2gMKjPx1bT7RBWmncIT3cvo1Hxck7IVxtek6va92YGw=; b=HC23CC5KF+uCNG2K+WW7f1YyWZ
        5pQqWE5qqqEHnZkb8DKxQ0NB7+b1qqTnapR7CcgYWqEZrW9rxX24M18vikKj/4zKPcPMZROWST13Q
        Xy8JfwJ3d3LAWZN9xiRr+MGSizc8uT4IEUfg1ovLKC4T++y611aW7bewWwxDp7U0PItl2CWDDAN+n
        8IEFCGAUbIMo9fFmgVZjtB2j/dyr4BB+g/PsEb6UraaAqFq+HmPNRLQqqJ3dcqYv3X8qDcfbnf6sI
        ndpSrzhqfgcyz4SqQnRfi7wIFFOyW5K+9yWBJ5nWw7GvTzGgMzdb9lRlG+/9mcZxJr0aQ+OtU+t+D
        ce0EiXmg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1o4P5E-0008Aj-T3; Thu, 23 Jun 2022 17:49:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] doc: Document limitations of ipsec expression with xfrm_interface
Date:   Thu, 23 Jun 2022 17:49:20 +0200
Message-Id: <20220623154920.25902-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Point at a possible solution to match IPsec info of locally generated
traffic routed to an xfrm-type interface.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/primary-expression.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index f97778b9762b5..4d6b0878b2529 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -428,6 +428,10 @@ Destination address of the tunnel|
 ipv4_addr/ipv6_addr
 |=================================
 
+*Note:* When using xfrm_interface, this expression is not useable in output
+hook as the plain packet does not traverse it with IPsec info attached - use a
+chain in postrouting hook instead.
+
 NUMGEN EXPRESSION
 ~~~~~~~~~~~~~~~~~
 
-- 
2.34.1

