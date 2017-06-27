From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: crash on >= 4.9.0 kernel seems nf related
Date: Tue, 27 Jun 2017 13:23:09 +0200
Message-ID: <CAJO99TnXE_5d4+1cEhRK570n6jOKntYn85c9rcMP8T0KuWdDHQ@mail.gmail.com>
References: <CAJO99T==ryD91RF_O71F2k=m8_UokF+nwQnfi6pAGH7Oj7V+ZQ@mail.gmail.com>
 <CAJO99TkhZLWTpKEk=7VGbXhZvDD4ajiOaxd0bjnxKucq=_2Z0A@mail.gmail.com>
 <20170516082128.GB16290@breakpoint.cc> <CAJO99T=4LQgUngzoSvpVED_+hxYT1bOtHzUXjBu-Jq4d4+7SuA@mail.gmail.com>
 <CAJO99T=5RPz691h9kAnSsC4fy_54o3qWU_2o-4FhHrxp5af7MQ@mail.gmail.com> <20170626131632.GI29636@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:34453 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751699AbdF0LXK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2017 07:23:10 -0400
Received: by mail-yw0-f172.google.com with SMTP id l21so2078010ywb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 04:23:10 -0700 (PDT)
In-Reply-To: <20170626131632.GI29636@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-06-26 15:16 GMT+02:00 Florian Westphal <fw@strlen.de>:
> Bj=C3=B8rnar Ness <bjornar.ness@gmail.com> wrote:
>> When trying to narrow down the problem, I removed the NAT rules, and
>> in particular
>> the
>>
>> chain postrouting {
>>   type nat hook postrouting priority 100
>> }
>>
>> And the problem disappears. Commenting in the above block again,
>> causes the following to happen:
>>
>> kworker/0:0 starts to use more and more cpu, and in less than a minute
>> renders the
>> machine useless. If network cable is unplugged, it takes aroung 30
>> seconds for the machine to get into a useful state again.
>
> The kworker is most likely the conntrack gc worker, but the gc worker is =
nat
> agnostic, so I don't see how this makes a difference wrt. nat
> postrouting hook presence.

It might ofcorse be just the straw that brpke the camel's back, but
this behavior
is reproducible, and is present in 4.9.0-rc6, 4.11.0 and 4.12.0-rc6.
We do not have
problems with 4.8.6 (but as mentioned, it has other conntrack problems repo=
rted
earlier)

> perf top might help pinpoint the source.
>
> What kernel is this, exactly?
>
> 4.10 (and 4.9.14 and later) has a change to make gc worker use less
> cycles.

We see the behavior in 4.11.0 and 4.12.0-rc6 as well

> But I don't see the NAT connection.

Not sure what you mean here. We do not eed to have rules in the
postrouting chain for it
to tear down the server. Monitoring conntrack entries also shows me
this is stable around 120k

--=20
Bj(/)rnar
