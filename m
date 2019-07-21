Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C3AC76186
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B7D7206DD
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfGUARz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 20:17:55 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48890 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfGUARy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 20:17:54 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hozY1-0001iR-Qu; Sun, 21 Jul 2019 02:17:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/3] fix crash bug during rule restore
Date:   Sun, 21 Jul 2019 02:14:04 +0200
Message-Id: <20190721001406.23785-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

https://bugzilla.netfilter.org/show_bug.cgi?id=1351 

nft -f <<EOF
flush ruleset       

table inet filter {
}
table inet filter {
      chain test {
        counter
    }
}
EOF

segfaults during error reporting.
First patch makes error handling more robust.
Second patch passes the right handle -- with above ruleset this
highlights "chain test" in the resulting error message.

Last patch skips rule cache updates for invalid op to restore
the 0.9.0 behaviour.



