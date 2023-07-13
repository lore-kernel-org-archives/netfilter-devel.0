Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2848EC00528
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jul 2023 14:53:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjGMOxD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jul 2023 10:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjGMOxB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2023 10:53:01 -0400
Received: from smtp-42aa.mail.infomaniak.ch (smtp-42aa.mail.infomaniak.ch [IPv6:2001:1600:4:17::42aa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1300A19A6
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Jul 2023 07:52:59 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4R1yJn3WBTzMq415;
        Thu, 13 Jul 2023 14:52:57 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4R1yJm3CT1z14C;
        Thu, 13 Jul 2023 16:52:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1689259977;
        bh=dEQYMfSXUaWkKspb9SxMOMoHBtzyGDP/6J/1GVJZfUg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=nY77TqlNFbf6nsOAUoDxh+bXB19VA0Y67zndsCbzTQBca7rTMvDg/OmmvHNHJEABN
         Nkkd8n5EpjpZqdqKsc4axJfF8+lN1dTcN2YSRh78Tf4FoCRlPhPbUgRzTDJX6A42Hd
         B4bRLfVpUp+6jDSNv+oFqex8SspJ6wMxYq5V828o=
Message-ID: <263c1eb3-602f-57fe-8450-3f138581bee7@digikod.net>
Date:   Thu, 13 Jul 2023 16:52:55 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 00/12] Network support for Landlock - allowed list of
 protocols
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        Jeff Xu <jeffxu@google.com>
Cc:     Jeff Xu <jeffxu@chromium.org>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack@google.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>,
        willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com,
        Jorge Lucangeli Obes <jorgelo@chromium.org>,
        Allen Webb <allenwebb@google.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
 <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net>
 <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
 <ZJvy2SViorgc+cZI@google.com>
 <CABi2SkX-dzUO6NnbyqfrAg7Bbn+Ne=Xi1qC1XMrzHqVEVucQ0Q@mail.gmail.com>
 <43e8acb2-d696-c001-b54b-d2b7cf244de7@digikod.net>
 <CABi2SkV1Q-cvMScEtcsHbgNRuGc39eJo6KT=GwUxsWPpFGSR4A@mail.gmail.com>
 <b4440d19-93b9-e234-007b-4fc4f987550b@digikod.net>
 <CABi2SkVbD8p0AHhvKLXPh-bQSNAk__8_ONxpE+8hisoZxF-h6g@mail.gmail.com>
 <fb206d63-e51d-c701-8987-42078f8ccb5f@digikod.net>
 <CALmYWFuJOae2mNp47NCzuz251Asm5Cm3hRZNtPOb7+1oty67Tg@mail.gmail.com>
 <9fc33a12-276d-8f68-eeb8-1258559b30d4@digikod.net>
 <bbd68f64-4e5a-b5e5-5b18-08261b9f1cdf@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <bbd68f64-4e5a-b5e5-5b18-08261b9f1cdf@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 13/07/2023 15:20, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/12/2023 2:30 PM, Mickaël Salaün пишет:
>>
>> On 05/07/2023 17:00, Jeff Xu wrote:
>>> On Fri, Jun 30, 2023 at 11:23 AM Mickaël Salaün <mic@digikod.net> wrote:
>>>>
>>>>
>>>> On 30/06/2023 06:18, Jeff Xu wrote:
>>>>> On Thu, Jun 29, 2023 at 4:07 AM Mickaël Salaün <mic@digikod.net> wrote:
>>>>>>
>>>>>>
>>>>>> On 29/06/2023 05:18, Jeff Xu wrote:
>>>>>>> resend.
>>>>>>>
>>>>>>> On Wed, Jun 28, 2023 at 12:29 PM Mickaël Salaün <mic@digikod.net> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 28/06/2023 19:03, Jeff Xu wrote:
>>
>> [...]
>>
>>>> The sandboxing/Landlock threat model is to restrict a process when it is
>>>> sandboxed, but this sandboxing is a request from the same process (or
>>>> one of its parent) that happen when it is more trustworthy (or at least
>>>> has more privileges) than after it sandbox itself.
>>>>
>>>> The process sandboxing itself can use several kernel features, and one
>>>> of it is Landlock. In any case, it should take care of closing file
>>>> descriptors that should not be passed to the sandboxed process.
>>>>
>>> Agree.
>>>
>>>> The limits of sandboxing are the communication channels from and to
>>>> outside the sandbox. The peers talking with sandboxed processes should
>>>> then not be subject to confused deputy attacks, which means they must
>>>> not enable to bypass the user-defined security policy (from which the
>>>> Landlock policy is only a part). Receiving file descriptors should then
>>>> not be more important than controlling the communication channels. If a
>>>> not-sandboxed process is willing to give more right to a sandboxed
>>>> process, by passing FDs or just receiving commands, then this
>>>> not-sandboxed process need to be fixed.
>>>>
>>>> This is the rationale to not care about received nor sent file
>>>> descriptors. The communication channels and the remote peers must be
>>>> trusted to not give more privileges to the sandboxed processes.
>>>>
>>>> If a peer is malicious, it doesn't need to pass a file descriptor to the
>>>> sandboxed process, it can just read (data) commands and apply them to
>>>> its file descriptors.
>>>
>>> I see the reasoning. i.e. sandboxing the process is not more
>>> important than securing communication channels, or securing the peer.
>>>
>>> So in a system that let a peer process to pass a socket into a
>>> higher privileged process, when the communication channel or the peer
>>> process is compromised,  e.g. swapping the fd/socket into a different
>>> one that the attacker controls, confuse deputy attack can happen. The
>>> recommendation here is to secure peer and communication.
>>> I agree with this approach in general.  I need to think about how it
>>> applies to specific cases.
>>>
>>>> I think the ability to pass file descriptors
>>>> should be seen as a way to improve performance by avoiding a user space
>>>> process to act as a proxy receiving read/write commands and managing
>>>> file descriptors itself. On the other hand, file descriptors could be
>>>> used as real capabilities/tokens to manage access, but senders still
>>>> need to be careful to only pass the required ones.
>>>>
>>>> All this to say that being able to restrict actions on file descriptors
>>>> would be useful for senders/services to send a subset of the file
>>>> descriptor capabilities (cf. Capsicum), but not the other way around.
>>>>
>>> In the Landlock kernel doc:
>>> Similarly to file access modes (e.g. O_RDWR), Landlock access rights
>>> attached to file descriptors are retained even if they are passed
>>> between processes (e.g. through a Unix domain socket). Such access
>>> rights will then be enforced even if the receiving process is not
>>> sandboxed by Landlock. Indeed, this is required to keep a consistent
>>> access control over the whole system, and this avoids unattended
>>> bypasses through file descriptor passing (i.e. confused deputy
>>> attack).
>>>
>>> iiuc, the design for file and socket in landlock is different. For
>>> socket, the access rules are applied only to the current process (more
>>> like seccomp), while for file restriction, the rules can be passed
>>> into another un-landlocked process.
>>
>> The O_RDWR restrictions are enforced by the basic kernel access control,
>> not Landlock. However, for file truncation, Landlock complements the
>> basic kernel access rights and behave the same.
>>
>> There is indeed slight differences between file system and socket
>> restrictions. For the file system, a file descriptor is a direct access
>> to a file/data. For the network, we cannot identify for which data/peer
>> a newly created socket will give access to, we need to wait for a
>> connect or bind request to identify the use case for this socket. We
>> could tie the access rights (related to ports) to an opened socket, but
>> this would not align with the way Landlock access control works for the
>> file system. Indeed, a directory file descriptor may enable to open
>> another file (i.e. a new data item), but this opening is restricted by
>> Landlock. A newly created socket gives access to the network (or a
>> subset of it), but binding or connecting to a peer (i.e. accessing new
>> data) is restricted by Landlock. Accesses tied to FDs are those that
>> enable to get access to the underlying data (e.g. read, write,
>> truncate). A newly created socket is harmless until it is connected to a
>> peer, similarly to a memfd file descriptor. A directory opened by a
>> sandboxed process can be passed to a process outside this sandbox and it
>> might be allowed to open a relative path/file, which might not be the
>> case for the sandboxed process.
> 
>     I would like to mention that in case of files a Landlock rule is tied
> to undreliying file's inode ( already existing at the moment of creating
>      a landlock's rule), and it's impossible to tie a new landlock rule
> to a socket before it's creating. Thats why all network access rules
> work with "port objects", representing network connections.

Correct, even if a port is not a *kernel* object.

> 
> I was thinking about sendind socket's FD to another process.
> If one process creates a socket and binds it to some port N. Then it
> sends socket's FD to a landlocked process with rule restricting to bind
> to port N. Is this situation theoretically possible???

Yes, it's possible an it's OK because the bind action was performed by 
an unsandboxed process. If this unsandboxed process is not trusted or if 
it can be fooled by a malicious client, the system should be designed to 
make it not able to talk to the sandboxed process.

> 
> 
>>
>> I think it might be summarize by the difference between underlying FD
>> data in the case of a regular file (i.e. tied access rights), and
>> relative new data in the case of a directory or a socket (i.e.
>> sandboxing policy scope).
>> .
