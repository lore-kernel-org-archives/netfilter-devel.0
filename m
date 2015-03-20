From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v2] add systemd service file
Date: Fri, 20 Mar 2015 11:25:42 +0100
Message-ID: <CAOkSjBhEa2cZxRreZhSLyxyH7YPv_SWFwvkr=pjYvZXXY-tLWA@mail.gmail.com>
References: <20150320105320.58266b67@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33117 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbCTK0E convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2015 06:26:04 -0400
Received: by lbbrr9 with SMTP id rr9so7484811lbb.0
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2015 03:26:02 -0700 (PDT)
In-Reply-To: <20150320105320.58266b67@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 March 2015 at 10:53, J=C3=B6rg Thalheim <joerg@higgsboson.tk> wro=
te:
> The last PATCH was rejected, because it has added an integration scri=
pt.
> This PATCH however only adds a service file, with no other dependency=
 but the
> userpace nft program.
>

Again, my opinion is: this belongs to distributions.

> my motivation was the following:
>
> - Providing a service file upstream hopefully lead to consistent beha=
viour across distributions
> - The people, who know how to deal with nft, are usually the upstream=
 developer itself
> - The provided service should be reusable without any modification in=
 any distribution
>   and should preserve maintainers from reinventing the wheel all the =
time
>   (debian currently does not provide atomic reloading in sid for exam=
ple;
>   archlinux does, but it doesn't set ProtectSystem and ProtectHome)
>

It turns out that the debian package do reload the ruleset atomically.
We can further discuss the debian stuff in other place though.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
