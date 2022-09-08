Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BE4C54EE9
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Sep 2022 15:13:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiIHPM7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 11:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbiIHPMx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 11:12:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4898FF3BCE
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2022 08:12:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oWJCy-0005ZO-Bc; Thu, 08 Sep 2022 17:12:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH iptables-nft 0/3] nft: prefer meta pkttype to libxt_pkttype
Date:   Thu,  8 Sep 2022 17:12:39 +0200
Message-Id: <20220908151242.26838-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

low hanging fruit: use native meta+cmp instead of libxt_pkttype.
First patch adds dissection, second patch switches to native expression.

Last patch adds support for 'otherhost' mnemonic, useless for iptables
but useful for ebtables.




