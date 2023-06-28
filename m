Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90C9FEB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jun 2023 19:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjF1THd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jun 2023 15:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjF1THJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2023 15:07:09 -0400
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B51A1FF1
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jun 2023 12:07:06 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Qrrfv5k2jzMpr2X;
        Wed, 28 Jun 2023 19:07:03 +0000 (UTC)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Qrrft3slkzMpr45;
        Wed, 28 Jun 2023 21:07:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1687979223;
        bh=KJ0S+L/apssQg9gVVF2ykqWTCwTmUCmj7dvjStIHKE4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qc+2YsQ/acg0yqOzp1GFW+zEWdVRSGNNf+1kvYGvPpzPdHVPyoyErXqEr8wpg7d5B
         oOZzDO2Bg0CePIGEKCJ76XAxZ37Df1G/40oPzkwpLw2ngKveSzCqkxIJKfJFOWcPRA
         nt3B4Gx4Npn4i4YDIdfxr7oQxTwydRYB3wYcTB5w=
Message-ID: <618f11b6-7766-95b1-8fef-679de21b1fa2@digikod.net>
Date:   Wed, 28 Jun 2023 21:07:01 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 00/12] Network support for Landlock - allowed list of
 protocols
Content-Language: en-US
To:     =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack@google.com>
Cc:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>,
        willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, Jeff Xu <jeffxu@google.com>,
        Jorge Lucangeli Obes <jorgelo@chromium.org>,
        Allen Webb <allenwebb@google.com>,
        Dmitry Torokhov <dtor@google.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <Y/fl5iEbkL5Pj5cJ@galopp> <c20fc9eb-518e-84b4-0dd5-7b97c0825259@huawei.com>
 <3e113e1c-4c7b-af91-14c2-11b6ffb4d3ef@digikod.net>
 <b8a2045a-e7e8-d141-7c01-bf47874c7930@digikod.net>
 <ZJvy2SViorgc+cZI@google.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <ZJvy2SViorgc+cZI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 28/06/2023 10:44, Günther Noack wrote:
> Hello!
> 
> On Mon, Jun 26, 2023 at 05:29:34PM +0200, Mickaël Salaün wrote:
>> Here is a design to be able to only allow a set of network protocols and
>> deny everything else. This would be complementary to Konstantin's patch
>> series which addresses fine-grained access control.
>>
>> First, I want to remind that Landlock follows an allowed list approach with
>> a set of (growing) supported actions (for compatibility reasons), which is
>> kind of an allow-list-on-a-deny-list. But with this proposal, we want to be
>> able to deny everything, which means: supported, not supported, known and
>> unknown protocols.
>>
>> We could add a new "handled_access_socket" field to the landlock_ruleset
>> struct, which could contain a LANDLOCK_ACCESS_SOCKET_CREATE flag.
>>
>> If this field is set, users could add a new type of rules:
>> struct landlock_socket_attr {
>>      __u64 allowed_access;
>>      int domain; // see socket(2)
>>      int type; // see socket(2)
>> }
>>
>> The allowed_access field would only contain LANDLOCK_ACCESS_SOCKET_CREATE at
>> first, but it could grow with other actions (which cannot be handled with
>> seccomp):
>> - use: walk through all opened FDs and mark them as allowed or denied
>> - receive: hook on received FDs
>> - send: hook on sent FDs
>>
>> We might also use the same approach for non-socket objects that can be
>> identified with some meaningful properties.
>>
>> What do you think?
> 
> This sounds like a good plan to me - it would make it possible to restrict new
> socket creation using protocols that were not intended to be used, and I also
> think it would fit the Landlock model nicely.
> 
> Small remark on the side: The security_socket_create() hook does not only get
> invoked as a result of socket(2), but also as a part of accept(2) - so this
> approach might already prevent new connections very effectively.

Indeed. We could also differentiate socket(2) from accept(2) with a 
dedicated LANDLOCK_ACCESS_SOCKET_ACCEPT right. This would enable to 
create a bind socket, sandbox the process and deny new socket(2) calls, 
but still allows to call accept(2) and receive new connections.

BTW, unix socket path opening should be considered too.

> 
> Spelling out some scenarios, so that we are sure that we are on the same page:
> 
> A)
> 
> A program that does not need networking could specify a ruleset where
> LANDLOCK_ACCESS_SOCKET_CREATE is handled, and simply not permit anything.

This is correct, except if the process receive a socket FD or open a 
unix socket path.


> 
> B)
> 
> A program that runs a TCP server could specify a ruleset where
> LANDLOCK_NET_BIND_TCP, LANDLOCK_NET_CONNECT_TCP and

s/LANDLOCK_NET_CONNECT_TCP/LANDLOCK_ACCESS_NET_CONNECT_TCP/

> LANDLOCK_ACCESS_SOCKET_CREATE are handled, and where the following rules are added:
> 
>    /* From Konstantin's patch set */
>    struct landlock_net_service_attr bind_attr = {
>      .allowed_access = LANDLOCK_NET_BIND_TCP,
>      .port = 8080,
>    };
> 
>    /* From Mickaël's proposal */
>    struct landlock_socket_attr sock_inet_attr = {
>      .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>      .domain = AF_INET,
>      .type = SOCK_STREAM,
>    }
> 
>    struct landlock_socket_attr sock_inet6_attr = {
>      .allowed_access = LANDLOCK_ACCESS_SOCKET_CREATE,
>      .domain = AF_INET6,
>       .type = SOCK_STREAM,
>    }
> 
> That should then be enough to bind and listen on ports, whereas outgoing
> connections with TCP and anything using other network protocols would not be
> permitted.
> 
> (Alternatively, it could bind() the socket early, *then enable Landlock* and
> leave out the rule for BIND_TCP, only permitting SOCKET_CREATE for IPv4 and
> IPv6, so that listen() and accept() work on the already-bound socket.)

correct

> 
> Overall, this sounds like an excellent approach to me. 👍
> 
> —Günther
> 
