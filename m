Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F00C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiJFA3E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJFA3D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:29:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C27582D13
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2y+3HFYXAhJLiQ7WWTnacZTz4oGoSuABTWjXDK0nFkg=; b=o/1fzoYpnl7OljNuYPiSBI22Ad
        urg7MQ8trf5EYKxiJJOd5kstoJlEDFvLgvbcURAr2L6tIcu/8pRPFaeVgy5gZCu8kwwzCBy5MMNLe
        q0SGlj6tuGdltDOAr8WLUn+/Ui/NzIR8LAlT4vAHiqHMM6lvAjCGsbMQ6DnEIYOXk1TE3lZtRRHyh
        IQ1yx2pX+dUlWDjPNUSqBPnMpbl1LJWfC4k1TbuKMuDWVMW6SZHpb692MoHqjECMsOrvVbLzmqbyl
        AjI0oVCRPdgFaWdJgFVwvwy52b8ESBpl9J2UAHWEi1IoBt2pLxTB385cwrNjIJ/pZs0h1CCs5oLG/
        gw4X5B2A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEl0-0001zW-Uc; Thu, 06 Oct 2022 02:28:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 08/12] tests: libxt_tos.t, libxt_TOS.t: Add missing masks in output
Date:   Thu,  6 Oct 2022 02:27:58 +0200
Message-Id: <20221006002802.4917-9-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mask differs between numeric --set-tos values and symbolic ones, make
sure it is covered by the tests.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_TOS.t | 12 ++++++------
 extensions/libxt_tos.t |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_TOS.t b/extensions/libxt_TOS.t
index ae8531cc582e2..9f8e33fda7116 100644
--- a/extensions/libxt_TOS.t
+++ b/extensions/libxt_TOS.t
@@ -1,15 +1,15 @@
 :PREROUTING,INPUT,FORWARD,OUTPUT,POSTROUTING
 *mangle
--j TOS --set-tos 0x1f;=;OK
+-j TOS --set-tos 0x1f;-j TOS --set-tos 0x1f/0xff;OK
 -j TOS --set-tos 0x1f/0x1f;=;OK
 # maximum TOS is 0x1f (5 bits)
 # ERROR: should fail: iptables -A PREROUTING -t mangle -j TOS --set-tos 0xff
 # -j TOS --set-tos 0xff;;FAIL
--j TOS --set-tos Minimize-Delay;-j TOS --set-tos 0x10;OK
--j TOS --set-tos Maximize-Throughput;-j TOS --set-tos 0x08;OK
--j TOS --set-tos Maximize-Reliability;-j TOS --set-tos 0x04;OK
--j TOS --set-tos Minimize-Cost;-j TOS --set-tos 0x02;OK
--j TOS --set-tos Normal-Service;-j TOS --set-tos 0x00;OK
+-j TOS --set-tos Minimize-Delay;-j TOS --set-tos 0x10/0x3f;OK
+-j TOS --set-tos Maximize-Throughput;-j TOS --set-tos 0x08/0x3f;OK
+-j TOS --set-tos Maximize-Reliability;-j TOS --set-tos 0x04/0x3f;OK
+-j TOS --set-tos Minimize-Cost;-j TOS --set-tos 0x02/0x3f;OK
+-j TOS --set-tos Normal-Service;-j TOS --set-tos 0x00/0x3f;OK
 -j TOS --and-tos 0x12;-j TOS --set-tos 0x00/0xed;OK
 -j TOS --or-tos 0x12;-j TOS --set-tos 0x12/0x12;OK
 -j TOS --xor-tos 0x12;-j TOS --set-tos 0x12/0x00;OK
diff --git a/extensions/libxt_tos.t b/extensions/libxt_tos.t
index ccbe80099bdd9..6cceeeb4adbd8 100644
--- a/extensions/libxt_tos.t
+++ b/extensions/libxt_tos.t
@@ -4,10 +4,10 @@
 -m tos --tos Maximize-Reliability;-m tos --tos 0x04/0x3f;OK
 -m tos --tos Minimize-Cost;-m tos --tos 0x02/0x3f;OK
 -m tos --tos Normal-Service;-m tos --tos 0x00/0x3f;OK
--m tos --tos 0xff;=;OK
--m tos ! --tos 0xff;=;OK
--m tos --tos 0x00;=;OK
--m tos --tos 0x0f;=;OK
+-m tos --tos 0xff;-m tos --tos 0xff/0xff;OK
+-m tos ! --tos 0xff;-m tos ! --tos 0xff/0xff;OK
+-m tos --tos 0x00;-m tos --tos 0x00/0xff;OK
+-m tos --tos 0x0f;-m tos --tos 0x0f/0xff;OK
 -m tos --tos 0x0f/0x0f;=;OK
 -m tos --tos wrong;;FAIL
 -m tos;;FAIL
-- 
2.34.1

