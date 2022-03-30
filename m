Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60EBC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 15:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbiC3QB3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 12:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiC3QB2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 12:01:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8BC46B26
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 08:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WAaEfp1BdZkp4E6xjSKRIfIA0AnPtB1TSuslBJqwMSs=; b=b0kiyXp6KhFuAFrrMdzL019a2Q
        zOFA2YC/uX6TTtQq4LwfL4fZeHqlBtnSg75nLDr/uioc6D1LSIcmqtm6cQIbvMTwg9IcZ0IqpfTW9
        FdcFTutcG8bqpEzYBeWY6KmOkIHpkxUvPEXbosayKAr1aecoBUccYoCYjj48lhX6p34XfHkTIK3/e
        8OezfsBV/d6V7TTYS6vgphDDCakiz+JM8Hu3CeRa0YV8wH5tNRKyBEf1IdFWia2dxVJdc0bO40Qic
        QqFWaNnh6s2jgUBsFrLPL7tXC2DSs86Matna8Bf8R8Y6HbFjY4F4YfoR2oW+/kOiOgTfDRH6YoG7L
        jwq5JUog==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nZajV-0004ZO-FY; Wed, 30 Mar 2022 17:59:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 6/9] extensions: DNAT: Rename from libipt to libxt
Date:   Wed, 30 Mar 2022 17:58:48 +0200
Message-Id: <20220330155851.13249-7-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330155851.13249-1-phil@nwl.cc>
References: <20220330155851.13249-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prepare for merge of libipt and libip6t DNAT extensions, allow for
better code review.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/{libipt_DNAT.c => libxt_DNAT.c} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename extensions/{libipt_DNAT.c => libxt_DNAT.c} (100%)

diff --git a/extensions/libipt_DNAT.c b/extensions/libxt_DNAT.c
similarity index 100%
rename from extensions/libipt_DNAT.c
rename to extensions/libxt_DNAT.c
-- 
2.34.1

