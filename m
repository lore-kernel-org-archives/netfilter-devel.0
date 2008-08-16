From: =?UTF-8?B?UMSTdGVyaXMgS8S8YXZpxYbFoQ==?= <klavins@netspace.net.au>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and  
 similar) to avoid file name clash
Date: Sat, 16 Aug 2008 22:19:33 +0200
Message-ID: <g87cp8$bfa$1@ger.gmane.org>
References: <g84ufs$l66$1@ger.gmane.org> <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu> <alpine.LNX.1.10.0808161520430.27260@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0808162127200.21025@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:45421 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYHPUUD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:20:03 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KUSFl-0007eS-9X
	for netfilter-devel@vger.kernel.org; Sat, 16 Aug 2008 20:20:01 +0000
Received: from 217-133-15-180.b2b.tiscali.it ([217.133.15.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 20:20:01 +0000
Received: from klavins by 217-133-15-180.b2b.tiscali.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 20:20:01 +0000
In-Reply-To: <Pine.LNX.4.64.0808162127200.21025@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Sat, 16 Aug 2008, Jan Engelhardt wrote:
>=20
>> On Saturday 2008-08-16 15:14, Jozsef Kadlecsik wrote:
>>> On Sat, 16 Aug 2008, Jan Engelhardt wrote:
>>>> On Friday 2008-08-15 18:03, P=CB=99=CB=99teris K=CB=99=CB=99avi=CB=
=99=CB=99=C5=A1 wrote:
>>>>
>>>>> The changes are proposed in order to avoid file name clashes on
>>>>> filesystems that do not allow two files to have names that differ
>>>>> only in the case of their letters:
>>>>>
>>>>> include/linux/netfilter/xt_CONNMARK.h =3D> xt_connmark_target.h
>>>> [...]
>>>>
>>>> As I see it, this will already be addressed by merging complementa=
ry
>>>> code into one source file (e.g. MARK, mark, CONNMARK, connmark
>>>> all into a big new xt_mark.c), to reduce (a) amount of files
>>>> and (b) build time.
>>> [...]
>>>
>>> That is half of the story: we encode the functionality (match/targe=
t) in=20
>>> the case of the (file)name and there are targets which have got no =
match=20
>>> counterpart and thus no natural lowercase filename to merge into it=
=2E So=20
>>> the directory tree still will be broken on case-insensitive filesys=
tems.=20
>> We have not decided on filenames yet, just that matches/targets that
>> are commonly used together should go into a single file for the two
>> above-mentioned reasons, and lower-casing does not appear in (a) or =
(b).
>=20
> You wrote: "by merging into ... a big new xt_mark.c". Pteris also=20
> suggested fully lowercased names, e.g. xt_connmark_target.h. Or are y=
ou=20
> just pulling my leg by pointing to the possibility to >capitalize< al=
l=20
> the filenames in netfilter, to achieve case-insensitive filenames?

My suggested names were taken from within the files themselves.  Note=20
that the standard #ifdef multiple inclusion guards in the existing file=
s=20
could not follow normal practice and had to be modified in some way,=20
because by tradition they are simply uppercase transformations of the=20
filename itself (but that would end up in a clash!), and so the=20
xt_CONNMARK.h include guard is "_XT_CONNMARK_H_target".  By natural=20
extension, my proposal was to rename the existing uppercase file to=20
xt_connmark_target.h.  However, for the typical case-insensitive=20
filesystems out there, it is fine for the file to be called=20
xt_CONNMARK_target.h, and I have no objection to that, so long as that=20
doesn't clash with another filename differing only in the case of the=20
letters:

$ ls | grep -i xt_connmark | while read i; do grep _H $i /dev/null; don=
e
xt_CONNMARK.h:#ifndef _XT_CONNMARK_H_target
xt_CONNMARK.h:#define _XT_CONNMARK_H_target
xt_CONNMARK.h:#endif /*_XT_CONNMARK_H_target*/
xt_connmark.h:#ifndef _XT_CONNMARK_H
xt_connmark.h:#define _XT_CONNMARK_H
xt_connmark.h:#endif /*_XT_CONNMARK_H*/

--=20
  Peter Klavins

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
