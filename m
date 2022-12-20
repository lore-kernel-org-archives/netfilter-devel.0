Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166DEC4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Dec 2022 15:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiLTPjE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 10:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiLTPjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 10:39:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD1A1CFE7
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2022 07:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/U/k8WOCM7ZuKX2hKZoTLcMiQHkz17B/y/+z3Nk2H50=; b=ZHU9UepnJpNt0kdfYVlZTe292m
        WYgHDc7a2atNJ1h551yNQYxluVbgsXY+ZkiXU0wWpg1JieQ0WSyOB0BWAUPWoWWY4BmmXzs0DDyxP
        1Z6HL3vhgvtFw0xYgCtag9i5ZaB3+/L5CGO6jozwo/V7O1+l3OpoSjZmmAajh9fk0k6Ix4lQ5dxTj
        eTey7bcTAkD3R5xzbzj6UfQvJu8/htbNAe1yNmv2nIN5GNOAz+SI6HrLfAWWCVzn3frDp/hea2ExJ
        6It02fwGNDdusFW24LJTc7i04pHqAPfvFAamA08q6xMa/CToPIQ5hjKvYSxXUIHe1Qbsz2ovLYH+z
        TyRl3Zpw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p7ehk-0000FQ-22; Tue, 20 Dec 2022 16:38:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 0/4] Fix some minor bugs
Date:   Tue, 20 Dec 2022 16:38:43 +0100
Message-Id: <20221220153847.24152-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All these were identified by Covscan.

Phil Sutter (4):
  conntrack: Fix potential array out of bounds access
  conntrack: Fix for unused assignment in do_command_ct()
  conntrack: Fix for unused assignment in ct_save_snprintf()
  conntrack: Sanitize free_tmpl_objects()

 src/conntrack.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.38.0

