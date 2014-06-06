From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_queue PATCH 2/2] utils: add the parameter queue
 number in nfqnl_test
Date: Fri, 6 Jun 2014 12:03:32 +0200
Message-ID: <20140606100332.GA6081@localhost>
References: <1402048683-12587-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40114 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaFFKDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:03:37 -0400
Content-Disposition: inline
In-Reply-To: <1402048683-12587-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 06, 2014 at 11:58:03AM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> This patch allows to stablish the number of the queue that
> we want to read the packets.
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  utils/nfqnl_test.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/utils/nfqnl_test.c b/utils/nfqnl_test.c
> index 4decd50..8272fa1 100644
> --- a/utils/nfqnl_test.c
> +++ b/utils/nfqnl_test.c
> @@ -85,8 +85,18 @@ int main(int argc, char **argv)
>  	struct nfq_q_handle *qh;
>  	int fd;
>  	int rv;
> +	int queue =3D 0;

This signed, change it to unsigned.

>  	char buf[4096] __attribute__ ((aligned));
> =20
> +	if (argc =3D=3D 2) {
> +		queue =3D atoi(argv[1]);
> +		if (queue > 65535) {
> +			fprintf(stderr, "queue number is bigger than 65535\n");

I'd suggest something like.

                                        Usage: %s [<0-65535>]

> +			exit(1);

Please, use exit(EXIT_FAILURE);

> +		}
> +	}
> +
>  	printf("opening library handle\n");
>  	h =3D nfq_open();
>  	if (!h) {
> @@ -106,8 +116,8 @@ int main(int argc, char **argv)
>  		exit(1);
>  	}
> =20
> -	printf("binding this socket to queue '0'\n");
> -	qh =3D nfq_create_queue(h,  0, &cb, NULL);
> +	printf("binding this socket to queue '%d'\n", queue);
> +	qh =3D nfq_create_queue(h,  queue, &cb, NULL);
>  	if (!qh) {
>  		fprintf(stderr, "error during nfq_create_queue()\n");
>  		exit(1);
> --=20
> 1.7.10.4
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
