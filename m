From: Anatole Denis <anatole@rezel.net>
Subject: Re: [PATCH nft] evaluate: Remove cache_update() in
 cmd_evaluate_flush()
Date: Thu, 05 Jan 2017 21:32:11 +0100
Message-ID: <1483648331.11168.0@smtp.rezel.net>
References: <20170105183842.GA19565@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:32834 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033181AbdAEUcm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 15:32:42 -0500
In-Reply-To: <20170105183842.GA19565@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeu. 5 janv. 2017 =C3=A0 19:38, Elise Lennion <elise.lennion@gmail.com>=20
a =C3=A9crit :
> cache_update() fetches set elements, when the set is big and sorted
> this leads to an unnecessary delay on 'nft flush ruleset'.
>=20
> There is only a possible call to cache_flush() after the update, so
> this update isn't needed.

That is right. However this function as-is is still incomplete, it=20
needs support for flushing sets, for which we will need this=20
cache_update(). It could still be removed now and reintroduced later=20
though, or only applied when really needed.

I also just realized that even CMD_OBJECT_RULESET isn't safe, as it can=20
take an optional family parameter, which we completely ignore right=20
now. Fixing that would change the cache more selectively than flushing=20
everything, thus requires the cache_update().

I would say, if the performance of nft commands is important, the cache=20
mechanism would need a refactor to allow lazy-loading pieces of the=20
ruleset from the kernel when needed. In its current form you need to=20
load the full cache for any nontrivial operation on the cache, with the=20
delay you mention.

>=20
>=20
> Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
> ---
>  src/evaluate.c | 6 ------
>  1 file changed, 6 deletions(-)
>=20
> diff --git a/src/evaluate.c b/src/evaluate.c
> index cebc5a9..a506f9a 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2951,12 +2951,6 @@ static int cmd_evaluate_list(struct eval_ctx=20
> *ctx, struct cmd *cmd)
>=20
>  static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
>  {
> -	int ret;
> -
> -	ret =3D cache_update(cmd->op, ctx->msgs);
> -	if (ret < 0)
> -		return ret;
> -

You still need to set cache_initialized =3D true in some way (and=20
possibly initialize table_list, I don't remember how it is declared)=20
else you would be basically reverting cmd_evaluate_flush to a no-op and=20
reintroducing the cache (in)coherency bugs, without even reducing the=20
delay for batched commands which will reinitialize the cache on the=20
next command.


>=20
>  	switch (cmd->obj) {
>  	case CMD_OBJ_RULESET:
>  		cache_flush();
> --
> 2.7.4
>=20
=

