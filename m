Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32672C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiJFA2n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJFA2l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC35382869
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lteRgB2mr3KZSywBymYj9UsnKO0isSEHak12GkyCO0k=; b=bO24bEdfhefdyG44bh+HPaytfW
        btef9UomRYHNfJboxvq1nx5iZxrrvbFibdDu7LNvtAWM6NPt6sQzrRJYya3myUpjrutBqIM9/qViO
        cI9G3MHsVrFHzhDGiF85CKYGKkgbDvAWWwoY4kmXbjgiBto6Cqd7mXBJa8Q4T8xT2q32ZxLqc3dB6
        q+QFgHn3InJpn5RMb3jqKnrfZm4amS3owmbpeZ7BoQMvtAoKKhirk1GQGsFY3vpH8BpTkTszubFUG
        v+S6hqHJ6F4r3Nx+86k4dsAfQfHC7YViHXRbeKd49regurYwhfvzMNjo89roGcV/xg6FDicngMeOR
        3b109erw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEkf-0001xA-OV; Thu, 06 Oct 2022 02:28:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 07/12] tests: libxt_recent.t: Add missing default values
Date:   Thu,  6 Oct 2022 02:27:57 +0200
Message-Id: <20221006002802.4917-8-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_recent.t | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_recent.t b/extensions/libxt_recent.t
index 9a83918ea5835..ce85b91bf9ac6 100644
--- a/extensions/libxt_recent.t
+++ b/extensions/libxt_recent.t
@@ -1,8 +1,8 @@
 :INPUT,FORWARD,OUTPUT
--m recent --set;=;OK
+-m recent --set;-m recent --set --name DEFAULT --rsource;OK
 -m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource;=;OK
 -m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
--m recent --update --rttl;=;OK
+-m recent --update --rttl;-m recent --update --rttl --name DEFAULT --mask 255.255.255.255 --rsource;OK
 -m recent --set --rttl;;FAIL
 -m recent --rcheck --hitcount 999 --name foo --mask 255.255.255.255 --rsource;;FAIL
 # nonsensical, but all should load successfully:
-- 
2.34.1

