From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and  
 similar) to avoid file name clash
Date: Mon, 18 Aug 2008 00:04:22 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808172211180.21894@blackhole.kfki.hu>
References: <g84ufs$l66$1@ger.gmane.org> <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0808162057270.20963@blackhole.kfki.hu>
 <alpine.LNX.1.10.0808161520430.27260@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0808162127200.21025@blackhole.kfki.hu> <g87cp8$bfa$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-1033657189-1219006955=:21894"
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?UMSTdGVyaXMgS8S8YXZpxYbFoQ==?= <klavins@netspace.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48665 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343AbYHQWEY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:04:24 -0400
In-Reply-To: <g87cp8$bfa$1@ger.gmane.org>
Content-ID: <Pine.LNX.4.64.0808172302570.21894@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-1033657189-1219006955=:21894
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0808172302571.21894@blackhole.kfki.hu>

On Sat, 16 Aug 2008, Pteris Kavi=B9 wrote:

> Jozsef Kadlecsik wrote:
> > On Sat, 16 Aug 2008, Jan Engelhardt wrote:
> >=20
> > > On Saturday 2008-08-16 15:14, Jozsef Kadlecsik wrote:
> > > > On Sat, 16 Aug 2008, Jan Engelhardt wrote:
> > > > > On Friday 2008-08-15 18:03, Pteris Kavi=B9 wrote:
> > > > >=20
> > > > > > The changes are proposed in order to avoid file name clashes on
> > > > > > filesystems that do not allow two files to have names that diff=
er
> > > > > > only in the case of their letters:
> > > > > >=20
> > > > > > include/linux/netfilter/xt_CONNMARK.h =3D> xt_connmark_target.h
> > > > > [...]
> > > > >=20
> > > > > As I see it, this will already be addressed by merging complement=
ary
> > > > > code into one source file (e.g. MARK, mark, CONNMARK, connmark
> > > > > all into a big new xt_mark.c), to reduce (a) amount of files
> > > > > and (b) build time.
> > > > [...]
> > > >=20
> > > > That is half of the story: we encode the functionality (match/targe=
t) in
> > > > the case of the (file)name and there are targets which have got no =
match
> > > > counterpart and thus no natural lowercase filename to merge into it=
=2E So
> > > > the directory tree still will be broken on case-insensitive filesys=
tems.=20
> > > We have not decided on filenames yet, just that matches/targets that
> > > are commonly used together should go into a single file for the two
> > > above-mentioned reasons, and lower-casing does not appear in (a) or (=
b).
> >=20
> > You wrote: "by merging into ... a big new xt_mark.c". Pteris also sugge=
sted
> > fully lowercased names, e.g. xt_connmark_target.h. Or are you just pull=
ing
> > my leg by pointing to the possibility to >capitalize< all the filenames=
 in
> > netfilter, to achieve case-insensitive filenames?
>=20
> My suggested names were taken from within the files themselves.  Note=20
> that the standard #ifdef multiple inclusion guards in the existing files=
=20
> could not follow normal practice and had to be modified in some way,=20
> because by tradition they are simply uppercase transformations of the=20
> filename itself (but that would end up in a clash!), and so the=20
> xt_CONNMARK.h include guard is "_XT_CONNMARK_H_target".  By natural=20
> extension, my proposal was to rename the existing uppercase file to=20
> xt_connmark_target.h.  However, for the typical case-insensitive=20
> filesystems out there, it is fine for the file to be called=20
> xt_CONNMARK_target.h, and I have no objection to that, so long as that=20
> doesn't clash with another filename differing only in the case of the=20
> letters:
[...]

I should have looked up the old thread at the first place:
http://marc.info/?l=3Dnetfilter-devel&m=3D109795874701112&w=3D2

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-1033657189-1219006955=:21894--
