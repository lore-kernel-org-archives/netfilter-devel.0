From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] alternative to conntrack ID
Date: Wed, 18 May 2005 11:30:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505180948180.9582@blackhole.kfki.hu>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
	<20050429080242.GJ9735@sunbeam.de.gnumonks.org>
	<42789366.20702@ufomechanic.net>
	<4278B23A.7050406@trash.net> <4278B98E.7090707@ufomechanic.net>
	<427B8A46.8090006@trash.net> <427D26E7.8060701@ingate.com>
	<427D3EAF.3020200@trash.net> <427D41FA.5080506@ingate.com>
	<1115648236.25627.17.camel@nienna.balabit>
	<428A1807.8070708@ufomechanic.net> <428A5141.20901@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <428A5141.20901@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 17 May 2005, Patrick McHardy wrote:

> Amin Azez wrote:
> > KOVACS Krisztian wrote:
> >
> >>   Probably Patrick was referring to a possible problem where the
> >> following happens: a new connection is established and destroyed in a
> >> very short time. If a new connection with the same tuple is created
> >> before the timestamp increases (which is perfectly possible IMHO if you
> >> have some slow embedded HW with no high precision timer available)
>
> Exactly.
>
> > After further reading I think this scenario is highly unlikely.
>
> Unlikely is still enough reason to handle it properly in an API.
> Otherwise anything you build on top of it has to take this into
> account for any guarantees it would like to give. And so far, I
> haven't even seen a suggestion how to notice it - which would
> also be fine with me.

I think we should not state any guarantee here. Conntrack entries are
uniquely identified by tuples, that's all we should say.

There *is* a certain ambiquity, when, during te kernel-userspace
communication, a conntrack entry is deleted and a new one with the same
tuples is created, but that can be documented clearly.

In order to create unique identification of conntrack entries, there were
a couple of clever suggestions, all of them burdened by something:

- timer based solutions may be not fine-grained enough
- pointer of conntrack is not unique as it can be reused
- id creates a new possible bottleneck

What wrong can happen, if a reborn conntrack entry is deleted instead of
the original one?

If the conntrack entry is to be dropped due to a change in policy, then
what we did is just fine! If there was a "stuck" conntrack entry and the
admin was going to delete it manually but it went away and he deleted the
new conntrack entry, that's an unfortunate event - but the user was in
trouble anyway.

So - do we really need such accuracy?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
