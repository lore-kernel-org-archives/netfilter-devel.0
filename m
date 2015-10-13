From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH] chain: fix segfault in 'device' XML parsing
Date: Tue, 13 Oct 2015 11:40:00 +0200
Message-ID: <CAOkSjBgm5Qqxrbb60NDRrkZuUA+vmNRP=tXWbRgDmnUR3_1Eug@mail.gmail.com>
References: <20151013073910.19469.65757.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37421 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbbJMJkV convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2015 05:40:21 -0400
Received: by wijq8 with SMTP id q8so22837362wij.0
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2015 02:40:20 -0700 (PDT)
In-Reply-To: <20151013073910.19469.65757.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 October 2015 at 09:39, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> Reported by valgrind:
> [...]
> =3D=3D14065=3D=3D Process terminating with default action of signal 1=
1 (SIGSEGV)
> =3D=3D14065=3D=3D  Access not within mapped region at address 0x0
> =3D=3D14065=3D=3D    at 0x4C2C022: strlen (vg_replace_strmem.c:454)
> =3D=3D14065=3D=3D    by 0x4E41A93: nftnl_chain_set_str (chain.c:259)
> =3D=3D14065=3D=3D    by 0x4E427F7: nftnl_mxml_chain_parse (chain.c:77=
0)
> =3D=3D14065=3D=3D    by 0x4E48F96: nftnl_ruleset_parse_chains (rulese=
t.c:314)
> =3D=3D14065=3D=3D    by 0x4E4959A: nftnl_ruleset_xml_parse_ruleset (r=
uleset.c:625)
> =3D=3D14065=3D=3D    by 0x4E4959A: nftnl_ruleset_xml_parse_cmd (rules=
et.c:668)
> =3D=3D14065=3D=3D    by 0x4E4959A: nftnl_ruleset_xml_parse (ruleset.c=
:706)
> =3D=3D14065=3D=3D    by 0x4E4959A: nftnl_ruleset_do_parse (ruleset.c:=
734)
> =3D=3D14065=3D=3D    by 0x4013C9: test_xml (nft-parsing-test.c:166)
> =3D=3D14065=3D=3D    by 0x4016F4: execute_test (nft-parsing-test.c:21=
4)
> =3D=3D14065=3D=3D    by 0x400EBA: main (nft-parsing-test.c:330)
> [...]
>
> While at it, fix a bit the coding style.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
>  src/chain.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>

BTW this was reported by the Debian CI system [0].

[0] http://ci.debian.net/packages/libn/libnftnl/unstable/amd64/
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
