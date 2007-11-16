From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCHv3 2/2][RESEND] Addrtype match extension: limit addrtype
 check on the packet's interface
Date: Fri, 16 Nov 2007 16:30:03 +0100
Message-ID: <473DB77B.4090206@balabit.hu>
References: <119514685071-git-send-email-panther@balabit.hu> <11952229272161-git-send-email-panther@balabit.hu> <Pine.LNX.4.64.0711161604060.3340@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:36308 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXKPPaI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 10:30:08 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id CA8D5C15AF
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Nov 2007 16:30:06 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0711161604060.3340@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt =EDrta:
> On Nov 16 2007 15:22, Laszlo Attila Toth wrote:
>> Addrtype match has a new revision (1), which lets address type check=
ing
>> limited to the interface the current packet belongs to. Either incom=
ing
>> or outgoing interface can be used depending on the current hook. In =
the
>> FORWARD hook two maches should be used if both interfaces have to be=
 checked.
>=20
> Hey would not it be cool if this was bumped to xt_addrtype,
> using .revision=3D0 with ipt_addrtype_info (with the old functionalit=
y),
> and let .revision=3D1 use xt_addrtype_info (with the new functionalit=
y).
> Much like the recently posted xt_tos/xt_owner.

xt_addrtype is ok, but the module loading in the userspace part=20
(iptables) tries to load the libxt_addrtype.so first and only if it is=20
not succeeded try to load libipt_addrtype.so also the latter shared=20
object will never be loaded.

Also it may be better if only the xt_addrtype remains and=20
ipt_addrtype_info is used for the old one and xt_addrtype_info for the=20
new one. But it may be confusing: ipt_* in the xt_* files...

>=20
>> -struct ipt_addrtype_info {
>> +enum
>> +{
>> +	IPT_ADDRTYPE_INVERT_SOURCE	=3D 0x0001,
>> +	IPT_ADDRTYPE_INVERT_DEST	=3D 0x0002,
>> +	IPT_ADDRTYPE_LIMIT_IFACE_IN	=3D 0x0004,
>> +	IPT_ADDRTYPE_LIMIT_IFACE_OUT	=3D 0x0008,
>> +};
>> +
>> +struct ipt_addrtype_info_v1 {
>> +	u_int16_t	source;		/* source-type mask */
>> +	u_int16_t	dest;		/* dest-type mask */
>> +	u_int32_t	flags;
>> +};
>> +
>> +struct ipt_addrtype_info_v0 {
>=20
> Is it actually ok to change ipt_addrtype_info into ipt_addrtype_info_=
v0?
> It does not break binary compat, but source-level compat.
>=20
>=20

Hm, you are right. I checked this in xt_MARK, it doesn't use the _v0=20
suffix for the old _info structure. I'll change this in addrtype.

--
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
