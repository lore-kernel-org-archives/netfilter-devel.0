From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] src: remove redundant cast near msg_name
Date: Thu, 06 Jan 2011 03:37:15 +0100
Message-ID: <4D252ADB.60906@netfilter.org>
References: <1293752411-12923-1-git-send-email-jengelh@medozas.de> <1293752411-12923-6-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43548 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab1AFChU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 21:37:20 -0500
In-Reply-To: <1293752411-12923-6-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31/12/10 00:40, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  src/libnfnetlink.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
> index fdd7d01..bf511f8 100644
> --- a/src/libnfnetlink.c
> +++ b/src/libnfnetlink.c
> @@ -416,7 +416,7 @@ nfnl_sendiov(const struct nfnl_handle *nfnlh, con=
st struct iovec *iov,
> =20
>  	assert(nfnlh);
> =20
> -	msg.msg_name =3D (struct sockaddr *) &nfnlh->peer;
> +	msg.msg_name =3D &nfnlh->peer;
>  	msg.msg_namelen =3D sizeof(nfnlh->peer);
>  	msg.msg_iov =3D (struct iovec *) iov;
>  	msg.msg_iovlen =3D num;

I hit this here:

libnfnetlink.c: In function =91nfnl_sendiov=92:
libnfnetlink.c:419: warning: assignment discards qualifiers from pointe=
r
target type

I'm going to apply the entire patchset, would you send me a patch for
this minor glitch?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
