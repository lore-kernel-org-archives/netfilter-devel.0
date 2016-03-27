From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] configure: exit if libnftnl is not found
Date: Sun, 27 Mar 2016 22:29:43 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1603272227370.31636@nerf40.vanv.qr>
References: <1459073146-11576-1-git-send-email-giuseppelng@gmail.com> <alpine.LSU.2.20.1603271451020.23293@nerf40.vanv.qr> <CAFpD06TyVSe5_YvsNoJV9LFbHsFGaWhBPu-C=PtVcrVVZbzH4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:53144 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbcC0U3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Mar 2016 16:29:45 -0400
In-Reply-To: <CAFpD06TyVSe5_YvsNoJV9LFbHsFGaWhBPu-C=PtVcrVVZbzH4g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-03-27 21:56, Giuseppe Longo wrote:
>> >+++ b/configure.ac
>> >@@ -128,6 +128,13 @@ if test "x$enable_nftables" =3D "xyes"; then
>> >
>> >=C2=A0 =C2=A0 =C2=A0 =C2=A0PKG_CHECK_MODULES([libnftnl], [libnftnl =
>=3D 1.0.5], [nftables=3D1],
>[nftables=3D0])
>> >
>> >+=C2=A0 =C2=A0 =C2=A0 if test "$nftables" =3D 0;
>> >+=C2=A0 =C2=A0 =C2=A0 then
>> >+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo "*** Error: =
No suitable libnftnl found. ***"
>> >+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo "=C2=A0 =C2=A0=
 Please install the 'libnftnl' package."
>> >+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 exit 1
>> >+=C2=A0 =C2=A0 =C2=A0 fi
>>
>> This is unnecessary. Just remove the 3rd and 4th argument from the
>> PKG_CHECK_MODULES call.
>
>We may use the 3rd argument instead of remove it.

What good would that do? If you abolish the nftables=3D0 case,
then everything else becomes 'always-nftables' and
[nftables=3D1] would be redundant to mention.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
