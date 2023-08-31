Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F9FC83F01
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 09:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbjHaJxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 05:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbjHaJxS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 05:53:18 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051D8CED
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 02:53:15 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 9E1195919BDC6; Thu, 31 Aug 2023 11:53:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 9BE6D6193979E;
        Thu, 31 Aug 2023 11:53:02 +0200 (CEST)
Date:   Thu, 31 Aug 2023 11:53:02 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Ian Kumlien <ian.kumlien@gmail.com>
cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: MASQ leak?
In-Reply-To: <CAA85sZvuN5f4Lf3VxOe1Dj9-gq=gD9z4_DwPN_CedJiNeviNsg@mail.gmail.com>
Message-ID: <47p877oo-o3q5-55q4-03s4-110290n2oq70@vanv.qr>
References: <CAA85sZsLFsThq4jz1gx0UZj5ab+6SUbhPxy+gsM1d7o2S49LdA@mail.gmail.com> <86o37onn-8431-noor-1p0p-8764n0855n74@vanv.qr> <CAA85sZvuN5f4Lf3VxOe1Dj9-gq=gD9z4_DwPN_CedJiNeviNsg@mail.gmail.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2023-08-31 11:40, Ian Kumlien wrote:
>> >               type filter hook forward priority 0
>> >                ct state invalid counter drop # <- this one
>> >
>> >It just seems odd to me that traffic can go through without being NAT:ed
>>
>> MASQ requires connection tracking; if tracking is disabled for a connection,
>> addresses cannot be changed.
>
>I don't disable connection tracking - this is most likely a expired
>session that is reused and IMHO it should just be added

"invalid" is not just invalid but also untracked (or untrackable)
CTs, and icmpv6-NDISC is not tracked for example (icmpv6-PING is).

Expired (forgotten) CTs are automatically recreated in the middle by default,
one needs extra rules to change the behavior (e.g. `tcp syn` test when
ctstate==NEW).
