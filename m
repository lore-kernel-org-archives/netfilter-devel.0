From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_RAWNAT target idea
Date: Mon, 14 Jan 2008 10:53:14 +0100
Message-ID: <478B310A.3040300@trash.net>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr> <478AFB75.7040701@trash.net> <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbYANJ6b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:58:31 -0500
In-Reply-To: <Pine.LNX.4.64.0801140944000.10906@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 14 2008 07:04, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> the following series implements xt_RAWNAT, a target to do network
>>> address translation not depending on conntrack. I still have an iss=
ue
>>> though, if you have an idea what could be wrong, please let me know=
=2E
>> Whats the advantage over using the TC NAT action?
>=20
> Let me put it this way... =E2=80=9Cwhat is tc?=E2=80=9D
>=20
> - tc is a real black-box to most users;
>   lack of documentation (despite lartc.org efforts)

That should be fixed by writing documentation, not code :)

> - act_nat only works like NETMAP, i.e.
>   on outgoing packets, you can only change the source addr

I guess it could be changed to support DNAT on outgoing packets
quite easily.

> At which point I would be asking: why is tc trying to do the same
> as netfilter mangling targets?

Well, true, it would be nice to be able to do this within
netfilter without TC actions. But adding a new chain to the
raw table is a high price, every new netfilter hooks costs
quite a bit of performance. Why not simply do this in the
mangle table? That will also make rerouting in OUTPUT work
as a side effect.

Another issue is IPv6 support. Everyone agrees that we don't
want to support IPv6 NAT. So this would have to be removed.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
