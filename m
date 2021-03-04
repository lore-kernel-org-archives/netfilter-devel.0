Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF7DC433DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 874A16519A
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhCDBcn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhCDBcm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 20:32:42 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24A2C06175F
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:32:01 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 60CDF806B7;
        Thu,  4 Mar 2021 14:31:57 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614821517;
        bh=u4+Fjwsj0Z1uMCnhK7LMLILdZ6fNqNEsV+VxNoMMz08=;
        h=From:To:Cc:Subject:Date;
        b=vC5+5NRlE8pUiVTf5N7T6l0PZv49PNJUFCChsTzZplC7QSnzs56HCScLz4w1L+Q97
         Mo1JM8QlKdZGcX77bquMRMzkc3YwI/cRS8MxI3Nwule3DBG8fNwnck0jbAVJk+CSMh
         RcySMJhRep1sUIc6uD8pr0IT4ylh2bTaHzaMQzCWPoWIpoHWkb8PIJWX9a1EG3Bsjm
         SqHcebKpTItcXBBQq9nH1pCggqZRquaMV3cU54wcZSbbHB5+yeFkndqutuJPiy7/3D
         IviqHnD0fRoY24THt9GiKAGbtoBhHAS7ghIvQPvqCHUAZ9magl7+QBFX5KPkNGUFyk
         JN2V2UFjlwNZQ==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6040388d0000>; Thu, 04 Mar 2021 14:31:57 +1300
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 5BC4813EECD;
        Thu,  4 Mar 2021 14:32:08 +1300 (NZDT)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 39ABE341002; Thu,  4 Mar 2021 14:31:57 +1300 (NZDT)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH 0/3] Don't use RCU for x_tables synchronization
Date:   Thu,  4 Mar 2021 14:31:13 +1300
Message-Id: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=LRamHRUzJ3vSQRNnU0gA:9 a=AjGcO6oz07-iQ99wixmX:22 a=BPzZvq435JnGatEyYwdK:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The patches to change to using RCU synchronization in x_tables cause
updating tables to be slowed down by an order of magnitude. This has
been tried before, see https://lore.kernel.org/patchwork/patch/151796/
and ultimately was rejected. As mentioned in the patch description, a
different method can be used to ensure ordering of reads/writes. This
can simply be done by changing from smp_wmb() to smp_mb().

Mark Tomlinson (3):
  Revert "netfilter: x_tables: Update remaining dereference to RCU"
  Revert "netfilter: x_tables: Switch synchronization to RCU"
  netfilter: x_tables: Use correct memory barriers.

 include/linux/netfilter/x_tables.h |  7 ++---
 net/ipv4/netfilter/arp_tables.c    | 16 +++++-----
 net/ipv4/netfilter/ip_tables.c     | 16 +++++-----
 net/ipv6/netfilter/ip6_tables.c    | 16 +++++-----
 net/netfilter/x_tables.c           | 49 +++++++++++++++++++++---------
 5 files changed, 60 insertions(+), 44 deletions(-)

--=20
2.30.1

