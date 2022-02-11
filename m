Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6495C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Feb 2022 17:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351949AbiBKRMd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Feb 2022 12:12:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242158AbiBKRMc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Feb 2022 12:12:32 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315B72E8
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Feb 2022 09:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ziJWJz40s6QsX13iaXocu5J9yMwCUaOYTMSoS4CU1a0=; b=gEBp98MVqi8VrgcIkf3tI5ir+l
        umMj7kVAJCCnAgokOyNoGU030pV0B8/13wnndIxpok8mn8FK3vPZnQM4ke8ZU2iSQbpn42EhxkGhO
        W1jzxI7GSHx5UJm5KEz385NFjThKpCzi9hgYjJH4zTcQcPGfYC1WvjIrsLDALlwsxKB32R1OztV+N
        pRMCT1VkDZ6R/I5TP39WwE4LW87cAAHimJPmAzmzD3q0rc6rRpeyhNdMzuvvY5N7ngX1PSsd9q5E1
        NyvpaA0ebvCMihiMUsPj0AXu3HLNUK9ilcCQs3NPp/sAgwkrYMPgEToiweVtmlwNAL49SnStE/cRy
        LyXFnlrg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nIZTB-0006UD-GY; Fri, 11 Feb 2022 18:12:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/2] Improve error messages for unsupported extensions
Date:   Fri, 11 Feb 2022 18:12:09 +0100
Message-Id: <20220211171211.26484-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Failure to load an extension leads to iptables cmdline parser
complaining about any extension options instead of the extension itself.
This is at least misleading.

This series eliminates the odd error message and instead adds a warning
if a requested extension is not available at all in kernel.

Things are a bit complicated due to the fact that newer kernels not
necessarily support revision 0 of all extensions. So change iptables
first to only register revision 0 if no higher one was accepted earlier.
This allows for a "not even revision 0 is supported" logic.

Phil Sutter (2):
  libxtables: Register only the highest revision extension
  Improve error messages for unsupported extensions

 iptables/nft.c       | 12 +++++++++---
 libxtables/xtables.c | 17 ++++++++++++++---
 2 files changed, 23 insertions(+), 6 deletions(-)

-- 
2.34.1

