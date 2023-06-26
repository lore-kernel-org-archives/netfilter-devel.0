Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF96FEB64D7
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 15:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjFZPgx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 11:36:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbjFZPgx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 11:36:53 -0400
X-Greylist: delayed 432 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 26 Jun 2023 08:36:51 PDT
Received: from smtp-42af.mail.infomaniak.ch (smtp-42af.mail.infomaniak.ch [IPv6:2001:1600:3:17::42af])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C39310D9
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2023 08:36:51 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QqWww4gzDzMqFyC;
        Mon, 26 Jun 2023 15:29:36 +0000 (UTC)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4QqWwv3tWXzMpsR5;
        Mon, 26 Jun 2023 17:29:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687793376;
        bh=amhXeU0fX/W7kl1vw8y/Smi4UUNsqGIONRjqSmgYgg4=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=jJvdHS1i54evqQhpUdSmwf/YptBkmPoEx7wBE1YU69EpfmuiYSdKJtoXuerUMffYJ
         s8wAoyLmi4nOtpjWyL29fVzYhzhRyGNgN4pVK3OPvvdI01CNWAdLphu5pij34WZitb
         LMTxnlSJZamC90Ca1CRKaqyaO+q9e7MCtTFXsIOE=
Message-ID: <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
Date:   Mon, 26 Jun 2023 17:29:34 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 00/12] Network support for Landlock - allowed list of
 protocols
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, Jeff Xu <jeffxu@google.com>,
        Jorge Lucangeli Obes <jorgelo@chromium.org>,
        Allen Webb <allenwebb@google.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
 <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net>
In-Reply-To: <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reviving Günther's suggestion to deny a set of network protocols:

On 14/03/2023 14:28, Mickaël Salaün wrote:
> 
> On 13/03/2023 18:16, Konstantin Meskhidze (A) wrote:
>>
>>
>> 2/24/2023 1:17 AM, Günther Noack пишет:

[...]

>>>
>>> * Given the list of obscure network protocols listed in the socket(2)
>>>      man page, I find it slightly weird to have rules for the use of TCP,
>>>      but to leave less prominent protocols unrestricted.
>>>
>>>      For example, a process with an enabled Landlock network ruleset may
>>>      connect only to certain TCP ports, but at the same time it can
>>>      happily use Bluetooth/CAN bus/DECnet/IPX or other protocols?
>>
>>         We also have started a discussion about UDP protocol, but it's
>> more complicated since UDP sockets does not establish connections
>> between each other. There is a performance problem on the first place here.
>>
>> I'm not familiar with Bluetooth/CAN bus/DECnet/IPX but let's discuss it.
>> Any ideas here?
> 
> All these protocols should be handled one way or another someday. ;)
> 
> 
>>
>>>
>>>      I'm mentioning these more obscure protocols, because I doubt that
>>>      Landlock will grow more sophisticated support for them anytime soon,
>>>      so maybe the best option would be to just make it possible to
>>>      disable these?  Is that also part of the plan?
>>>
>>>      (I think there would be a lot of value in restricting network
>>>      access, even when it's done very broadly.  There are many programs
>>>      that don't need network at all, and among those that do need
>>>      network, most only require IP networking.
> 
> Indeed, protocols that nobody care to make Landlock supports them will
> probably not have fine-grained control. We could extend the ruleset
> attributes to disable the use (i.e. not only the creation of new related
> sockets/resources) of network protocol families, in a way that would
> make sandboxes simulate a kernel without such protocol support. In this
> case, this should be an allowed list of protocols, and everything not in
> that list should be denied. This approach could be used for other kernel
> features (unrelated to network).
> 
> 
>>>
>>>      Btw, the argument for more broad disabling of network access was
>>>      already made at https://cr.yp.to/unix/disablenetwork.html in the
>>>      past.)
> 
> This is interesting but scoped to a single use case. As specified at the
> beginning of this linked page, there must be exceptions, not only with
> AF_UNIX but also for (the newer) AF_VSOCK, and probably future ones.
> This is why I don't think a binary approach is a good one for Linux.
> Users should be able to specify what they need, and block the rest.

Here is a design to be able to only allow a set of network protocols and 
deny everything else. This would be complementary to Konstantin's patch 
series which addresses fine-grained access control.

First, I want to remind that Landlock follows an allowed list approach 
with a set of (growing) supported actions (for compatibility reasons), 
which is kind of an allow-list-on-a-deny-list. But with this proposal, 
we want to be able to deny everything, which means: supported, not 
supported, known and unknown protocols.

We could add a new "handled_access_socket" field to the landlock_ruleset 
struct, which could contain a LANDLOCK_ACCESS_SOCKET_CREATE flag.

If this field is set, users could add a new type of rules:
struct landlock_socket_attr {
     __u64 allowed_access;
     int domain; // see socket(2)
     int type; // see socket(2)
}

The allowed_access field would only contain 
LANDLOCK_ACCESS_SOCKET_CREATE at first, but it could grow with other 
actions (which cannot be handled with seccomp):
- use: walk through all opened FDs and mark them as allowed or denied
- receive: hook on received FDs
- send: hook on sent FDs

We might also use the same approach for non-socket objects that can be 
identified with some meaningful properties.

What do you think?
