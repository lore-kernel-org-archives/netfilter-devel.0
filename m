From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] xt_AUDIT.c: remove ipv6 dependencies
Date: Sun, 22 May 2011 11:43:04 +0200
Message-ID: <1306057384.12435.5.camel@edumazet-laptop>
References: <4DD83EB4.5040800@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Patrick McHardy <kaber@trash.net>,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57464 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1EVJnJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 May 2011 05:43:09 -0400
Received: by wwa36 with SMTP id 36so5278937wwa.1
        for <netfilter-devel@vger.kernel.org>; Sun, 22 May 2011 02:43:08 -0700 (PDT)
In-Reply-To: <4DD83EB4.5040800@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le samedi 21 mai 2011 =C3=A0 23:37 +0100, Mr Dash Four a =C3=A9crit :
> All,
>=20
>=20
> This patch follows the one I submitted yesterday and removes the
> dependencies on ipv6 allowing the AUDIT target be compiled on systems
> where no ipv6 is implemented or running.
>=20
> Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
> ---
>  net/netfilter/xt_AUDIT.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index e823f18..5cea31e 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -23,14 +23,18 @@
>  #ifdef CONFIG_NF_CONNTRACK_SECMARK
>  #include <linux/security.h>
>  #endif
> +#ifdef CONFIG_IPV6
>  #include <net/ipv6.h>
> +#endif

Well, what happens if I want ipv6 as a module, and ipv6 support in
xt_AUDIT ?

Its not clear why you beliebe this patch is needed.

I have a kernel without IPV6, and xt_AUDIT compiles fine here, it even
loads properly.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
