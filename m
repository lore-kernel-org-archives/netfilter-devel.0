From: Alexey Perevalov <alexey.perevalov@hotmail.com>
Subject: RE: [PATCH v3 kernel 19/29] add byte threshold capability to nfacct
Date: Wed, 17 Jul 2013 23:44:52 +0400
Message-ID: <DUB115-W111E071AA6B57D46753934B8D610@phx.gbl>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>,<1373480727-11254-20-git-send-email-michael.zintakis@googlemail.com>,<20130710200053.GC27468@breakpoint.cc>,<51DEFFE6.5070907@googlemail.com>,<20130711202547.GH27468@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"michael.zintakis@googlemail.com" <michael.zintakis@googlemail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dub0-omc4-s18.dub0.hotmail.com ([157.55.2.93]:39228 "EHLO
	dub0-omc4-s18.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540Ab3GQTw0 convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:52:26 -0400
In-Reply-To: <20130711202547.GH27468@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Date: Thu, 11 Jul 2013 22:25:47 +0200
> From: fw@strlen.de
> To: michael.zintakis@googlemail.com
> CC: fw@strlen.de; netfilter-devel@vger.kernel.org; pablo@netfilter.or=
g
> Subject: Re: [PATCH v3 kernel 19/29] add byte threshold capability to=
 nfacct
>=20
> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>> Florian Westphal wrote:
>>> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>>>> * add a 'bthr' variable to each nfacct object, allowing a bytes 't=
hreshold'
>>>> to be stored and then reported if/when traffic breaches it.
>>>=20
>>> Again, why is this needed?
>>> Why is it useful?
>> This is used for measuring traffic "expectancy", i.e. allows one to =
be able to register what amount of traffic is "expected" to pass throug=
h this accounting object. If that traffic threshold is exceeded, this i=
s properly indicated when the accounting object is listed or any statis=
tics for that object are being collected by the nfacct daemon.
>>=20
>> That traffic "expectancy" can be set/reset depending on the nature o=
f the traffic or its source/destination etc, so it is pretty flexible. =
Again, there is extensive information on this in the (revised) man page=
 if you decide to look at it.
>=20
> I still don't understand why this needs to be in the kernel.
> nfacct gives you the counters, how these are interpreted (e.g. 'highe=
r
> than expected' should be entirely up to userspace).
>=A0
I also vote for this patch.
I'll try here to describe our use case.
We checking counter every minute, why not to check it more often? It's =
possible and doesn't lead to huge performance problems, but we want to =
save battery power and we don't want such big resolution in measurement=
s. But also we need to restrict traffic according to predefined user qu=
ota. To not exceed such restriction we need to deligate such responsobi=
lity to kernel.
Now I talking only about wireless connection, but even on 3G it's possi=
ble to download more than 50Mb per one minute.
Also we need to inform user about quota comming beforehand. Based on gi=
ven kernel couters update time interval, quota value and bandwidth I ca=
me to conclusion what it's better to have some warning threshold for in=
forming user space from kernel.
I predict here comment about none general use case :)

I thought to add it to xt_quota, but nfacct it's better place.


> In case you need some way of reacting to excess counters, then perhap=
s
> it makes sense to change nfacct match to allow "greater/less than"
> matching expression instead?
>=20
> E.g.:
> -A bla -m nfacct --nfacct-name bla --nfacct-packets 1000000: -m limit
> --limit 1/hour -j NFLOG --nflog-prefix 'bla packet threshold'
>=20
> or something like that?
It's fit too.

P.S. =A0we don't use neither nfacct now, nor xt_quota due we counting b=
ased on net_cls (cls_cgroup) marks and as I understand it's not possibl=
e for incomming traffic without netfilter refactoring.
>=20
> There is something similar for the conntrack accounting (-m connbytes=
).
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html 		 =
	   		  --
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
