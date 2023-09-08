Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5822EC875F
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 00:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbjIHAWj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 20:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjIHAWj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 20:22:39 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06041BCD;
        Thu,  7 Sep 2023 17:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6U37vgAi21aBLWUqc88l4JhtDvwt31YLjg2tK0L7p9o=; b=MdlZJJummBPPdoI1fk/Sz4eNF3
        DFiv9dGZCL6Cx/SdQ2s/olqlekSLYKKgPcUE4jqc920+nXjLcf1T4V0M8xEjySZOP+BVh+sGfBb2+
        EwIdUTCzLnQRV1D2ZBUqJ4UkCUCCbBdyyNd2OGyr4ee/Kr9DEHoWv54CWD5Rk9XdMUYU6OmpwuFpp
        by2tVUI9otuqcvoyz+EvPkL8TCKIyqIsFzdFWIR84t2GLy1flbu4YaHkvD7xAfkWt8GxSu+WEPC3H
        bn5DQGF8gxy9V+z6xhuQeb+42sB2+Y702CokYc3x/TB893VbY2pMiRAOajdBDFACVJW6MFxrmy05d
        v/B73H0A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qePGa-000055-US; Fri, 08 Sep 2023 02:22:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org
Subject: [nf PATCH 0/2] nf_tables: follow-up on audit fix, propose kselftest
Date:   Fri,  8 Sep 2023 02:22:27 +0200
Message-ID: <20230908002229.1409-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 fixes/improves Pablo's fix for the bug I built into nf_tables'
audit support code. I propose it for nf, but nf-next is OK from my PoV
if it is deemed too risky.

Patch 2 adds a selftest for the audit notifications in nf_tables. Since
audit logging can not be turned off, it may cause problems requiring a
reboot to resolve. So I'd like to hear your opinions first before
attempting an "official" proposal.

Phil Sutter (2):
  netfilter: nf_tables: Fix entries val in rule reset audit log
  selftests: netfilter: Test nf_tables audit logging

 net/netfilter/nf_tables_api.c                 | 21 ++++--
 .../testing/selftests/netfilter/nft_audit.sh  | 75 +++++++++++++++++++
 2 files changed, 88 insertions(+), 8 deletions(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_audit.sh

-- 
2.41.0

