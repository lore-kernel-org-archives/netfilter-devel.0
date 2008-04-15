From: "Rick Xu" <rickxbx@gmail.com>
Subject: Re: Something like a bug
Date: Wed, 16 Apr 2008 00:00:14 +0800
Message-ID: <dbdd0cc00804150900r64924253g14e0d52a5d14ff1c@mail.gmail.com>
References: <dbdd0cc00804140027y54a00ca7pdef3b091dde33bf6@mail.gmail.com>
	 <4804CE07.3060507@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:33848 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbYDOQAP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:00:15 -0400
Received: by an-out-0708.google.com with SMTP id d31so551802and.103
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2008 09:00:14 -0700 (PDT)
In-Reply-To: <4804CE07.3060507@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2008 at 11:47 PM, Pablo Neira Ayuso <pablo@netfilter.or=
g> wrote:
> Rick Xu wrote:
>  > int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type,
>  >                const void *data, int alen)
>  > {
>  >  ......
>  >
>  >     if ((NFA_OK(nfa, nfa->nfa_len) + len) > maxlen) {
>  >         errno =3D ENOSPC;
>  >         return -1;
>  >     }
>  >
>  >     subnfa =3D (struct nfattr *)(((char *)nfa) + NFA_OK(nfa, nfa->=
nfa_len));
>  >
>  > .....
>  > }
>  >
>  > NFA_OK looks so weird here. I think it should be:
>  > int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type,
>  >                const void *data, int alen)
>  > {
>  >  ......
>  >
>  >     if ( NFA_ALIGN(nfa->nfa_len) + NFA_LENGTH(len) > maxlen) {
>  >         errno =3D ENOSPC;
>  >         return -1;
>  >     }
>  >
>  >     subnfa =3D (struct nfattr *)(((char *)nfa) + NFA_ALIGN( nfa->n=
fa_len));
>  >
>  > .....
>  > }
>  >
>  > Please kindly correct me if I made a mistake.
>
>
>  Indeed, that function is completely broken but it does not have any
>  known client.
Yes, I see, I didn't find a client using this function.

>  It seems a leftover of the days when we didn't have anything better =
to
>  nest attributes, so that it's completely useless these days. I have
>  fixed in SVN anyway. Patch attached.
thanks for your patch,  people will be confused with the original code

>
>  --
>  "Los honestos son inadaptados sociales" -- Les Luthiers
>
> Index: configure.in
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  --- configure.in        (revisi=F3n: 7400)
>  +++ configure.in        (copia de trabajo)
>  @@ -4,7 +4,7 @@
>
>   AC_CANONICAL_SYSTEM
>
>  -AM_INIT_AUTOMAKE(libnfnetlink, 0.0.33)
>  +AM_INIT_AUTOMAKE(libnfnetlink, 0.0.34)
>
>   AC_PROG_CC
>   AC_EXEEXT
>  Index: src/libnfnetlink.c
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  --- src/libnfnetlink.c  (revisi=F3n: 7400)
>  +++ src/libnfnetlink.c  (copia de trabajo)
>  @@ -799,16 +799,16 @@
>         assert(maxlen > 0);
>         assert(type >=3D 0);
>
>  -       if ((NFA_OK(nfa, nfa->nfa_len) + len) > maxlen) {
>  +       if (NFA_ALIGN(nfa->nfa_len) + len > maxlen) {
>                 errno =3D ENOSPC;
>                 return -1;
>         }
>
>  -       subnfa =3D (struct nfattr *)(((char *)nfa) + NFA_OK(nfa, nfa=
->nfa_len));
>  +       subnfa =3D (struct nfattr *)(((char *)nfa) + NFA_ALIGN(nfa->=
nfa_len));
>         subnfa->nfa_type =3D type;
>         subnfa->nfa_len =3D len;
>         memcpy(NFA_DATA(subnfa), data, alen);
>  -       nfa->nfa_len =3D (NLMSG_ALIGN(nfa->nfa_len) + len);
>  +       nfa->nfa_len =3D NFA_ALIGN(nfa->nfa_len) + len;
>
>         return 0;
>   }
>
>



--=20
Thanks,
Rick
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
