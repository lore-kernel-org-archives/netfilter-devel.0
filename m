Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B872C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 08:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D115720679
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 08:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfHMIrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 04:47:25 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:36306 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMIrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 04:47:24 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 27B7310015B;
        Tue, 13 Aug 2019 10:47:22 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id C93DA7C5;
        Tue, 13 Aug 2019 10:47:21 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.70,VDF=8.16.20.216)
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 102FE51F;
        Tue, 13 Aug 2019 10:47:19 +0200 (CEST)
Date:   Tue, 13 Aug 2019 10:47:19 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Jakub Jankowski <shasta@toxcorp.com>
Subject: Re: [PATCH nf] netfilter: conntrack: always store window size
 un-scaled
Message-ID: <20190813084718.xdy7vh23bskueihg@intra2net.com>
References: <20190711222905.22000-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711222905.22000-1-fw@strlen.de>
User-Agent: NeoMutt/20180716
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

You wrote on Fri, Jul 12, 2019 at 12:29:05AM +0200:
> Jakub Jankowski reported following oddity:
> 
> After 3 way handshake completes, timeout of new connection is set to
> max_retrans (300s) instead of established (5 days).
> 
> shortened excerpt from pcap provided:
> 25.070622 IP (flags [DF], proto TCP (6), length 52)
> 10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
> 26.070462 IP (flags [DF], proto TCP (6), length 48)
> 10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
> 27.070449 IP (flags [DF], proto TCP (6), length 40)
> 10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0
> 
> Turns out the last_win is of u16 type, but we store the scaled value:
> 512 << 8 (== 0x20000) becomes 0 window.
> 
> The Fixes tag is not correct, as the bug has existed forever, but
> without that change all that this causes might cause is to mistake a
> window update (to-nonzero-from-zero) for a retransmit.
> 
> Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
> Reported-by: Jakub Jankowski <shasta@toxcorp.com>
> Tested-by: Jakub Jankowski <shasta@toxcorp.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

it seems the patch fixed a kernel bugzilla entry, too:
https://bugzilla.kernel.org/show_bug.cgi?id=202287

I had a feeling it could be related since the reporter bisected it
down to changes in the TCP window scaling defaults.

Cheers,
Thomas
