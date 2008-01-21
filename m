From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 15:26:32 +0100
Message-ID: <4794AB98.1050607@balabit.hu>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr> <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211417200.24186@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:38112 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbYAUO0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:26:35 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id D8F2CC1621
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jan 2008 15:26:33 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0801211417200.24186@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt =EDrta:
> On January 21 2008 10:11, Laszlo Attila Toth wrote:
>> Jan Engelhardt wrote:
>>> I just remembered that xt_socket (from tproxy) does an (explicit) s=
ocket
>>> lookup. xt_owner on the other hand, takes the socket pointer from t=
he skb --
>>> which of course only works in the output path.
>>>
>>> xt_owner is still in the 2.6.25 development queue, and because the =
two
>>> modules are similar, I thought that maybe xt_owner could be merged =
with
>>> xt_socket (doing a rename to xt_socket in the current net-2.6.25),
>>> because they are quite close in their task.
>>>
>>> That would also allow xt_owner to be used in the input path.
>>>
>>> Opinions?
>> Hello,
>>
>> That sounds great.
>>
>> Note that the socket match depends on tproxy core, also the tproxy w=
ould be
>> partially merged into the net-2.25 tree. [...]
>=20
> Here is what I had in mind, please have a look.
> http://dev.computergmbh.de/gitweb.cgi?p=3Dlinux;h=3Ddev-xtsocket;a=3D=
shortlog
>=20


The following snippet of socket_mt_get() should be in socket_mt():

        if (sk !=3D NULL)
                  nf_tproxy_put_sock(sk);

The socket buffer is first referenced by nf_tproxy_get_v4() then=20
immediately released (put back) also it is not garanteed that the socke=
t=20
is valid. Furthermore I don't know whether the sk->sk_socket is valid=20
through the whole function in a multiprocessor environment (the program=
,=20
that opened it, may close the socket).


The tproxy lookup only works with tcp and udp, and afaik the original=20
owner match also limited to these protocols, also it can be tested in=20
socket_mt4_check()

I noticed that you forgot rename the match to "socket" in socket_mt_reg=
[].

Except these the patch is ok.

--=20
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
