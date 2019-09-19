Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24764C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 22:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0106B206C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 22:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389100AbfISWxp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 18:53:45 -0400
Received: from dd34104.kasserver.com ([85.13.151.79]:45012 "EHLO
        dd34104.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389036AbfISWxp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 18:53:45 -0400
X-Greylist: delayed 584 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2019 18:53:45 EDT
Received: from dd34104.kasserver.com (dd0800.kasserver.com [85.13.143.204])
        by dd34104.kasserver.com (Postfix) with ESMTPSA id A1DA56C80A81
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 00:44:00 +0200 (CEST)
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-SenderIP: 89.244.171.226
User-Agent: ALL-INKL Webmail 2.11
Subject: [BUG] nft: "XT target TCPMSS not found" when TCPMSS clamp to PMTU rule is added for *both* ip and ip6
From:   "Timo Sigurdsson" <public_timo.s@silentcreek.de>
To:     netfilter-devel@vger.kernel.org
Message-Id: <20190919224400.A1DA56C80A81@dd34104.kasserver.com>
Date:   Fri, 20 Sep 2019 00:44:00 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I tried registering for bugzilla.netfilter.org but the confirmation email didn't come through, so I'm posting this bug report to this list.

I use nft 0.9.0 and iptables-nft 1.8.2 on Debian 10 and noticed nft complaining about "XT target TCPMSS not found" in a specific configuration. After some digging, I found it actually really simple to reproduce:

Step 1 - add the following rules:
`iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu'
`ip6tables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu'

Step 2 - run the nft command:
`nft list tables'

Result:
 XT target TCPMSS not found
 table ip6 filter
 table ip filter

It's not important what you list, you can e.g. also run `nft list ruleset' which will throw the same error message.
It is important, however, to add both of the above rules for ip and ip6. The order is not important. But if you only one of the two rules, nft will not complain and show the ruleset correctly.

Please note that the iptables and ip6tables commands return exit code 0 for both rules. Running `ip{6,}tables -S' will also show both rules just fine. It is only nft that complains when both rules are present at the same time. And just to be clear: lsmod also shows both xt_TCPMSS and xt_tcpmss being loaded and available.


Regards,

Timo


