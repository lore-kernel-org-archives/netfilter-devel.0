From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RFC: net/netfilter reorganization
Date: Sun, 5 Oct 2008 10:35:05 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810051004230.21891@fbirervta.pbzchgretzou.qr>
References: <48E8B439.6030608@trash.net> <alpine.LNX.1.10.0810050925350.21891@fbirervta.pbzchgretzou.qr> <48E8C90D.10202@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40998 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYJEOfH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:35:07 -0400
In-Reply-To: <48E8C90D.10202@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 10:02, Patrick McHardy wrote:
>
> Yes, confusing wording. I meant splitting them up internally,
> i.e. xtables =3D> matches/targets etc, as described below. And
> its only about the directory structure of course, how things
> work together at runtime remains the same.

I would not want to split matches and targets. Yes I am aware that we
have these guys wanting to store it on case-ignorant filesystems, but
we would still have all the include files in a conflicting position.

net/netfilter/xtables/matches is already over my personal
preferred limit of 3. If at all, I think they should get
{pre|post}fixed =C3=A0 la tg_connmark.c (target) and mt_connmark.c (or
connmark_{tg,mt}.c, whichever makes 'em happy).

Also the idea of merging files for the benefit of reduces in-memory
size was floating. I have revisited the koredux branch since you said
on-disk size ain't important, so the exact _memory_ statistic is:

One extension per module:

Single blob:
	Module                  Size  Used by
	xtables_ext            94312  0 (on-disk size 160K)

All blobs that xtables_ext encompasses:
	Module                  Size  Used by
	ip6t_mh                 2176  0=20
	ip6t_hl                 2176  0=20
	ip6t_eui64              2240  0=20
	ip6t_HL                 2432  0=20
	ipt_ttl                 2112  0=20
	ipt_ecn                 2496  0=20
	ipt_ah                  2176  0=20
	ipt_addrtype            3136  0=20
	ipt_ULOG                9096  0=20
	ipt_TTL                 2496  0=20
	ipt_REJECT              3712  0=20
	ipt_LOG                 6400  0=20
	ipt_ECN                 3072  0=20
	xt_u32                  2816  0=20
	xt_time                 3136  0=20
	xt_tcpudp               3840  0=20
	xt_tcpmss               2624  0=20
	xt_string               2752  0=20
	xt_statistic            2368  0=20
	xt_sctp                 3456  0=20
	xt_recent              11232  0=20
	xt_realm                1984  0=20
	xt_rateest              3136  0=20
	xt_quota                2304  0=20
	xt_policy               3648  0=20
	xt_pkttype              2304  0=20
	xt_physdev              2960  0=20
	xt_owner                3328  0=20
	xt_multiport            3840  0=20
	xt_mark                 2496  0=20
	xt_mac                  2240  0=20
	xt_limit                2752  0=20
	xt_iprange              2944  0=20
	xt_hashlimit           12960  0=20
	xt_esp                  2432  0=20
	xt_dccp                 3464  0=20
	xt_comment              2176  0=20
	xt_dscp                 3264  0=20
	xt_TRACE                1984  0=20
	xt_TCPOPTSTRIP          3136  0=20
	xt_TCPMSS               4992  0=20
	xt_SECMARK              3012  0=20
	xt_RATEEST              4676  1 xt_rateest
	xt_NFQUEUE              2304  0=20
	xt_NFLOG                2368  0=20
	xt_MARK                 3136  0=20
	xt_DSCP                 4160  0=20
	xt_CLASSIFY             2048  0=20
	total                 165992  (on disk about 1037K)

That's a 43% reduction in memory.

>> -rw-r--r-- 1 15924 2008-09-09 20:34 nf_conntrack_ftp.c
>> -rw-r--r-- 1 43369 2008-09-09 20:33 nf_conntrack_proto_tcp.c
>>=20
>> and in everybody's mind, FTP is a protocol too of course, =E2=80=9Cs=
o why
>> does not ftp have a _proto part, and why does TCP?=E2=80=9D one migh=
t ask.
>> We could just remove the _proto part (also helpful to reduce the
>> name length), as there is no clash between L3 and L4 trackers
>> except perhaps for proto_generic and l3proto_generic. Hm?
>
> Agreed, this is a good opportunity to fix that as well.
> The _proto prefix becomes redundant if we use
>
> net/netfilter/ct/protocols
>
> anyway.

It does not really solve anything IMHO. Protocols? FTP is one, so hm,
same confusion. This also got my anti-favorite 4-depth :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
