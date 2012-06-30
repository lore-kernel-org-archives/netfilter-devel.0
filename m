From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] netfilter: nf_ct_tcp: missing per-net support for
 cttimeout
Date: Sat, 30 Jun 2012 20:32:37 +0800
Message-ID: <4FEEF1E5.7030102@cn.fujitsu.com>
References: <1340983405-32118-1-git-send-email-pablo@netfilter.org> <1340983405-32118-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55065 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab2F3McN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jun 2012 08:32:13 -0400
In-Reply-To: <1340983405-32118-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B406=E6=9C=8829=E6=97=A5 23:23, pablo@netfilter.or=
g =E5=86=99=E9=81=93:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> This patch adds missing per-net support for the cttimeout
> infrastructure to TCP.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_proto_tcp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Sorry,actually I missed it,thanks!

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

>=20
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/n=
f_conntrack_proto_tcp.c
> index 07e56ea..a5ac11e 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -821,7 +821,7 @@ static int tcp_error(struct net *net, struct nf_c=
onn *tmpl,
> =20
>  static unsigned int *tcp_get_timeouts(struct net *net)
>  {
> -	return tcp_timeouts;
> +	return tcp_pernet(net)->timeouts;
>  }
> =20
>  /* Returns verdict for packet, or -1 for invalid. */

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
