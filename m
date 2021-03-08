Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B6DC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFCF565146
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhCHBZL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Mar 2021 20:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhCHBYj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Mar 2021 20:24:39 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F2EC06174A
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Mar 2021 17:24:39 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C5933891AE;
        Mon,  8 Mar 2021 14:24:34 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1615166674;
        bh=ABabwrGZph5Afo5RyJHi6FSG681DtoXzWh8yvDMtmxY=;
        h=From:To:Cc:Subject:Date;
        b=Ag879LDN87DRqRqwn2EjXNq2A3iwG787V1/fCaA4gc3OlUULBEpDXnMK7ygEEsNbZ
         Dh+FssSN/BKx8AUPo7sNU/zGV4EpSNLWn+yUibVVGzS+LsboieNXEVWd6LDM+LcvDX
         KHhYnC8V6dqEM88A9apY43HB3lp0b+aDH+Y18pcMebOu7oOE0do1tAaowUJwnqKXin
         l4TeRUSpVRjpBGwW9Qx2BcSihzIE5ED8HZHXA+uiNF5lhdGD+uMLrOnDqa4YAW9N97
         dXliRjv4SxOezvBeCcZvSelNotF0ipYIU8RBtX8MD8HdA3kYmYdsjqd4wqhjMpbTVW
         dZkMIBeFmOtWw==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60457cd20000>; Mon, 08 Mar 2021 14:24:34 +1300
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 8FD4713EEFA;
        Mon,  8 Mar 2021 14:24:46 +1300 (NZDT)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 97505340F85; Mon,  8 Mar 2021 14:24:34 +1300 (NZDT)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     subashab@codeaurora.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH v2 0/3] Don't use RCU for x_tables synchronization
Date:   Mon,  8 Mar 2021 14:24:10 +1300
Message-Id: <20210308012413.14383-1-mark.tomlinson@alliedtelesis.co.nz>
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

changes in v2:
- Update commit messages only

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

