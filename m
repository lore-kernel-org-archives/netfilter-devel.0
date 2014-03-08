From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/3] example: fix the example for deleting rules
Date: Sat, 8 Mar 2014 15:17:45 +0100
Message-ID: <20140308141742.GB7854@localhost>
References: <20140308140039.13220.89013.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44156 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaCHORu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:17:50 -0500
Content-Disposition: inline
In-Reply-To: <20140308140039.13220.89013.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 08, 2014 at 03:00:39PM +0100, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Fixed the example for deleting rules. Before this patch,
> the program tried to delete the rule without using
> the correct header
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  examples/nft-rule-del.c |   43 +++++++++++++++++++++++++++++++++++++=
++----
>  1 file changed, 39 insertions(+), 4 deletions(-)
>=20
> diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
> index 6f665b0..06a28c7 100644
> --- a/examples/nft-rule-del.c
> +++ b/examples/nft-rule-del.c
> @@ -17,15 +17,33 @@
> =20
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
> +#include <linux/netfilter/nfnetlink.h>
> =20
>  #include <libmnl/libmnl.h>
>  #include <libnftnl/rule.h>
> =20
> +static void nft_mnl_batch_put(char *buf, uint16_t type, uint32_t seq=
)
> +{
> +	struct nlmsghdr *nlh;
> +	struct nfgenmsg *nfg;
> +
> +	nlh =3D mnl_nlmsg_put_header(buf);
> +	nlh->nlmsg_type =3D type;
> +	nlh->nlmsg_flags =3D NLM_F_REQUEST;
> +	nlh->nlmsg_seq =3D seq;
> +
> +	nfg =3D mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> +	nfg->nfgen_family =3D AF_INET;
> +	nfg->version =3D NFNETLINK_V0;
> +	nfg->res_id =3D NFNL_SUBSYS_NFTABLES;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	struct mnl_socket *nl;
>  	char buf[MNL_SOCKET_BUFFER_SIZE];
>  	struct nlmsghdr *nlh;
> +	struct mnl_nlmsg_batch *batch;
>  	uint32_t portid, seq;
>  	struct nft_rule *r =3D NULL;
>  	int ret, family;
> @@ -56,8 +74,6 @@ int main(int argc, char *argv[])
>  	}
> =20
>  	seq =3D time(NULL);
> -	nlh =3D nft_rule_nlmsg_build_hdr(buf, NFT_MSG_DELRULE, family,
> -					NLM_F_ACK, seq);
>  	nft_rule_attr_set(r, NFT_RULE_ATTR_TABLE, argv[2]);
>  	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, argv[3]);
> =20
> @@ -69,8 +85,24 @@ int main(int argc, char *argv[])
>  	nft_rule_snprintf(tmp, sizeof(tmp), r, 0, 0);
>  	printf("%s\n", tmp);
> =20
> +	batch =3D mnl_nlmsg_batch_start(buf, sizeof(buf));
> +
> +	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch),
> +			  NFNL_MSG_BATCH_BEGIN, seq++);
> +	mnl_nlmsg_batch_next(batch);
> +
> +	nlh =3D nft_rule_nlmsg_build_hdr(mnl_nlmsg_batch_current(batch),
> +				NFT_MSG_DELRULE,
> +				family,
> +				NLM_F_ACK, seq++);
> +
>  	nft_rule_nlmsg_build_payload(nlh, r);
>  	nft_rule_free(r);
> +	mnl_nlmsg_batch_next(batch);
> +
> +	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_EN=
D,
> +	seq++);

Wrong coding style, this has to be:

	nft_mnl_batch_put(mnl_nlmsg_batch_current(batch), NFNL_MSG_BATCH_END,
                          seq++);

> +	mnl_nlmsg_batch_next(batch);
> =20
>  	nl =3D mnl_socket_open(NETLINK_NETFILTER);
>  	if (nl =3D=3D NULL) {
> @@ -84,14 +116,17 @@ int main(int argc, char *argv[])
>  	}
>  	portid =3D mnl_socket_get_portid(nl);
> =20
> -	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> +	if (mnl_socket_sendto(nl, mnl_nlmsg_batch_head(batch),
> +			      mnl_nlmsg_batch_size(batch)) < 0) {
>  		perror("mnl_socket_send");
>  		exit(EXIT_FAILURE);
>  	}
> =20
> +	mnl_nlmsg_batch_stop(batch);
> +
>  	ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
>  	while (ret > 0) {
> -		ret =3D mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
> +		ret =3D mnl_cb_run(buf, ret, 0, portid, NULL, NULL);
>  		if (ret <=3D 0)
>  			break;
>  		ret =3D mnl_socket_recvfrom(nl, buf, sizeof(buf));
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
