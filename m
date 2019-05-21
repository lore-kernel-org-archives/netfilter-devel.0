Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBA8C04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ED58216B7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbfEULbO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 07:31:14 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35484 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfEULbO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 07:31:14 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hT2z9-0008TU-TI; Tue, 21 May 2019 13:31:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     marcmicalizzi@gmail.com
Subject: [PATCH nf 0/5] netfilter: flow table fixes
Date:   Tue, 21 May 2019 13:24:29 +0200
Message-Id: <20190521112434.11767-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This series fixes several issues I spotted while investigating
a 'tcp connection stalls with flow offload on' bug report.

I'm not sure if the original problem is fixed, however, the test script
in patch 5 will fail without the fixes from patches 1 and 2.

Patches 3 and 4 fix additional problems, however, these are by code
review only.

Florian Westphal (5):
      netfilter: nf_flow_table: ignore DF bit setting
      netfilter: nft_flow_offload: set liberal tracking mode for tcp
      netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
      netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
      selftests: netfilter: add flowtable test script

 net/netfilter/nf_flow_table_ip.c                   |    3 
 net/netfilter/nft_flow_offload.c                   |   31 +-
 tools/testing/selftests/netfilter/Makefile         |    2 
 tools/testing/selftests/netfilter/nft_flowtable.sh |  324 +++++++++++++++++++++

