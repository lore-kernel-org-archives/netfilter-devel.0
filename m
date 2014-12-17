From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:37:06 +0100
Message-ID: <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>
References: <20141217205407.06558f65@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57998 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaLQUh2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:37:28 -0500
Received: by mail-lb0-f171.google.com with SMTP id w7so9219498lbi.30
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2014 12:37:27 -0800 (PST)
In-Reply-To: <20141217205407.06558f65@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 December 2014 at 20:54, J=C3=B6rg Thalheim <joerg@higgsboson.tk> =
wrote:
> Signed-off-by: J=C3=B6rg Thalheim <joerg@higgsboson.tk>
> ---
>  .gitignore                |   2 +
>  configure.ac              |  35 +++++++++++++
>  files/Makefile.am         |   7 +++
>  files/nftables.service.in |  12 +++++
>  files/nftablesctl.in      | 129 ++++++++++++++++++++++++++++++++++++=
++++++++++
>  5 files changed, 185 insertions(+)
>  create mode 100644 files/nftables.service.in
>  create mode 100755 files/nftablesctl.in
>

Thanks for your work :-)

IMHO, this belongs to distributors, don't you?

Anyway, some inlined comments.


> +nftables_start() {
> +       find /etc/nftables -maxdepth 1 -type f -name '*.rules' -print=
0 | \
> +               sort -z | xargs --null --no-run-if-empty --max-args=3D=
1 @sbindir@nft -f
> +

You are making lot of assumptions, for example the '.rules' suffix.

> +       if [ -t 0 ] && [ "$1" =3D "--confirm" ]
> +       then
> +               echo "Please confirm that your network connection is =
working and press Ctrl+C on success"
> +               trap ctrl_c INT
> +
> +               sleep 20
> +
> +               echo "No response, flushing rules"
> +               nftables_stop
> +       fi
> +}
> +
> +nftables_list() {

Now (see latest v0.4 release) this is simply `nft list ruleset'.

> +       for P in ip inet ip6 arp bridge
> +       do
> +               nft_list_protocol "$P"
> +       done
> +}
> +
> +nftables_stop() {

Now this is simply `nft flush ruleset'.

> +       for P in ip inet ip6 arp bridge
> +       do
> +               nft_clear_protocol "$P"
> +       done
> +}
> +
> +nftables_restart() {
> +       nftables_stop
> +       nftables_start "$1"

Here, I think the time between the stop and start, there is not
ruleset in the kernel.
I guess we can do it better, flushing the old ruleset and loading the
new one in a single,atomic step.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
