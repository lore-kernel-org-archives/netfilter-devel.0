From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [resend net-next] socket: Added 'transparent' option
Date: Thu, 04 Jun 2009 17:27:44 +0200
Message-ID: <4A27E7F0.6010403@balabit.hu>
References: <1244122013-25970-1-git-send-email-panther@balabit.hu> <4A27CD5A.6040303@trash.net> <alpine.LSU.2.00.0906041653420.13894@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:54946 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751692AbZFDP1o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 11:27:44 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 5597213A2F9
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2009 17:27:45 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0906041653420.13894@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt =EDrta:
> On Thursday 2009-06-04 15:34, Patrick McHardy wrote:
>> Laszlo Attila Toth wrote:
>>> +++ b/include/linux/netfilter/xt_socket.h
>>> @@ -0,0 +1,8 @@
>>> +#ifndef _XT_SOCKET_H_match
>>> +#define _XT_SOCKET_H_match
>>> +
>>> +struct xt_socket_match_info1 {
>>> +	__u8 transparent;
>>> +};
>> Please use a bitmask.
>=20
> enum {
> 	XT_SOCKET_TRANSPARENT =3D 1 << 0,
> };
>=20
> struct xt_socket_mtinfo1 {
> 	__u8 flags;
> };
>=20

Thanks.

My first thought was simply: =3D 1, without offset (and of course =3D 2=
 ...).

I'm also working on a newer revision of the limit match, which is almos=
t=20
done. It can be inverted (! --limit ...). I think in this case a=20
bitfield can be used, but it is probably not necessary, the following=20
extra member is enogh:

	u_int32_t invert;

(I wouldn't like to resend the patch it if it is not the best choice).

--=20
Attila
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
