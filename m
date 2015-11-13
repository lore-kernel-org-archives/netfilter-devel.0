From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [conntrackd PATCH v3] conntrackd: add systemd support
Date: Fri, 13 Nov 2015 12:39:22 +0100
Message-ID: <CAOkSjBim_sssQko+JedaZaa1w=SPVhYKBPvFKW7hGmCFFKXw5A@mail.gmail.com>
References: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34362 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481AbbKMLjn convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2015 06:39:43 -0500
Received: by wmvv187 with SMTP id v187so77108575wmv.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2015 03:39:41 -0800 (PST)
In-Reply-To: <144741224967.19762.12430502552848102506.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 November 2015 at 11:59, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> diff --git a/doc/stats/conntrackd.conf b/doc/stats/conntrackd.conf
> index 16d7a80..b1cca07 100644
> --- a/doc/stats/conntrackd.conf
> +++ b/doc/stats/conntrackd.conf
> @@ -3,6 +3,14 @@
>  #
>  General {
>         #
> +       # Enable systemd support. If conntrackd is compiled with the =
proper
> +       # configuration, you can use a systemd service unit of Type=3D=
notify
> +       # and use conntrackd with systemd watchdog as well.
> +       # Default is: on
> +       #
> +       #Systemd off
> +
> +       #
>         # Set the nice value of the daemon. This value goes from -20
>         # (most favorable scheduling) to 19 (least favorable). Using =
a
>         # negative value reduces the chances to lose state-change eve=
nts.

Perhaps it makes sense to factorize all of the conntrackd
configuration examples in a single man page, let's say
'conntrackd.conf(5)'.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
