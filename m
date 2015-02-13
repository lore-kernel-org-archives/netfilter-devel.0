From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [libnftnl PATCH v2] ruleset: fix a leak when we use the set lists
Date: Fri, 13 Feb 2015 17:04:09 +0100
Message-ID: <54DE2079.6010901@gmail.com>
References: <1423689142-6300-1-git-send-email-alvaroneay@gmail.com> <1423689142-6300-2-git-send-email-alvaroneay@gmail.com> <20150213155728.GA6287@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:64534 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbbBMQD7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2015 11:03:59 -0500
Received: by mail-we0-f169.google.com with SMTP id k48so17524147wev.0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2015 08:03:58 -0800 (PST)
In-Reply-To: <20150213155728.GA6287@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 13/02/15 a las 16:57, Pablo Neira Ayuso escribi=F3:
> On Wed, Feb 11, 2015 at 10:12:22PM +0100, Alvaro Neira Ayuso wrote:
>> =3D=3D18632=3D=3D 285 (16 direct, 269 indirect) bytes in 1 blocks ar=
e definitely lost in
>> loss record 6 of 6
>> =3D=3D18632=3D=3D    at 0x4C272B8: calloc (vg_replace_malloc.c:566)
>> =3D=3D18632=3D=3D    by 0x5043822: nft_set_list_alloc (set.c:977)
>> =3D=3D18632=3D=3D    by 0x5045483: nft_ruleset_json_parse (ruleset.c=
:442)
>> =3D=3D18632=3D=3D    by 0x50458BE: nft_ruleset_do_parse (ruleset.c:6=
96)
>> =3D=3D18632=3D=3D    by 0x408AEC: do_command (rule.c:1317)
>> =3D=3D18632=3D=3D    by 0x406B05: nft_run (main.c:194)
>> =3D=3D18632=3D=3D    by 0x40667C: main (main.c:360)
>
> Also applied. I found more leaks, just pushed a patch to fix them
>

I have already seen the changes. Sorry and thanks Pablo to fix them.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
