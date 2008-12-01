From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] More secure SYSRQ for xtables-addons
Date: Mon, 1 Dec 2008 20:34:52 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812011952520.17726@fbirervta.pbzchgretzou.qr>
References: <492E926D.5020807@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54929 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYLATey (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:34:54 -0500
In-Reply-To: <492E926D.5020807@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-11-27 13:28, John Haxby wrote:

> Hello All,
>
> This is a patch to the SYSRQ xtables-addon that is, I believe, secure=
 enough to
> use in moderately untrustworthy environments.

=46inally - I wondered when someone will augment it with some crypto
magic=C2=A0:p

What I did not like with the original ipt_SYSRQ is that it used its
own copy of the SHA algorithm - while being well aware that
ipt_SYSRQ's root, if I remember correctly, dates to the time where
in-kernel crypto did not exist yet.

> Ideally the iptables rules for SYSRQ would include a minimum time
> between requests to avoid the worst effects of sysrq-request
> bombing, although I haven't mentioned that in the updated man page
> (mostly because I'm not sure how to do it).

-p udp --dport discard -m limit --limit 5/minute -j SYSRQ ...

> .IP
> -echo -n "password" >/sys/.../password
> +echo "password" >/sys/module/xt_SYSRQ/parameters/password
> .PP

I think we should not rely on \n being there. Checking for \0
should also catch the echo -n (or open from a perl/c program) case:

> +	for (i =3D 0; sysrq_password[i]; i++)
> +		if (sysrq_password[i] =3D=3D '\n')
		|| sysrq_password[i] =3D=3D '\0'

(assuming that echoing into string module parameters at least adds a \0=
)

> +	sg_init_table(sg, 2);
> +	sg_set_buf(&sg[0], data, n);
> +	strcpy(digest_password, sysrq_password);
> +	i =3D strlen(digest_password);
> +	sg_set_buf(&sg[1], digest_password, i);

Could we directly use sysrq_password instead of copying it
to digest_password first?

> +	for (i =3D 0; i < len && data[i] !=3D ','; i++) {
> +		printk(KERN_INFO KBUILD_MODNAME ": SysRq %c\n", data[i]);
> #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2, 6, 19)
> -	handle_sysrq(c, NULL);
> +		handle_sysrq(data[i], NULL);
> #else
> -	handle_sysrq(c, NULL, NULL);
> +		handle_sysrq(data[i], NULL, NULL);
> #endif
> +	}

I see you handle multiple sysrq requests in one packet. This should be=20
reflected in the manual/comments (e.g. <keys> instead of <key>).

Care to fix it up? This looks good :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
