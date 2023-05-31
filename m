Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA26C7EE32
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 15:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbjEaPPW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 11:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbjEaPPV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 11:15:21 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B204CC0
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 08:15:19 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 17D5A58736AF3; Wed, 31 May 2023 17:15:18 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 15BA160C440BB;
        Wed, 31 May 2023 17:15:18 +0200 (CEST)
Date:   Wed, 31 May 2023 17:15:18 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Jeremy Sowden <jeremy@azazel.net>
cc:     ValdikSS <iam@valdikss.org.ru>, netfilter-devel@vger.kernel.org
Subject: Re: xtables-addons: ipp2p does not block TCP traffic with nonlinear
 skb
In-Reply-To: <20230531150102.GA1355804@azazel.net>
Message-ID: <8p23q138-oq37-q06s-3734-r8107q8r8212@vanv.qr>
References: <2b05bb89-08bf-b3b1-c2d7-9b391953f303@valdikss.org.ru> <7rr4q976-5qn6-382r-0pp-66rq492r9376@vanv.qr> <20230531150102.GA1355804@azazel.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2023-05-31 17:01, Jeremy Sowden wrote:
>> 
>> It should be possible to just take the code from xt_ECHO and call
>> 
>> if (skb_linearize(skb) < 0)
>> 	return false;
>> 
>> However, none of the xtables matches in the Linux kernel do this
>> linearization, at least not that I can see directly.
>
>They use `skb_header_pointer` instead, I think, which handles the
>linearization behind the scenes.  I'll send a patch.

Yeah, header_pointer extracts bytes if need be, which means you need
to have a sufficiently large buffer to copy to.
Just hope you don't get any IPv6 jumbo packet, eh?
