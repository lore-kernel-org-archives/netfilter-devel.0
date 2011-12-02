From: Patrick McHardy <kaber@trash.net>
Subject: Re: nat drop the icmp redirect packet
Date: Fri, 02 Dec 2011 13:58:42 +0100
Message-ID: <4ED8CB82.40603@trash.net>
References: <4ED2E00B.3000006@cn.fujitsu.com> <4ED67BB1.8020808@trash.net> <4ED6D18C.7000802@cn.fujitsu.com> <4ED754EA.9060906@trash.net> <4ED862E6.6090104@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35976 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab1LBM6w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:58:52 -0500
In-Reply-To: <4ED862E6.6090104@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.12.2011 06:32, Gao feng wrote:
> =E4=BA=8E 2011=E5=B9=B412=E6=9C=8801=E6=97=A5 18:20, Patrick McHardy =
=E5=86=99=E9=81=93:
>> Yes, as I said, we could set up a NULL source mapping on the
>> conntrack of the original packet and let the REDIRECT through.
>> The user might have configured a source NAT rule though which
>> would become ineffective by this.
>>
>=20
> Hi Patrick:
>=20
> Yes,you are right.
>=20
> You mean we have no idea of the ICMP REDIRECT packet being droppen
> when nat is not finished?

We can't determine whether we could let it through at that point.
The safe choice is to drop it.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
