From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:50:27 +0100
Message-ID: <CAOkSjBhmMpTYP2j6vf6Gs4OGfds975rq-4ZuKDCw1bxqfKLULg@mail.gmail.com>
References: <20141217205407.06558f65@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: =?UTF-8?Q?J=C3=B6rg_Thalheim?= <joerg@higgsboson.tk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:64018 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLQUut convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:50:49 -0500
Received: by mail-la0-f41.google.com with SMTP id hv19so13694392lab.14
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2014 12:50:47 -0800 (PST)
In-Reply-To: <20141217205407.06558f65@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 December 2014 at 20:54, J=C3=B6rg Thalheim <joerg@higgsboson.tk> =
wrote:
> +
> +nftables_start() {
> +       find /etc/nftables -maxdepth 1 -type f -name '*.rules' -print=
0 | \
> +               sort -z | xargs --null --no-run-if-empty --max-args=3D=
1 @sbindir@nft -f
> +
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

Also, it would be nice to rollback to the old ruleset rather than
leaving the machine without firewall (think on mission critical
firewalls, where human mistakes happens after all)

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
