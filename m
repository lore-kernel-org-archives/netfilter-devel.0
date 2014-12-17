From: "=?utf-8?B?SsO2cmcgVGhhbGhlaW0=?=" <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:36:02 +0000
Message-ID: <0aacef05524146946330ec41e2235318@mail.higgsboson.tk>
References: <CAOkSjBi_X40RrdHDpNNsdbSp-=3okki21s=wkK3J+BsD97Jpqg@mail.gmail.com>
 <20141217205407.06558f65@turingmachine>
 <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>
 <b3a6e72b6713574b986ab81624dddeda@mail.higgsboson.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Netfilter Development Mailing list"
	<netfilter-devel@vger.kernel.org>
To: "Arturo Borrero Gonzalez" <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:36682 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaLQVgH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:36:07 -0500
In-Reply-To: <CAOkSjBi_X40RrdHDpNNsdbSp-=3okki21s=wkK3J+BsD97Jpqg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

17. Dezember 2014 22:11 Uhr, "Arturo Borrero Gonzalez" <arturo.borrero.=
glez@gmail.com> schrieb:=20
> On 17 December 2014 at 21:57, J=C3=B6rg Thalheim <joerg@higgsboson.tk=
> wrote:
>=20
>>>> +nftables_restart() {
>>>> +       nftables_stop
>>>> +       nftables_start "$1"
>>>=20
>>> Here, I think the time between the stop and start, there is not
>>> ruleset in the kernel.
>>> I guess we can do it better, flushing the old ruleset and loading t=
he
>>> new one in a single,atomic step.
>>=20
>> Is this possible with nft? If so, how?
>=20
> add a heading 'flush ruleset' to the file to be loaded.
>=20
> Also, to load multiple files you can use "include" statements, and
> still be atomic B-)

Is the "include" statement a new feature? Never saw this feature in the=
 wild.
Does it works for directories too? Something like `include "/etc/nftabl=
es.d/*"`=20
or `includedir "/etc/nftables/"` would be awesome.

>=20
> --=20
> Arturo Borrero Gonz=C3=A1lez
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
