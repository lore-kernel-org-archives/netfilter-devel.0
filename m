From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: Re: [PATCH] ipv6: Preserve link scope traffic original oif
Date: Fri, 3 Mar 2017 14:22:07 +0100
Message-ID: <CAF1oqRAHjYfCLGgSz8SQ6ECGE07RGQrnfjmYTDy8sxbxGYEbug@mail.gmail.com>
References: <1488376043-31976-1-git-send-email-alin.nastac@gmail.com>
 <20170303113918.GA13435@salvia> <CAF1oqRD9sahqwj0u1k44x6EqnjD7czLFDM32nO1o6am4gnprtw@mail.gmail.com>
 <20170303121225.GA14320@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:32868 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdCCNWb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 08:22:31 -0500
Received: by mail-yw0-f194.google.com with SMTP id s15so7009129ywg.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Mar 2017 05:22:08 -0800 (PST)
In-Reply-To: <20170303121225.GA14320@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 3, 2017 at 1:12 PM, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
> On Fri, Mar 03, 2017 at 12:56:50PM +0100, Alin N=C4=83stac wrote:
>> On Fri, Mar 3, 2017 at 12:39 PM, Pablo Neira Ayuso <pablo@netfilter.org>=
 wrote:
>> > On Wed, Mar 01, 2017 at 02:47:23PM +0100, Alin Nastac wrote:
>> >> Link-local and multicast packets must keep their original oif after
>> >> ip6_route_me_harder is called.
>> >
>> > Out of curiosity, how does the setup you use look like to trigger this
>> > problem?
>>
>> ICMPv6 RA/NS/NA are marked by a -j MARK iptables rule (the mark value
>> is used to set the QoS queue).
>> Because skb->mark value changed, ip6t_mangle_out will call ip6_route_me_=
harder.
>
> That sounds quite standard. Did this broke after kernel upgrade? I'm
> trying to guess if the problem is somewhere else...

I used kernel version 4.1 to test an adapted version of this patch.

Judging after ip6_route_output_flags() definition present in kernel
version 4.10, callers are expected to provide a valid value for
fl6->flowi6_oif when rt6_need_strict(&fl6->daddr) is true.
