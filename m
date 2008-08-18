From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and similar)
 to avoid file name clash
Date: Mon, 18 Aug 2008 13:17:10 +0200
Message-ID: <48A95A36.7090505@trash.net>
References: <g84ufs$l66$1@ger.gmane.org> <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	=?UTF-8?B?UHRlcmlzIEthdmnCuQ==?= <klavins@netspace.net.au>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYHRLRR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2008 07:17:17 -0400
In-Reply-To: <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Sat, 16 Aug 2008, Jan Engelhardt wrote:
>=20
>> On Friday 2008-08-15 18:03, P=CB=99=CB=99teris K=CB=99=CB=99avi=CB=99=
=CB=99=C5=A1 wrote:
>>
>>> This is a request for comments on the proposal that the following
>>> filename changes (indicative at this point) be made in the
>>> netfilter source code tree, together with correcting the
>>> corresponding references to the files in both source code, the
>>> build system, and wherever else necessary.
>>>
>>> The changes are proposed in order to avoid file name clashes on
>>> filesystems that do not allow two files to have names that differ
>>> only in the case of their letters:
>>>
>>> include/linux/netfilter/xt_CONNMARK.h =3D> xt_connmark_target.h
>> [...]
>>
>> As I see it, this will already be addressed by merging complementary
>> code into one source file (e.g. MARK, mark, CONNMARK, connmark
>> all into a big new xt_mark.c), to reduce (a) amount of files
>> and (b) build time.
> [...]
>=20
> That is half of the story: we encode the functionality (match/target)=
 in=20
> the case of the (file)name and there are targets which have got no ma=
tch=20
> counterpart and thus no natural lowercase filename to merge into it. =
So=20
> the directory tree still will be broken on case-insensitive filesyste=
ms.=20
>=20
> If as a side effect of some real internal changes netfilter becomes=20
> compatible with case-insensitive filesystems, that's fine. However, I=
=20
> object changes just for the sake to be compatible with such horrid=20
> filesystems.

I agree. Without compat files this would also break compilation
of old userspace, so this is not an option anyways.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
