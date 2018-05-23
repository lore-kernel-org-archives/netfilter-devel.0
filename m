From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v15 4/7] sch_cake: Add NAT awareness to packet classifier
Date: Wed, 23 May 2018 22:38:30 +0200
Message-ID: <87in7exg3d.fsf@toke.dk>
References: <152699741881.21931.11656377745581563912.stgit@alrua-kau> <152699745846.21931.4558451708304709296.stgit@alrua-kau> <20180523.144442.864194409238516747.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523.144442.864194409238516747.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Date: Tue, 22 May 2018 15:57:38 +0200
>
>> When CAKE is deployed on a gateway that also performs NAT (which is a
>> common deployment mode), the host fairness mechanism cannot distinguish
>> internal hosts from each other, and so fails to work correctly.
>>=20
>> To fix this, we add an optional NAT awareness mode, which will query the
>> kernel conntrack mechanism to obtain the pre-NAT addresses for each pack=
et
>> and use that in the flow and host hashing.
>>=20
>> When the shaper is enabled and the host is already performing NAT, the c=
ost
>> of this lookup is negligible. However, in unlimited mode with no NAT bei=
ng
>> performed, there is a significant CPU cost at higher bandwidths. For this
>> reason, the feature is turned off by default.
>>=20
>> Cc: netfilter-devel@vger.kernel.org
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> This is really pushing the limits of what a packet scheduler can
> require for correct operation.

Well, Cake is all about pushing the limits of what a packet scheduler
can do... ;)

> And this creates an incredibly ugly dependency.

Yeah, I do agree with that, and I'd love to get rid of it. I even tried
prototyping what it would take to lookup the symbols at runtime using
kallsyms. It wasn't exactly prettier; pushed it here in case anyone
wants to recoil in horror (completely untested, just got it to the point
where the module compiles with no nf_* symbols according to objdump):

https://github.com/dtaht/sch_cake/commit/97270a10dcea236d137f5113aaeb430309=
8ab3f3

> I'd much rather you do something NAT method agnostic, like save or
> compute the necessary information on ingress and then later use it on
> egress.

How would this work? We would have to add some kind of global state
shared between all instances of the qdisc, and maintain state for all
flows we see going through there, effectively duplicating conntrack, and
also requiring people to run Cake on all interfaces? How is that better?

> Because what you have here will completely break when someone does NAT
> using eBPF, act_nat, or similar.
>
> There is even skb->rxhash, be creative :-)

This is not actually about improving hashing; the post-NAT information
is fine for that. It's about making sure the per-host fairness works
when NATing, so we can distribute bandwidth between the hosts on the
local LAN regardless of how many flows they open. This is one of the
"killer features" of Cake - it was the top requested feature until we
implemented it. So it would be a shame to drop it.

Since act_nat is a 1-to-1 mapping I don't think we would have any loss
of functionality with that. For eBPF, well, obviously all bets are off
as far as reusing any state. But it's not unreasonable to expect people
who do NAT in eBPF to also set skb->tc_classid if they want pre-nat host
fairness, is it?

Which means that the only remaining issue is the module dependency. Can
we live with that (noting that it'll go away if conntrack is configured
out of the kernel entirely)? Or is the kallsyms approach a viable way
forward? I guess we could add a kconfig option that toggles between that
and native calls, so that we'd at least get a compile error on suitably
configured kernels if the API changes...

-Toke
