Return-Path: <SRS0=bO8k=3S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5512AC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jan 2020 13:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F74C2070E
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jan 2020 13:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgA2N24 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 08:28:56 -0500
Received: from rs07.intra2net.com ([85.214.138.66]:34272 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgA2N2z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 08:28:55 -0500
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jan 2020 08:28:55 EST
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id BFE8A150016C
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2020 14:19:42 +0100 (CET)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 8EB02602
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2020 14:19:42 +0100 (CET)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.164,VDF=8.16.35.170)
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 25613576
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2020 14:19:41 +0100 (CET)
Date:   Wed, 29 Jan 2020 14:19:41 +0100
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     netfilter-devel@vger.kernel.org
Subject: use of netfilter-announce list
Message-ID: <20200129131941.r7ep7jjhoam4fu7h@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I've noticed the netfilter-announce mailinglist
doesn't seem to be used in a consistent manner:

The release of iptables 1.8.3 was announced there, but other new releases
like iptables 1.8.4 / nftables 0.9.3 didn't make it to this list.

Is the netfilter-announce list deprecated?

Cheers,
Thomas
