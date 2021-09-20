Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2967C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 20:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B94A761100
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Sep 2021 20:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhITUsO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Sep 2021 16:48:14 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:40598 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhITUqO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Sep 2021 16:46:14 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 3DB11806A8;
        Tue, 21 Sep 2021 08:44:43 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1632170683;
        bh=A3hXOjI+P/TxKzBQBrxWgNBplidSCkfNmRVI7sFeCRk=;
        h=From:To:Cc:Subject:Date;
        b=OUgUEkNfiEuJlNhDPYX+/vkGBehSJGciLrUl4ZYUA5CMhtvOAjF9/BtIUozlwSNCs
         6adS34t5ttiIvCToNnwDz4gJTI6vBiBUYwqYIAewgS55ly18V/wWkdnppYkvOhJfOM
         H9uG8LTstVdhnlPKOBB2LjWhokWfCZ9C/1w5WRP7q30fhRGx81da15r5OeAthYV1KT
         cgP5C2US97LzY9TRRgFudmFn0GdY22bSbENWMgaQv2SBk2ivjp14EouOdAwaCG2TQs
         VEdX+M40gxphYrLgybXQDglIxzRqcBak2tkC36Q+dXA8qOiHsiCd/CBNzfgIyrAH0Q
         huuE8kC4z1Nyw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6148f2ba0000>; Tue, 21 Sep 2021 08:44:42 +1200
Received: from coled-dl.ws.atlnz.lc (coled-dl.ws.atlnz.lc [10.33.25.26])
        by pat.atlnz.lc (Postfix) with ESMTP id D8FA913EE39;
        Tue, 21 Sep 2021 08:44:42 +1200 (NZST)
Received: by coled-dl.ws.atlnz.lc (Postfix, from userid 1801)
        id D2DF7242827; Tue, 21 Sep 2021 08:44:42 +1200 (NZST)
From:   Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org, shuah@kernel.org
Cc:     linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Cole Dishington <Cole.Dishington@alliedtelesis.co.nz>
Subject: [PATCH net v6 0/2] Fix port selection of FTP for NF_NAT_RANGE_PROTO_SPECIFIED
Date:   Tue, 21 Sep 2021 08:44:37 +1200
Message-Id: <20210920204439.13179-1-Cole.Dishington@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=FtN7AFjq c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=7QKq2e-ADPsA:10 a=8zFdtlccS6W11XtEw-MA:9 a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for your time reviewing!

Changes:
- Fix compiler warning in 1/2 patch.
- Add Acked-by: Florian Westphal <fw@strlen.de> to 1/2 and 2/2.

Cole Dishington (2):
  net: netfilter: Limit the number of ftp helper port attempts
  net: netfilter: Fix port selection of FTP for
    NF_NAT_RANGE_PROTO_SPECIFIED

 include/net/netfilter/nf_nat.h |  6 ++++
 net/netfilter/nf_nat_core.c    |  9 ++++++
 net/netfilter/nf_nat_ftp.c     | 51 ++++++++++++++++++++++++++--------
 net/netfilter/nf_nat_helper.c  | 10 +++++++
 4 files changed, 65 insertions(+), 11 deletions(-)

--=20
2.33.0

