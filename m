From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCH 2/2] Addrtype match extension: limit addrtype check on
 the packet's interface
Date: Thu, 18 Oct 2007 13:34:43 +0200
Message-ID: <471744D3.5090208@balabit.hu>
References: <470F7EB1.2080309@balabit.hu> <11921980402340-git-send-email-panther@balabit.hu> <11921980402033-git-send-email-panther@balabit.hu> <47172481.601@trash.net>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:45025 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbXJRLet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 07:34:49 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id E9BBEC124C
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Oct 2007 13:34:47 +0200 (CEST)
In-Reply-To: <47172481.601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy =EDrta:
> Laszlo Attila Toth wrote:
>> +static bool match_v1(const struct sk_buff *skb,
>>            const struct net_device *in, const struct net_device *out=
,
>>            const struct xt_match *match, const void *matchinfo,
>>            int offset, unsigned int protoff, bool *hotdrop)
>>  {
>>      const struct ipt_addrtype_info *info =3D matchinfo;
>>      const struct iphdr *iph =3D ip_hdr(skb);
>> +    const struct net_device *limit_dev =3D (info->flags &=20
>> IPT_ADDRTYPE_LIMIT_IFACE) ? in : NULL;
>=20
>=20
> The match can be used on any hook, using the incoming interface
> is a bit unflexible. How about using the incoming interface for
> src-address and outgoing interface for destination address matches?
> Alternatively add two flags to specify which device to use. You'll
> need to add proper checks of course to make sure the interface is
> valid for the hook the match is used in.

Two flags would be better because the forward chain can be handled=20
specially. For all the others two different options arn't necessary.
In the forward chain both src and the dst addrtypes would be checked=20
twice in this case, once on the input interface and once on the output.

--=20
Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
