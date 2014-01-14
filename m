From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 0/3 nft] [RFC] more syntax changes
Date: Tue, 14 Jan 2014 12:47:22 +0100
Message-ID: <CAOkSjBhjveJALPSzj=Z=POp27UJ5A+styOK12pkKp233ipiiEQ@mail.gmail.com>
References: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51796 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaANLrn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:47:43 -0500
Received: by mail-lb0-f179.google.com with SMTP id p9so856186lbv.24
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Jan 2014 03:47:42 -0800 (PST)
In-Reply-To: <1389699030-6301-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14 January 2014 12:30, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> Hi,
>
> The following patchset contains more small syntax and evaluation chan=
ges
> aiming to improve the interaction user <-> tool via most common shell=
s:
>
> * iifname and oifname mask matching: very simple approach to allow ma=
tching
>   interface names via meta oifname and eth =3D=3D eth.
>
> * Rename typical binary operation so we don't need to escape them in
>   bash: '&' by 'and', '|' by 'or' and '!' by 'not'. They are just a
>   few character longers and the syntax still looks nice to me.

These are important! thanks!

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
