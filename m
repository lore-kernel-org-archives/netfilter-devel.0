From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Wed, 07 Nov 2007 12:37:21 +0100
Message-ID: <4731A371.5000705@trash.net>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc> <47307498.70104@trash.net> <005301c820fc$35c63a10$6400a8c0@ronPc> <47318A3C.5070701@trash.net> <47319460.8040305@trash.net> <47319A8A.3050007@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58867 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbXKGLhk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:37:40 -0500
In-Reply-To: <47319A8A.3050007@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Please don't trim CC lists.

Pascal Hambourg wrote:
> Patrick McHardy a =E9crit :
>>
>> I can reproduce this with forwarding between two bridges.
>=20
> This matches my own observations.
>=20
>> The reason is that skb->nf_bridge still contains the data
>> from the first bridge and so br_netfilter thinks this is
>> a bridged packet.
>=20
> Am I missing something if I think that this behaviour is badly broken=
 ?
>=20
>> I don't know how this is supposed to work,
>> but it seems to me that on packets going out a bridge device
>> this should be reset in case it originates from a different
>> bridge (actually I think it should be reset unconditionally
>=20
> So do I. Otherwise a packet received on a bridge can be forwarded bac=
k=20
> to the same bridge and would be wrongly considered bridged.
>=20
>> but that would probably break bridged DNAT).
>=20
> Why ?


Because if I'm not mistaken these packets also go through the
bridge device xmit function.
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
