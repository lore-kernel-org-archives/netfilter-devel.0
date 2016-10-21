From: Mathew Heard <mat999@gmail.com>
Subject: Re: [RFC nf-next PATCH] netfilter: nf_conntrack_proto_tcp: propagate IP_CT_TCP_FLAG_BE_LIBERAL
Date: Fri, 21 Oct 2016 18:26:28 +1100
Message-ID: <CALFfGYZa4H6aNK9_BgAj8M2cNTsWuXPhnpNah7Q7p2dDnp78AA@mail.gmail.com>
References: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es>
 <20161020181424.GA10898@salvia> <CAOkSjBj-Tyc90ph8-tEt9Ux07ZeCRBETnBNVCyL9RLXiByUHhA@mail.gmail.com>
 <CALFfGYaW3vaMmJ==gXqUATsmu5BWwZx8Aee8G8KknmVTySWrng@mail.gmail.com> <CAOkSjBg0TE_LjA4xYnbRvf=BzRP8xGvJK+xOWDURHnqAmjCJSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Arturo Borrero Gonzalez <arturo@debian.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35041 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750906AbcJUH0u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 03:26:50 -0400
Received: by mail-it0-f67.google.com with SMTP id 139so9848354itm.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 00:26:49 -0700 (PDT)
In-Reply-To: <CAOkSjBg0TE_LjA4xYnbRvf=BzRP8xGvJK+xOWDURHnqAmjCJSQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

However under testing, in practice is not. As covered in the bug.

Fields: CTA_IP_V4_DST, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL &
CTA_PROTOINFO_TCP_FLAGS_REPLY
Result: "**.**.56.135: 10 3"

It's only being set on one side. I believe this is because the reply
side flags are being set/initialised after the fact (i.e where they
are initialised in that function for incoming connections would do it
too).


On Fri, Oct 21, 2016 at 6:22 PM, Arturo Borrero Gonzalez
<arturo@debian.org> wrote:
> (please keep the netfilter-devel list in CC)
>
> On 21 October 2016 at 09:18, Mathew Heard <mat999@gmail.com> wrote:
>> That's been covered already.
>>
>> The problem with it is that only the ORIG side of the connection ends
>> up set. REPLY does not.
>>
>> I don't know the fundamental reason why this occurs, only the effect.
>>
>
> In that same function, in conntrackd:
>  http://git.netfilter.org/conntrack-tools/tree/src/netlink.c#n256
>
> we set the same flags in both original and reply directions:
>
> nfct_set_attr_u8(ct, ATTR_TCP_FLAGS_ORIG, flags);
> nfct_set_attr_u8(ct, ATTR_TCP_MASK_ORIG, flags);
> nfct_set_attr_u8(ct, ATTR_TCP_FLAGS_REPL, flags);
> nfct_set_attr_u8(ct, ATTR_TCP_MASK_REPL, flags);
