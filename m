Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB93EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjHBCGF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjHBCGE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:06:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6128213D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Hi5kUFvESbkyFBH+RQcgBdV1ob9dRSPMlqhMTkO3mrE=; b=SsZmS+1q/JDM8QSFvtKAgL2qW1
        +oJd2xhIs1wwQZXf8SEqvwee15eQJ19XRFXU80EEl+ZuQcL6CSuhYvAf+GjrpW9R6Y9XCx+xAIdgw
        myuJ+AX08KwLx6/PT4axgndJfCDlUzcfL19H+9G7U79qGGTTM2opOdUBRvq+XolR7qSwwYQ85wiRi
        ryG+4+cdjz10E+/l8ytihDhk6JSvLxouUpGBtE7HdCnjRCBr7ibhA4/aqHUFc+fXxPf1TutKcA5OE
        MTAS9sMXXJ5wHEmDsH7Ckzo6uEeNssZj6cMgCcAPFNkTTO5lMRp3j77QvnvmYsSxO+aOHIvgEFD53
        e8F7V7hQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1FR-0002vB-3l
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 04:06:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] tests: libipt_icmp.t: Enable tests with numeric output
Date:   Wed,  2 Aug 2023 04:05:47 +0200
Message-Id: <20230802020547.28886-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020547.28886-1-phil@nwl.cc>
References: <20230802020547.28886-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unrelated to the question whether numeric (save) output is desired or
not, enable the tests and expect the known format.

Using --list without --numeric prints the names, BTW.

Fixes: 49d5b7277c7f2 ("extensions: libipt_icmp: add unit test")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_icmp.t | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/extensions/libipt_icmp.t b/extensions/libipt_icmp.t
index 08692900dba12..3c97cf4e06128 100644
--- a/extensions/libipt_icmp.t
+++ b/extensions/libipt_icmp.t
@@ -1,11 +1,8 @@
 :INPUT,FORWARD,OUTPUT
 -p icmp -m icmp --icmp-type any;=;OK
-# output uses the number, better use the name?
-# ERROR: cannot find: iptables -I INPUT -p icmp -m icmp --icmp-type echo-reply
-# -p icmp -m icmp --icmp-type echo-reply;=;OK
-# output uses the number, better use the name?
-# ERROR: annot find: iptables -I INPUT -p icmp -m icmp --icmp-type destination-unreachable
-# -p icmp -m icmp --icmp-type destination-unreachable;=;OK
+# XXX: output uses the number, better use the name?
+-p icmp -m icmp --icmp-type echo-reply;-p icmp -m icmp --icmp-type 0;OK
+-p icmp -m icmp --icmp-type destination-unreachable;-p icmp -m icmp --icmp-type 3;OK
 # it does not acccept name/name, should we accept this?
 # ERROR: cannot load: iptables -A INPUT -p icmp -m icmp --icmp-type destination-unreachable/network-unreachable
 # -p icmp -m icmp --icmp-type destination-unreachable/network-unreachable;=;OK
-- 
2.40.0

