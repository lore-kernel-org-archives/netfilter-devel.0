From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] netfilter: don't track ICMPv6 negotiation message.
Date: Sun, 08 Feb 2009 18:35:38 +0100
Message-ID: <498F17EA.1030907@inl.fr>
References: <200901271007.n0RA78k6023294@toshiba.co.jp> <1233053715-30398-1-git-send-email-eric@inl.fr> <200902061130.29873.christoph.paasch@student.uclouvain.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, yasuyuki.kozakai@toshiba.co.jp,
	kaber@trash.net
To: Christoph Paasch <christoph.paasch@student.uclouvain.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:49908 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZBHRfp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Feb 2009 12:35:45 -0500
In-Reply-To: <200902061130.29873.christoph.paasch@student.uclouvain.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

Christoph Paasch a =E9crit :
> Hi,
>=20
> I have two questions regarding this patch.
>=20
> On Tue January 27 2009, Eric Leblond wrote:
>> +	type =3D icmp6h->icmp6_type - 130;
>> +	if (type >=3D 0 && type < sizeof(noct_valid_new)
>> +	    && noct_valid_new[type]) {
>> +		skb->nfct =3D &nf_conntrack_untracked.ct_general;
>> +		skb->nfctinfo =3D IP_CT_NEW;
>> +		nf_conntrack_get(skb->nfct);
>> +		return NF_ACCEPT;
>> +	}
>=20
> Why do you set skb->nfctinfo =3D IP_CT_NEW?
> Because in xt_state.c, at state_mt(...) :=20
> 	if it is in front of an untracked packet (using nf_ct_is_untracked(s=
kb)) it
> 	automatically sets the statebit to UNTRACKED and so the IP_CT_NEW is=
n't used.

Not much to say on that point. I wanted to be homogeneous with what is
done in xt_NOTRACK.c.

> Why do you return NF_ACCEPT and not -NF_ACCEPT?
> By returning a positiv value, the packet will continue it's way throu=
gh the=20
> connection tracker.

If I understand well, icmpv6_error will be called in nf_conntrack_core.=
c
as l4proto->error :

	if (l4proto->error !=3D NULL) {
		ret =3D l4proto->error(net, skb, dataoff, &ctinfo, pf, hooknum);
		if (ret <=3D 0) {
			NF_CT_STAT_INC_ATOMIC(net, error);
			NF_CT_STAT_INC_ATOMIC(net, invalid);
			return -ret;
		}
	}

It will thus increment error counters if return is -NF_ACCEPT. As the
packets we deal with are not error I don't think it is correct to retur=
n
- -NF_ACCEPT.

But I agree with the fact, that returning NF_ACCEPT leads to some
useless work inside the kernel.

BR,
- --
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFJjxfknxA7CdMWjzIRAn0aAKCQCN4JpW8eae4isbeSA/77Fl0vagCfdfhJ
7n/HGloTFIT9V+mAKnG4oPs=3D
=3D65y5
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
