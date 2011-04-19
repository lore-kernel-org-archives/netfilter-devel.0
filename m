From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] add xtables-multi{32,64} recognition
Date: Tue, 19 Apr 2011 09:18:33 +0200
Message-ID: <4DAD3749.1000208@trash.net>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com> <1303176233-14063-5-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33054 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1DSHSx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:18:53 -0400
In-Reply-To: <1303176233-14063-5-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.04.2011 03:23, Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> Signed-off-by: Maciej Zenczykowski <maze@google.com>
> ---
>  xtables-multi.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>=20
> diff --git a/xtables-multi.c b/xtables-multi.c
> index f8d56ce..7f98286 100644
> --- a/xtables-multi.c
> +++ b/xtables-multi.c
> @@ -14,20 +14,34 @@
>  static const struct subcommand multi_subcommands[] =3D {
>  #ifdef ENABLE_IPV4
>  	{"iptables",            iptables_main},
> +	{"iptables32",          iptables_main},
> +	{"iptables64",          iptables_main},

What is the purpose of this?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
