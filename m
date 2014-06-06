From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue PATCH v2] utils: add the parameter queue
 number in nfqnl_test
Date: Fri, 6 Jun 2014 12:44:58 +0200
Message-ID: <20140606104458.GA3517@localhost>
References: <1402048683-12587-1-git-send-email-alvaroneay@gmail.com>
 <1402050005-14844-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52101 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFFKpL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:45:11 -0400
Content-Disposition: inline
In-Reply-To: <1402050005-14844-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 06, 2014 at 12:20:05PM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> This patch allows to stablish the number of the queue that
> we want to read the packets.
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [changes in v2]
> * I have changed the variable queue to unsigned
> * I have changed the message in case that queue > 65535 and also I ha=
ve used
>   exit(EXIT_FAILURE) in error case.
>=20
>  utils/nfqnl_test.c |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>=20
> diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
> index 4decd50..557db1d 100644
> --- a/utils/nfqnl_test.c
> +++ b/utils/nfqnl_test.c
> @@ -85,8 +85,17 @@ int main(int argc, char **argv)
>  	struct nfq_q_handle *qh;
>  	int fd;
>  	int rv;
> +	uint32_t queue =3D 0;
>  	char buf[4096] __attribute__ ((aligned));
> =20
> +	if (argc =3D=3D 2) {
> +		queue =3D atoi(argv[1]);
> +		if (queue > 65535) {
> +			fprintf(stderr, "Usage: %s [<0-65535>]\n", argv[1]);
                                                                   ^^^^=
^^^

You did *not* test the error path, this is argv[0].
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
