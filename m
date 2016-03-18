From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: conntrack-tool question for contribution.
Date: Fri, 18 Mar 2016 12:59:24 +0100
Message-ID: <CAOkSjBidYJPMAcvnSUShTU1oq5ABUvXKhqaiK7OsWEC6rBOpag@mail.gmail.com>
References: <CAC3B9fnKEGUsV_ir+7Y3wyy9C2KYDMbBaj-5emDhSN4V_F46DQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Miguel Angel Ajo Pelayo <majopela@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33000 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbcCRL7p convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2016 07:59:45 -0400
Received: by mail-wm0-f41.google.com with SMTP id l68so65406525wml.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Mar 2016 04:59:44 -0700 (PDT)
In-Reply-To: <CAC3B9fnKEGUsV_ir+7Y3wyy9C2KYDMbBaj-5emDhSN4V_F46DQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 March 2016 at 12:16, Miguel Angel Ajo Pelayo <majopela@redhat.com=
> wrote:
> I was considering the possibility of making an small contribution to
> conntrack-tool
> to allow the batching of commands in a single conntrack-tool call.
>
> Specifically I'm interested in batching delete commands.
>
> In some of the neutron reference implementations we make use of connt=
rack-tool
> to target and kill any active connection when security group rules ar=
e removed.
>
> That sometimes expands in thousands of calls due to combinations (wor=
st
> scenario is n_port^2 calls for a very common type of rule we have).
>
>
> So I was considering two options:
>
> 1) Adding a mode to accept conntrack-tool actions via stdin
> 2) Accepting the cmdline notation of separating multiple command line=
s
> with "--" in a single call to conntrack tool.
>
>
> Any thoughts or recommendations in this regard?
>

Hi Miguel Angel,

I wonder if the kernel support batching of messages in ctnetlink. You
may want to check the sources [0][1].

Perhaps you want the conntrack utility to simply chain a lot of calls
to the kernel rather than a proper batch of messages. In this case, I
don't know exactly why but I like more your 2) option.

[0] http://lxr.free-electrons.com/source/net/netfilter/nf_conntrack_net=
link.c#L3260
[1] http://lxr.free-electrons.com/source/net/netfilter/nfnetlink.c#L282

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
