Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D95C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Mar 2023 11:57:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjC3L5b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Mar 2023 07:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjC3L53 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Mar 2023 07:57:29 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3EF900D
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Mar 2023 04:57:23 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id A15C7587438E3; Thu, 30 Mar 2023 13:57:21 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 9FE9E61C7F2A5;
        Thu, 30 Mar 2023 13:57:21 +0200 (CEST)
Date:   Thu, 30 Mar 2023 13:57:21 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: RE: [RFC PATCH] nft: autocomplete for libreadline
In-Reply-To: <DBBP189MB1433A50ACB1020757E63F569958E9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
Message-ID: <91rn9noq-56ro-r1s3-ns23-91975or11nn6@vanv.qr>
References: <20230330112535.31483-1-sriram.yagnaraman@est.tech> <69r697s-n01r-s6qs-q766-1n31826q6s0@vanv.qr> <DBBP189MB1433A50ACB1020757E63F569958E9@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thursday 2023-03-30 13:54, Sriram Yagnaraman wrote:

>
>> -----Original Message-----
>> From: Jan Engelhardt <jengelh@inai.de>
>> Sent: Thursday, 30 March 2023 13:51
>> To: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
>> Cc: netfilter-devel@vger.kernel.org; Phil Sutter <phil@nwl.cc>; Pablo Neira
>> Ayuso <pablo@netfilter.org>; Florian Westphal <fw@strlen.de>
>> Subject: Re: [RFC PATCH] nft: autocomplete for libreadline
>> 
>> 
>> On Thursday 2023-03-30 13:25, Sriram Yagnaraman wrote:
>> 
>> >-libnftables_LIBVERSION=2:0:1
>> >+libnftables_LIBVERSION=3:0:1
>> 
>> ^ This looks very much incorrect.
>
>I confess that I have no idea how this versioning works. I was unable to add the new libnftables API without changing this number.
>Please advise what I should use.

From the modifications to the .h files, 3:0:2 seems in order.

https://www.gnu.org/software/libtool/manual/html_node/Libtool-versioning.html
