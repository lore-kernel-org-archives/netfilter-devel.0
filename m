From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next RFC 0/5] netfilter: add net namespace support for cthelper
Date: Mon, 5 Jun 2017 13:11:19 +0800
Message-ID: <CAML_gOf3dW1kVpyObPZoHWSb44DX3w6vhsWXq11xwFU2pFnvFA@mail.gmail.com>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com> <20170604160753.GA843@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Liping Zhang <zlpnobody@163.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:35221 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbdFEFLU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 01:11:20 -0400
Received: by mail-vk0-f66.google.com with SMTP id 19so3534780vkd.2
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Jun 2017 22:11:20 -0700 (PDT)
In-Reply-To: <20170604160753.GA843@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian & Pablo,

2017-06-05 0:07 GMT+08:00 Florian Westphal <fw@strlen.de>:
> Liping Zhang <zlpnobody@163.com> wrote:
>> This patch set aims to add net namespace support for the ct helper,
>> it is a little large, but I try my best to split them to a relative
>> smaller patches, which will help to review. Comments are welcome.
>
> Why?  Could you explain what kind of functionality is added here, or
> what problem is fixed?
>
> Why do we need per netns complexity for helpers?

I remembered Pablo told me that the ct helpers "is probably one of
the remaining subsystems not having netns support", when I sent
patches to fix other issues.

So I try to accomplish the netns support for ct helpers.
(see https://patchwork.ozlabs.org/patch/740692/).

For these user ct helpers, after per netns support, we can config
different policy to these ct helpers with the same name.(But indeed,
this flexible seems less valuable, we can accomplish it in different
ways).

For these kernel built-in ct helpers, per netns support is indeed
unnecessary. Especially after Florian's patch: "netns: add and
use net_ns_barrier".

Anyway, I have no objection to drop this patch set, as it increased
too much complexity but earned a very little.
