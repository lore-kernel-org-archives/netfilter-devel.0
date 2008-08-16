From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and
 similar) to avoid file name clash
Date: Sat, 16 Aug 2008 15:22:47 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808161520430.27260@fbirervta.pbzchgretzou.qr>
References: <g84ufs$l66$1@ger.gmane.org> <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Pteris_Kavi=C5=A1?= <klavins@netspace.net.au>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60724 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbYHPTWt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:22:49 -0400
In-Reply-To: <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2008-08-16 15:14, Jozsef Kadlecsik wrote:
>On Sat, 16 Aug 2008, Jan Engelhardt wrote:
>> On Friday 2008-08-15 18:03, P=CB=99=CB=99teris K=CB=99=CB=99avi=CB=99=
=CB=99=C5=A1 wrote:
>>=20
>> > The changes are proposed in order to avoid file name clashes on
>> > filesystems that do not allow two files to have names that differ
>> > only in the case of their letters:
>> >
>> > include/linux/netfilter/xt_CONNMARK.h =3D> xt_connmark_target.h
>> [...]
>>=20
>> As I see it, this will already be addressed by merging complementary
>> code into one source file (e.g. MARK, mark, CONNMARK, connmark
>> all into a big new xt_mark.c), to reduce (a) amount of files
>> and (b) build time.
>[...]
>
>That is half of the story: we encode the functionality (match/target) =
in=20
>the case of the (file)name and there are targets which have got no mat=
ch=20
>counterpart and thus no natural lowercase filename to merge into it. S=
o=20
>the directory tree still will be broken on case-insensitive filesystem=
s.=20

We have not decided on filenames yet, just that matches/targets that
are commonly used together should go into a single file for the two
above-mentioned reasons, and lower-casing does not appear in (a) or (b)=
=2E
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
