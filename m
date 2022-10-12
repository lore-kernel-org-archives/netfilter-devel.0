Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73952C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJLPSo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiJLPSW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:18:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D6ACA881
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=q5wglFY7yBlDtkeTv0nNUh7li+MlaoTr40C0fI5FKEg=; b=C1AiG43cChlRcJF8mx7EEOUyn1
        gVP2q3ORvHnyjmPki1KU6CbCMjclNgAOPQ3TYkbXsHdYyiJxWM7k6PxWb0rEGOix7tepggw4tic2u
        W7SmKwAWTjahE00RUNozF8BeyMUwsyKOdE7NyAtY8Nn4soAalJ16mSZ6ZdlLv/U++nKYp6Fqw+NHZ
        b+4vQ9/1Mf75zTfRUmIoqOcQQzv2OLJmILbb6MObUNP9vsuYfzhFDAtzps1n/0ilSqNrBzWQr6DmM
        v1jTrR202HGMjkKwMLsbYhEh2oD9DFTmB82pNF/0N+0IgGrHdpC8vwO+5Hf1M8SeQv2kxKb0jHfIF
        7zV1sZJw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidUp-0002oZ-Ed; Wed, 12 Oct 2022 17:18:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 05/12] tests: *.t: Fix for hexadecimal output
Date:   Wed, 12 Oct 2022 17:17:55 +0200
Message-Id: <20221012151802.11339-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use hex input to avoid having to specify an expected output in trivial
cases.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DSCP.t     | 2 +-
 extensions/libxt_MARK.t     | 2 +-
 extensions/libxt_connmark.t | 4 ++--
 extensions/libxt_dscp.t     | 2 +-
 extensions/libxt_mark.t     | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/extensions/libxt_DSCP.t b/extensions/libxt_DSCP.t
index fcc55986dbcd7..762fcd31d4d28 100644
--- a/extensions/libxt_DSCP.t
+++ b/extensions/libxt_DSCP.t
@@ -1,6 +1,6 @@
 :PREROUTING,INPUT,FORWARD,OUTPUT,POSTROUTING
 *mangle
--j DSCP --set-dscp 0;=;OK
+-j DSCP --set-dscp 0x00;=;OK
 -j DSCP --set-dscp 0x3f;=;OK
 -j DSCP --set-dscp -1;;FAIL
 -j DSCP --set-dscp 0x40;;FAIL
diff --git a/extensions/libxt_MARK.t b/extensions/libxt_MARK.t
index 9d1aa7d7d58a4..2902a14f06742 100644
--- a/extensions/libxt_MARK.t
+++ b/extensions/libxt_MARK.t
@@ -1,6 +1,6 @@
 :INPUT,FORWARD,OUTPUT
 -j MARK --set-xmark 0xfeedcafe/0xfeedcafe;=;OK
--j MARK --set-xmark 0;=;OK
+-j MARK --set-xmark 0x0;=;OK
 -j MARK --set-xmark 4294967295;-j MARK --set-xmark 0xffffffff;OK
 -j MARK --set-xmark 4294967296;;FAIL
 -j MARK --set-xmark -1;;FAIL
diff --git a/extensions/libxt_connmark.t b/extensions/libxt_connmark.t
index 4dd7d9af265a5..353970a8995f6 100644
--- a/extensions/libxt_connmark.t
+++ b/extensions/libxt_connmark.t
@@ -2,8 +2,8 @@
 *mangle
 -m connmark --mark 0xffffffff;=;OK
 -m connmark --mark 0xffffffff/0xffffffff;-m connmark --mark 0xffffffff;OK
--m connmark --mark 0xffffffff/0;=;OK
--m connmark --mark 0/0xffffffff;-m connmark --mark 0;OK
+-m connmark --mark 0xffffffff/0x0;=;OK
+-m connmark --mark 0/0xffffffff;-m connmark --mark 0x0;OK
 -m connmark --mark -1;;FAIL
 -m connmark --mark 0xfffffffff;;FAIL
 -m connmark;;FAIL
diff --git a/extensions/libxt_dscp.t b/extensions/libxt_dscp.t
index 38d7f04e18698..e010190661ae8 100644
--- a/extensions/libxt_dscp.t
+++ b/extensions/libxt_dscp.t
@@ -1,5 +1,5 @@
 :INPUT,FORWARD,OUTPUT
--m dscp --dscp 0;=;OK
+-m dscp --dscp 0x00;=;OK
 -m dscp --dscp 0x3f;=;OK
 -m dscp --dscp -1;;FAIL
 -m dscp --dscp 0x40;;FAIL
diff --git a/extensions/libxt_mark.t b/extensions/libxt_mark.t
index 7c005379f6d64..7aeb871588ca6 100644
--- a/extensions/libxt_mark.t
+++ b/extensions/libxt_mark.t
@@ -1,6 +1,6 @@
 :INPUT,FORWARD,OUTPUT
 -m mark --mark 0xfeedcafe/0xfeedcafe;=;OK
--m mark --mark 0;=;OK
+-m mark --mark 0x0;=;OK
 -m mark --mark 4294967295;-m mark --mark 0xffffffff;OK
 -m mark --mark 4294967296;;FAIL
 -m mark --mark -1;;FAIL
-- 
2.34.1

