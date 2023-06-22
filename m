Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEC0EB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 16:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjFVQuZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 12:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbjFVQuY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 12:50:24 -0400
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [IPv6:2001:1600:4:17::190c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2E4E6E
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 09:50:20 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Qn5vq1J0dzMqTCw;
        Thu, 22 Jun 2023 16:50:15 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Qn5vp15ZPzMpnPr;
        Thu, 22 Jun 2023 18:50:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687452615;
        bh=i0pWvByrW9z0B0qMC2EGfccJ5CDeD/5G1+nmhQ+uLRQ=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=bf+SX6SEXNbj7+3UQcRll0nP8zIfs+HTxGji3zM9psenwaqcoysWTSkgeG8wvYK+k
         sqiAP5yg7acByGYwPHqjNYJj4yZA9/gsKobZbMxHzvtz9ZEz0U1v7tSmG8AVyhRLQH
         lPmC8KkVfJcBqtZwEdhYCPiZc7KQlbLZsp+7wDxQ=
Message-ID: <00a03f2c-892d-683e-96a0-c0ba8f293831@digikod.net>
Date:   Thu, 22 Jun 2023 18:50:13 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 12/12] landlock: Document Landlock's network support
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        Jeff Xu <jeffxu@chromium.org>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack@google.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <20230515161339.631577-13-konstantin.meskhidze@huawei.com>
 <ZH89Pi1QAqNW2QgG@google.com>
 <CABi2SkWqHeLkmqONbmavcp2SCiwe6YeH_3dkBLZwSsk7neyPMw@mail.gmail.com>
 <86108314-de87-5342-e0fb-a07feee457a5@huawei.com>
 <97c15e23-8a89-79f2-4413-580153827ade@digikod.net>
In-Reply-To: <97c15e23-8a89-79f2-4413-580153827ade@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 13/06/2023 22:12, Mickaël Salaün wrote:
> 
> On 13/06/2023 12:13, Konstantin Meskhidze (A) wrote:
>>
>>
>> 6/7/2023 8:46 AM, Jeff Xu пишет:
>>> On Tue, Jun 6, 2023 at 7:09 AM Günther Noack <gnoack@google.com> wrote:
>>>>
>>>> On Tue, May 16, 2023 at 12:13:39AM +0800, Konstantin Meskhidze wrote:
>>>>> Describe network access rules for TCP sockets. Add network access
>>>>> example in the tutorial. Add kernel configuration support for network.
>>>>>
>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[...]

>>>>> @@ -28,20 +28,24 @@ appropriately <kernel_support>`.
>>>>>    Landlock rules
>>>>>    ==============
>>>>>
>>>>> -A Landlock rule describes an action on an object.  An object is currently a
>>>>> -file hierarchy, and the related filesystem actions are defined with `access
>>>>> -rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
>>>>> -the thread enforcing it, and its future children.
>>>>> +A Landlock rule describes an action on a kernel object.  Filesystem
>>>>> +objects can be defined with a file hierarchy.  Since the fourth ABI
>>>>> +version, TCP ports enable to identify inbound or outbound connections.
>>>>> +Actions on these kernel objects are defined according to `access
>>>>> +rights`_.  A set of rules is aggregated in a ruleset, which
>>>>> +can then restrict the thread enforcing it, and its future children.
>>>>
>>>> I feel that this paragraph is a bit long-winded to read when the
>>>> additional networking aspect is added on top as well.  Maybe it would
>>>> be clearer if we spelled it out in a more structured way, splitting up
>>>> the filesystem/networking aspects?
>>>>
>>>> Suggestion:
>>>>
>>>>     A Landlock rule describes an action on an object which the process
>>>>     intends to perform.  A set of rules is aggregated in a ruleset,
>>>>     which can then restrict the thread enforcing it, and its future
>>>>     children.
>>>>
>>>>     The two existing types of rules are:
>>>>
>>>>     Filesystem rules
>>>>         For these rules, the object is a file hierarchy,
>>>>         and the related filesystem actions are defined with
>>>>         `filesystem access rights`.
>>>>
>>>>     Network rules (since ABI v4)
>>>>         For these rules, the object is currently a TCP port,
>>> Remote port or local port ?
>>>
>>      Both ports - remote or local.
> 
> Hmm, at first I didn't think it was worth talking about remote or local,
> but I now think it could be less confusing to specify a bit:
> "For these rules, the object is the socket identified with a TCP (bind
> or connect) port according to the related `network access rights`."
> 
> A port is not a kernel object per see, so I tried to tweak a bit the
> sentence. I'm not sure such detail (object vs. data) would not confuse
> users. Any thought?

Well, here is a more accurate and generic definition (using "scope"):

A Landlock rule describes a set of actions intended by a task on a scope 
of objects.  A set of rules is aggregated in a ruleset, which can then 
restrict the thread enforcing it, and its future children.

The two existing types of rules are:

Filesystem rules
     For these rules, the scope of objects is a file hierarchy,
     and the related filesystem actions are defined with
     `filesystem access rights`.

Network rules (since ABI v4)
     For these rules, the scope of objects is the sockets identified
     with a TCP (bind or connect) port according to the related
     `network access rights`.


What do you think?


>>>
>>>>         and the related actions are defined with `network access rights`.
