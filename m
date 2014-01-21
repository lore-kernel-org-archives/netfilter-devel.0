From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 12:37:52 +0100
Message-ID: <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
References: <20140121110645.GC25197@macbook.localnet> <20140121112700.GA21772@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:49193 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaAULiO convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:38:14 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so4140136lbv.24
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 03:38:12 -0800 (PST)
In-Reply-To: <20140121112700.GA21772@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 January 2014 12:27, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Tue, Jan 21, 2014 at 11:06:46AM +0000, Patrick McHardy wrote:
>> We currently only support "add table" and "add chain" with NLM_F_EXC=
L.
>> This means we can't replace entire tables without a lot of extra eff=
ort,
>> also its not possible to create tables/chains just in case they don'=
t
>> already exist.
>>
>> To fix this, I'd propose to add two new commands, so we have the fol=
lowing:
>>
>> - add: add without NLM_F_EXCL
>> - create: add with NLM_F_EXCL
>> - replace: replace the entire thing
>
> I guess you have in mind to simplify current reloading via nft -f.
> Currently, we have to manually flush and delete chain/tables at this
> moment, which is a bit of PITA.
>

I have some old patches to allow operate over the entire ruleset:
 list ruleset
 flush ruleset
 delete ruleset
 wipe ruleset

I think they are handy for these situations.

Think about a 'ruleset.nft' file starting like this:
=3D=3D=3D=3D 8< =3D=3D=3D=3D
wipe ruleset
table ip filter {
[...]
}
table ip6 filter {
[...]
}
=3D=3D=3D=3D 8< =3D=3D=3D=3D

Then, the load via `nft -f' could be straightforward.
Let me know if you want me to reboot them and resend.

regards

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
