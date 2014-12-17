From: "=?utf-8?B?SsO2cmcgVGhhbGhlaW0=?=" <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 20:57:02 +0000
Message-ID: <b3a6e72b6713574b986ab81624dddeda@mail.higgsboson.tk>
References: <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>
 <20141217205407.06558f65@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Netfilter Development Mailing list"
	<netfilter-devel@vger.kernel.org>
To: "Arturo Borrero Gonzalez" <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:34178 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQU5E convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:57:04 -0500
In-Reply-To: <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

17. Dezember 2014 21:37 Uhr, "Arturo Borrero Gonzalez" <arturo.borrero.=
glez@gmail.com> schrieb:=20
> On 17 December 2014 at 20:54, J=C3=B6rg Thalheim <joerg@higgsboson.tk=
> wrote:
>=20
>> Signed-off-by: J=C3=B6rg Thalheim <joerg@higgsboson.tk>
>> ---
>> .gitignore                |   2 +
>> configure.ac              |  35 +++++++++++++
>> files/Makefile.am         |   7 +++
>> files/nftables.service.in |  12 +++++
>> files/nftablesctl.in      | 129 ++++++++++++++++++++++++++++++++++++=
++++++++++
>> 5 files changed, 185 insertions(+)
>> create mode 100644 files/nftables.service.in
>> create mode 100755 files/nftablesctl.in
>=20
> Thanks for your work :-)
>=20
> IMHO, this belongs to distributors, don't you?

this was in the old sysvinit world. Thesedays it is common for upstream=
 projects to come along with service files, as=20
they are more portable then shell scripts.

>=20
> Anyway, some inlined comments.
>=20
>> +nftables_start() {
>> +       find /etc/nftables -maxdepth 1 -type f -name '*.rules' -prin=
t0 | \
>> +               sort -z | xargs --null --no-run-if-empty --max-args=3D=
1 @sbindir@nft -f
>> +
>=20
> You are making lot of assumptions, for example the '.rules' suffix.
>=20
>> +       if [ -t 0 ] && [ "$1" =3D "--confirm" ]
>> +       then
>> +               echo "Please confirm that your network connection is=
 working and press Ctrl+C on
>> success"
>> +               trap ctrl_c INT
>> +
>> +               sleep 20
>> +
>> +               echo "No response, flushing rules"
>> +               nftables_stop
>> +       fi
>> +}
>> +
>> +nftables_list() {
>=20
> Now (see latest v0.4 release) this is simply `nft list ruleset'.
>=20
>> +       for P in ip inet ip6 arp bridge
>> +       do
>> +               nft_list_protocol "$P"
>> +       done
>> +}
>> +
>> +nftables_stop() {
>=20
> Now this is simply `nft flush ruleset'.

Ok. I did not have a look at latest release, when the script was writte=
n a year before, this was not possible.

>=20
>> +       for P in ip inet ip6 arp bridge
>> +       do
>> +               nft_clear_protocol "$P"
>> +       done
>> +}
>> +
>> +nftables_restart() {
>> +       nftables_stop
>> +       nftables_start "$1"
>=20
> Here, I think the time between the stop and start, there is not
> ruleset in the kernel.
> I guess we can do it better, flushing the old ruleset and loading the
> new one in a single,atomic step.

Is this possible with nft? If so, how?

>=20
> --=20
> Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
