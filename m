Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025E9C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Aug 2021 14:38:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE7D6127B
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Aug 2021 14:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhHXOj3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Aug 2021 10:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbhHXOj2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Aug 2021 10:39:28 -0400
X-Greylist: delayed 308 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 Aug 2021 07:38:44 PDT
Received: from sottospazio.it (centauri.sottospazio.it [IPv6:2a01:7e01::f03c:91ff:feb6:f035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E804C061764
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Aug 2021 07:38:44 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sottospazio.it;
        s=201909; t=1629815613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JSM2wJTMf/gftGcAW/am8CM4syUnF9QPRmSbK/CvZ1A=;
        b=s1OXG9mf68RkwrHfswgzsfpbmLO/SfcdWBFP1Iuv3ISqvLJItL0x0R4JriN2n35AuB93ih
        pfoub9fWxVw1rV8AD9jYBb063lPxoUC+r+VEju/LB9M7cNTLBNCN5Av7lI044Se3BZLdvI
        Z5L35Z8SIAUtqYmUmrhIHQPYaoqBiuEVPFHCJrHD/n7OVD+OwTeDKPhUflk8Tk6UlQUMLC
        7jzd4tgi9P+0snErxs5cI3IIP/jo63uRg5T7Pq7ZpiZD0xW5TkrLvyqh3/pEcNkzhnu498
        VgSEKSy5NP79wGCLZ73OxzDGbhh0INmTaccL60wX3PVF7vhFyW7XV23U60L/lA==
From:   Gianluca Anzolin <gianluca@sottospazio.it>
Subject: Request for a backport to Linux v5.4
Message-ID: <c1088b68-1804-d009-9627-d649162cdfff@sottospazio.it>
Date:   Tue, 24 Aug 2021 16:33:32 +0200
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I'm writing to request a backport of the following commit:

    2e34328b396a netfilter: nft_exthdr: fix endianness of tcp option cast

to the stable version of Linux v5.4.

This bugfix never landed to Linux v5.4: a later similar endianness 
bugfix (b428336676db) instead did (see commit 666d1d1a0584).

The aforementioned commit fixes an endianness bug in the mangling of the 
MSS tcp option for nftables.

This bug bites hard big-endian routers (MIPS for example) running the 
PPPoE stack and nftables.

The following rule:

     nft add rule ip filter forward tcp flags syn tcp option maxseg size 
set rt mtu

instead of changing the MSS value the one in the routing cache, ZEROES 
it, disrupting the tcp connections.

A backport would be nice because Linux v5.4 is the release used in the 
upcoming stable release of OpenWRT (21.02).

I already submitted a bug-report to OpenWRT a few weeks ago but I've got 
no answer yet maybe because they still use iptables as the default 
netfilter tool, even if they offer nftables as an alternative.

Still I think this bug should be fixed in the stable versions of the kernel.

This way it will also come to OpenWRT when they update the kernel to the 
latest minor version, even if the maintainers don't see the my bug 
report is ignored.

I'd like to thank you for the attention you paid to this message even if 
I probably didn't follow the right process for reporting the problem.

Regards,

Gianluca Anzolin
