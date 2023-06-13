Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C843EB64D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Jun 2023 20:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbjFMUWB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Jun 2023 16:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjFMUVy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Jun 2023 16:21:54 -0400
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA7FC7
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jun 2023 13:21:50 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Qgfpy00WgzMqFj8;
        Tue, 13 Jun 2023 20:12:10 +0000 (UTC)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Qgfpw6v9lzMpxTd;
        Tue, 13 Jun 2023 22:12:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1686687129;
        bh=OpvXvd5Xv9KNAnUACVQBG/OBkvFMFxpmmlIu7pIzhjg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Zw8rlMp5YZE/YbQRkJOnH51BIky8sJJK4+wZyiX/7QUqgOcFYReLmR+GskuANe+YB
         vkxj00QblsYXYwLK2/UfWOoelaY9A/YKRU6jvLc0rXW0/AqOeLOvCKPpEScd+wcHeQ
         lTl7aDuyF6QFPqiePZwaciaw2xdNAq7JINME96FA=
Message-ID: <97c15e23-8a89-79f2-4413-580153827ade@digikod.net>
Date:   Tue, 13 Jun 2023 22:12:08 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v11 12/12] landlock: Document Landlock's network support
Content-Language: en-US
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
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <86108314-de87-5342-e0fb-a07feee457a5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 13/06/2023 12:13, Konstantin Meskhidze (A) wrote:
> 
> 
> 6/7/2023 8:46 AM, Jeff Xu пишет:
>> On Tue, Jun 6, 2023 at 7:09 AM Günther Noack <gnoack@google.com> wrote:
>>>
>>> On Tue, May 16, 2023 at 12:13:39AM +0800, Konstantin Meskhidze wrote:
>>>> Describe network access rules for TCP sockets. Add network access
>>>> example in the tutorial. Add kernel configuration support for network.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v10:
>>>> * Fixes documentaion as Mickaёl suggested:
>>>> https://lore.kernel.org/linux-security-module/ec23be77-566e-c8fd-179e-f50e025ac2cf@digikod.net/
>>>>
>>>> Changes since v9:
>>>> * Minor refactoring.
>>>>
>>>> Changes since v8:
>>>> * Minor refactoring.
>>>>
>>>> Changes since v7:
>>>> * Fixes documentaion logic errors and typos as Mickaёl suggested:
>>>> https://lore.kernel.org/netdev/9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net/
>>>>
>>>> Changes since v6:
>>>> * Adds network support documentaion.
>>>>
>>>> ---
>>>>   Documentation/userspace-api/landlock.rst | 83 ++++++++++++++++++------
>>>>   1 file changed, 62 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
>>>> index f6a7da21708a..f185dbaa726a 100644
>>>> --- a/Documentation/userspace-api/landlock.rst
>>>> +++ b/Documentation/userspace-api/landlock.rst
>>>> @@ -11,10 +11,10 @@ Landlock: unprivileged access control
>>>>   :Date: October 2022
>>>>
>>>>   The goal of Landlock is to enable to restrict ambient rights (e.g. global
>>>> -filesystem access) for a set of processes.  Because Landlock is a stackable
>>>> -LSM, it makes possible to create safe security sandboxes as new security layers
>>>> -in addition to the existing system-wide access-controls. This kind of sandbox
>>>> -is expected to help mitigate the security impact of bugs or
>>>> +filesystem or network access) for a set of processes.  Because Landlock
>>>> +is a stackable LSM, it makes possible to create safe security sandboxes as new
>>>> +security layers in addition to the existing system-wide access-controls. This
>>>> +kind of sandbox is expected to help mitigate the security impact of bugs or
>>>>   unexpected/malicious behaviors in user space applications.  Landlock empowers
>>>>   any process, including unprivileged ones, to securely restrict themselves.
>>>>
>>>> @@ -28,20 +28,24 @@ appropriately <kernel_support>`.
>>>>   Landlock rules
>>>>   ==============
>>>>
>>>> -A Landlock rule describes an action on an object.  An object is currently a
>>>> -file hierarchy, and the related filesystem actions are defined with `access
>>>> -rights`_.  A set of rules is aggregated in a ruleset, which can then restrict
>>>> -the thread enforcing it, and its future children.
>>>> +A Landlock rule describes an action on a kernel object.  Filesystem
>>>> +objects can be defined with a file hierarchy.  Since the fourth ABI
>>>> +version, TCP ports enable to identify inbound or outbound connections.
>>>> +Actions on these kernel objects are defined according to `access
>>>> +rights`_.  A set of rules is aggregated in a ruleset, which
>>>> +can then restrict the thread enforcing it, and its future children.
>>>
>>> I feel that this paragraph is a bit long-winded to read when the
>>> additional networking aspect is added on top as well.  Maybe it would
>>> be clearer if we spelled it out in a more structured way, splitting up
>>> the filesystem/networking aspects?
>>>
>>> Suggestion:
>>>
>>>    A Landlock rule describes an action on an object which the process
>>>    intends to perform.  A set of rules is aggregated in a ruleset,
>>>    which can then restrict the thread enforcing it, and its future
>>>    children.
>>>
>>>    The two existing types of rules are:
>>>
>>>    Filesystem rules
>>>        For these rules, the object is a file hierarchy,
>>>        and the related filesystem actions are defined with
>>>        `filesystem access rights`.
>>>
>>>    Network rules (since ABI v4)
>>>        For these rules, the object is currently a TCP port,
>> Remote port or local port ?
>>
>     Both ports - remote or local.

Hmm, at first I didn't think it was worth talking about remote or local, 
but I now think it could be less confusing to specify a bit:
"For these rules, the object is the socket identified with a TCP (bind 
or connect) port according to the related `network access rights`."

A port is not a kernel object per see, so I tried to tweak a bit the 
sentence. I'm not sure such detail (object vs. data) would not confuse 
users. Any thought?


>>
>>>        and the related actions are defined with `network access rights`.
>>>
>>> Please note that the landlock(7) man page is in large parts using the
>>> same phrasing as the kernel documentation.  It might be a good idea to
>>> keep them in sync and structured similarly.  (On that mailing list,
>>> the reviews are a bit more focused on good writing style.)
>>>
>>> The same reasoning applies to the example below as well.  Explaining
>>> multiple aspects of a thing in a single example can muddy the message,
>>> let's try to avoid that.  But I can also see that if we had two
>>> separate examples, a large part of the example would be duplicated.

[...]
