Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA68C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJFA3K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJFA3I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:29:08 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0D284E5D
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gyIZCY1tMM8VLjMj6gB0eOwbo8ZziiLcwhOtLd/HHGw=; b=GE63awukg25Br3DoDg2J9on6qr
        QrEBlT/id1oiXGnOXAzFvAO4PMo45RPBXYTVq3kptdThee1dDsEGtfND/kbwitTjRE34kyNmziSHu
        Y4jBxnyOUbGJ4bI1x3UrktzHw0lCTQ47h/CNLAK7WvF+CE8r2ykUkbR3hCI2h8oXGv6lJMGQymX6P
        dhHhahAvfZmViRire2QMDAO2aV2N6/mUpgNpSNEwAPrravp80f/Ne74dRWcf+NRLWTx/pq14JxJXJ
        27nItYWohmYnJbMI7yY3AsgoGv9AhxXpszuRKK6j6A8pexnQvJlw40zkh54Dsz826coCkc41s4Z0g
        L9SuC1KQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEl6-0001zd-8G; Thu, 06 Oct 2022 02:29:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 10/12] tests: libxt_connlimit.t: Add missing --connlimit-saddr
Date:   Thu,  6 Oct 2022 02:28:00 +0200
Message-Id: <20221006002802.4917-11-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This default option is included in output and it is not intuitive enough
to omit it. So extend the test cases to cover for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_connlimit.t | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_connlimit.t b/extensions/libxt_connlimit.t
index c7ea61e95fbc8..23bba69474fed 100644
--- a/extensions/libxt_connlimit.t
+++ b/extensions/libxt_connlimit.t
@@ -1,11 +1,11 @@
 :INPUT,FORWARD,OUTPUT
--m connlimit --connlimit-upto 0;=;OK
--m connlimit --connlimit-upto 4294967295;=;OK
--m connlimit --connlimit-upto 4294967296;;FAIL
+-m connlimit --connlimit-upto 0;-m connlimit --connlimit-upto 0 --connlimit-saddr;OK
+-m connlimit --connlimit-upto 4294967295 --connlimit-saddr;=;OK
+-m connlimit --connlimit-upto 4294967296 --connlimit-saddr;;FAIL
 -m connlimit --connlimit-upto -1;;FAIL
--m connlimit --connlimit-above 0;=;OK
--m connlimit --connlimit-above 4294967295;=;OK
--m connlimit --connlimit-above 4294967296;;FAIL
+-m connlimit --connlimit-above 0;-m connlimit --connlimit-above 0 --connlimit-saddr;OK
+-m connlimit --connlimit-above 4294967295 --connlimit-saddr;=;OK
+-m connlimit --connlimit-above 4294967296 --connlimit-saddr;;FAIL
 -m connlimit --connlimit-above -1;;FAIL
 -m connlimit --connlimit-upto 1 --conlimit-above 1;;FAIL
 -m connlimit --connlimit-above 10 --connlimit-saddr;-m connlimit --connlimit-above 10 --connlimit-mask 32 --connlimit-saddr;OK
-- 
2.34.1

