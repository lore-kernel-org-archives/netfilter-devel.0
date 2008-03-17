From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: Updated geoip patchlet for iptables 1.4.0 / 2.6.24.3
Date: Mon, 17 Mar 2008 07:39:11 -0400
Message-ID: <dd45289d0803170439n22df40a4l6370fa0865532374@mail.gmail.com>
References: <1205410278.16631.0.camel@localhost>
	 <Pine.LNX.4.64.0803131351230.14822@fbirervta.pbzchgretzou.qr>
	 <ae6a86ba0803130601o3bd10021o69effed74c6cc86c@mail.gmail.com>
	 <Pine.LNX.4.64.0803131410170.14822@fbirervta.pbzchgretzou.qr>
	 <ae6a86ba0803130643j7b5a83b1ub6141f60e0e4739a@mail.gmail.com>
	 <Pine.LNX.4.64.0803132150210.14822@fbirervta.pbzchgretzou.qr>
	 <dd45289d0803140002q6a77394dsd821df10b5c6261b@mail.gmail.com>
	 <dd45289d0803170430p44127db2y9cd631a4cb149618@mail.gmail.com>
	 <47DE57A6.5000103@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
	"Samuel Jean" <peejix@gmail.com>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>,
	acidfu@people.netfilter.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:50910 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYCQLjM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2008 07:39:12 -0400
Received: by wr-out-0506.google.com with SMTP id c48so3909031wra.1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Mar 2008 04:39:12 -0700 (PDT)
In-Reply-To: <47DE57A6.5000103@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

Its perfect, thank you.

Nick

On Mon, Mar 17, 2008 at 7:36 AM, Pablo Neira Ayuso <pablo@netfilter.org=
> wrote:
> NICOLAS BOULIANE wrote:
>  > Pablo,
>  >
>  > # geoip, maintained by Samuel Jean <jix@bugmachine.ca>
>  > http://people.netfilter.org/acidfu/patchlets/
>  >
>  > Could you add me as the new official maintainer please ?
>  > Nicolas Bouliane <acidfu@people.netfilter.org>
>
>  Is this patch enough?
>
>
>
>  --
>  "Los honestos son inadaptados sociales" -- Les Luthiers
>
> Index: sources.list
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  --- sources.list        (revisi=F3n: 7406)
>  +++ sources.list        (copia de trabajo)
>  @@ -1,7 +1,7 @@
>   # Add the URLs for external patchlets here
>   #
>
>  -# geoip, maintained by Samuel Jean <jix@bugmachine.ca>
>  +# geoip, maintained by Nicolas Bouliane <acidfu@people.netfilter.or=
g>
>   http://people.netfilter.org/acidfu/patchlets/
>
>   # condition, maintained by Massimiliano Hofer <max@nucleus.it>
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
