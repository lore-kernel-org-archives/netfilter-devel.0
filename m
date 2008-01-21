From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: xt_owner-xt_socket plans
Date: Mon, 21 Jan 2008 10:11:30 +0100
Message-ID: <479461C2.1060703@balabit.hu>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
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
Received: from www.balabit.hu ([212.92.18.33]:50556 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbYAUJLe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 04:11:34 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 0F6D8C15D2
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jan 2008 10:11:32 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt =EDrta:
> Hi,
>=20
>=20
> I just remembered that xt_socket (from tproxy) does an (explicit) soc=
ket=20
> lookup. xt_owner on the other hand, takes the socket pointer from the=
=20
> skb -- which of course only works in the output path.
>=20
> xt_owner is still in the 2.6.25 development queue, and because the tw=
o=20
> modules are similar, I thought that maybe xt_owner could be merged wi=
th=20
> xt_socket (doing a rename to xt_socket in the current net-2.6.25),
> because they are quite close in their task.
>=20
> That would also allow xt_owner to be used in the input path.
>=20
> Opinions?
>=20

Hello,

That sounds great.

Note that the socket match depends on tproxy core, also the tproxy woul=
d=20
be partially merged into the net-2.25 tree. This is the 9th patch in
=20
http://people.netfilter.org/hidden/tproxy/tproxy4-2.6.24-200710190050.t=
ar.bz2

and it is marked as experimental although the owner match is not=20
experimental.

--=20
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
