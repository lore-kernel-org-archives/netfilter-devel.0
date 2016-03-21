From: Miguel Angel Ajo Pelayo <majopela@redhat.com>
Subject: Re: conntrack-tool question for contribution.
Date: Mon, 21 Mar 2016 08:51:33 +0100
Message-ID: <CAC3B9fno2rFjdoddHWF83AbdKyoYZ_g22qyGPYO5SyO68MEBGA@mail.gmail.com>
References: <CAC3B9fnKEGUsV_ir+7Y3wyy9C2KYDMbBaj-5emDhSN4V_F46DQ@mail.gmail.com>
	<CAOkSjBidYJPMAcvnSUShTU1oq5ABUvXKhqaiK7OsWEC6rBOpag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36912 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbcCUHvf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2016 03:51:35 -0400
Received: by mail-wm0-f49.google.com with SMTP id p65so110919049wmp.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2016 00:51:34 -0700 (PDT)
In-Reply-To: <CAOkSjBidYJPMAcvnSUShTU1oq5ABUvXKhqaiK7OsWEC6rBOpag@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 18, 2016 at 12:59 PM, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> On 16 March 2016 at 12:16, Miguel Angel Ajo Pelayo <majopela@redhat.com> wrote:
>> I was considering the possibility of making an small contribution to
>> conntrack-tool
>> to allow the batching of commands in a single conntrack-tool call.
>>
>> Specifically I'm interested in batching delete commands.
>>
>> In some of the neutron reference implementations we make use of conntrack-tool
>> to target and kill any active connection when security group rules are removed.
>>
>> That sometimes expands in thousands of calls due to combinations (worst
>> scenario is n_port^2 calls for a very common type of rule we have).
>>
>>
>> So I was considering two options:
>>
>> 1) Adding a mode to accept conntrack-tool actions via stdin
>> 2) Accepting the cmdline notation of separating multiple command lines
>> with "--" in a single call to conntrack tool.
>>
>>
>> Any thoughts or recommendations in this regard?
>>
>
> Hi Miguel Angel,
>
> I wonder if the kernel support batching of messages in ctnetlink. You
> may want to check the sources [0][1].
>
> Perhaps you want the conntrack utility to simply chain a lot of calls
> to the kernel rather than a proper batch of messages. In this case, I
> don't know exactly why but I like more your 2) option.
>
> [0] http://lxr.free-electrons.com/source/net/netfilter/nf_conntrack_netlink.c#L3260
> [1] http://lxr.free-electrons.com/source/net/netfilter/nfnetlink.c#L282
>

Hmm, I will have a look into [0][1], I guess the gain of chaining calls
is  saving overhead, right?.

I put 2 up for discussion as 2nd option because of the cmdline limit which
(I guess) is going to be more than enough generally, and because the
ipset cmdline tools accept stdin batches too.

I guess 1 makes chaining (if possible) more complicated, but it could
still be done (less straight forward) in smaller chains, by chaining whatever
you can read without blocking.
