From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/5] audit: export symbol for use with xt_AUDIT
Date: Tue, 18 Jan 2011 16:45:45 +0100
Message-ID: <1295365545.3290.1.camel@edumazet-laptop>
References: <1295363820-14881-1-git-send-email-jengelh@medozas.de>
	 <1295363820-14881-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50225 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1ARPpu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:45:50 -0500
Received: by wyb28 with SMTP id 28so6258781wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jan 2011 07:45:49 -0800 (PST)
In-Reply-To: <1295363820-14881-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 18 janvier 2011 =C3=A0 16:16 +0100, Jan Engelhardt a =C3=A9cri=
t :
> When xt_AUDIT is built as a module, modpost reports a problem.
>=20
> 	MODPOST 322 modules
> 	ERROR: "audit_enabled" [net/netfilter/x_tables.ko] undefined!
> 	WARNING: modpost: Found 1 section mismatch(es).
>=20
> Cc: Thomas Graf <tgraf@redhat.com>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  kernel/audit.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 77770a0..5842f65 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -74,6 +74,8 @@ static int	audit_initialized;
>  int		audit_enabled;
>  int		audit_ever_enabled;
> =20
> +EXPORT_SYMBOL_GPL(audit_enabled);
> +
>  /* Default state when kernel boots without any parameters. */
>  static int	audit_default;
> =20

minor nit : EXPORT_SYMBOL_GPL() should immediately follow the symbol

int		audit_enabled;
EXPORT_SYMBOL_GPL(audit_enabled);



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
