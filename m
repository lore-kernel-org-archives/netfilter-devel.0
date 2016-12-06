From: Anatole Denis <anatole@rezel.net>
Subject: Re: [PATCH nft] src: add support to flush sets
Date: Tue, 06 Dec 2016 12:13:37 +0100
Message-ID: <1481022817.2725.1@smtp.rezel.net>
References: <1480977425-15015-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:49854 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752214AbcLFLbZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 06:31:25 -0500
In-Reply-To: <1480977425-15015-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On lun., d=C3=A9c. 5, 2016 at 11:37 , Pablo Neira Ayuso=20
<pablo@netfilter.org> wrote:
> You can use this new command to remove all existing elements in a set:
>=20
>  # nft flush set filter xyz
>=20
> After this command, the set 'xyz' in table 'filter' becomes empty.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/netlink.h | 2 ++
>  src/evaluate.c    | 3 +++
>  src/netlink.c     | 9 ++++++++-
>  src/rule.c        | 3 +++
>  4 files changed, 16 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/netlink.h b/include/netlink.h
> index 28c11f603ed2..363b5251968f 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -165,6 +165,8 @@ extern int netlink_delete_setelems(struct=20
> netlink_ctx *ctx, const struct handle
>  				   const struct expr *expr);
>  extern int netlink_get_setelems(struct netlink_ctx *ctx, const=20
> struct handle *h,
>  				const struct location *loc, struct set *set);
> +extern int netlink_flush_setelems(struct netlink_ctx *ctx, const=20
> struct handle *h,
> +				  const struct location *loc);
>=20
>  extern void netlink_dump_table(const struct nftnl_table *nlt);
>  extern void netlink_dump_chain(const struct nftnl_chain *nlc);
> diff --git a/src/evaluate.c b/src/evaluate.c
> index e11a455a5f53..8a3da54e5b2d 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -2857,9 +2857,11 @@ static int cmd_evaluate_list(struct eval_ctx=20
> *ctx, struct cmd *cmd)
>  static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
>  {
>  	int ret;
> +
>  	ret =3D cache_update(cmd->op, ctx->msgs);
>  	if (ret < 0)
>  		return ret;
> +
>  	switch (cmd->obj) {
>  	case CMD_OBJ_RULESET:
>  		cache_flush();
> @@ -2870,6 +2872,7 @@ static int cmd_evaluate_flush(struct eval_ctx=20
> *ctx, struct cmd *cmd)
>  		 */
>  	case CMD_OBJ_CHAIN:
>  		/* Chains don't hold sets */
> +	case CMD_OBJ_SET:
>  		break;

I think you need to empty the cache for said set here, otherwise this=20
will lead to the same errors we had earlier with flush ruleset not=20
emptying the set cache.

Example test which fails:
Running
```
table t{
  set s { type ipv4_addr; flags interval
    elements=3D{127.0.0.1/8}
  }
}
```
then:
```
flush set t s
add element t s {
  127.0.0.1/8,
}
```
errors out with:
Error: interval overlaps with an existing one
  127.0.0.1/8,
  ^^^^^^^^^^^

[...]

Maybe a question for another patch but: if there is support for=20
emptying specific sets, maybe flushing a table should empty sets in the=20
table as well as the chains ? (currently it only empties the chains and=20
leaves the sets intact, which is kind of unintuitive)


=

