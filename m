Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77D9C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9861361422
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 16:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbhDUQ0K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 12:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbhDUQ0J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 12:26:09 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B01C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 09:25:34 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 43FD05863C8B4; Wed, 21 Apr 2021 18:25:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 3F7A760C63B4B;
        Wed, 21 Apr 2021 18:25:32 +0200 (CEST)
Date:   Wed, 21 Apr 2021 18:25:32 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Duncan Roe <duncan.roe2@gmail.com>
cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 1/1] build: doc: `make distcheck`
 passes with doxygen enabled
In-Reply-To: <20210421122556.GA12005@smallstar.local.net>
Message-ID: <s6o3s8n-8486-r468-728s-4384736oqq@vanv.qr>
References: <20210420042358.2829-1-duncan_roe@optusnet.com.au> <20210420042358.2829-2-duncan_roe@optusnet.com.au> <3219so45-rsq1-8093-77pr-39oo80or6q@vanv.qr> <20210421021745.GA9334@smallstar.local.net> <8044rs51-qqq5-223o-q410-q46nsn566pqo@vanv.qr>
 <20210421122556.GA12005@smallstar.local.net>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wednesday 2021-04-21 14:25, Duncan Roe wrote:

>Hi Jan,
>
>On Wed, Apr 21, 2021 at 09:21:26AM +0200, Jan Engelhardt wrote:
>>
>> On Wednesday 2021-04-21 04:17, Duncan Roe wrote:
>> >> >+if test -z "$DOXYGEN"; then
>> >>
>> >> If you use AS_IF above, you could also make use of it here :)
>> >
>> >Happy to do that, but could you spell out the actual line please? My grasp of m4
>> >is tenuous at best - I only copy stuff that I see working elsewhere.
>>
>> AS_IF([test -z "$DOXYGEN], [what if true], [what if false])
>>
>Can I use HAVE_DOXYGEN instead? Is this right:
>
>AS_IF(HAVE_DOXYGEN, [what if true], [what if false])

Yes/no, the [condition] argument of AS_IF needs to be a shell command.
