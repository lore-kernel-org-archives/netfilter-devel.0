From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] mark newly opened fds as FD_CLOEXEC (close on exec)
 [part 2]
Date: Wed, 21 Mar 2012 13:27:43 -0700
Message-ID: <1332361663.9433.8.camel@edumazet-glaptop>
References: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62455 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130Ab2CUU1q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:27:46 -0400
Received: by pbcun15 with SMTP id un15so1024119pbc.19
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Mar 2012 13:27:45 -0700 (PDT)
In-Reply-To: <1332327120-22444-1-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-03-21 at 03:52 -0700, Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> This is iptables-1.4.11-cloexec.patch from Fedora 18 iptables source
> rpm, in particular:
>   http://kojipkgs.fedoraproject.org/packages/iptables/1.4.12.2/4.fc18=
/src/iptables-1.4.12.2-4.fc18.src.rpm
>=20
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  extensions/libxt_set.h |    7 +++++++
>  libiptc/libiptc.c      |    8 ++++++++
>  2 files changed, 15 insertions(+), 0 deletions(-)
>=20
> diff --git a/extensions/libxt_set.h b/extensions/libxt_set.h
> index 4ac84fa9c022..47c3f5b6f5d4 100644
> --- a/extensions/libxt_set.h
> +++ b/extensions/libxt_set.h
> @@ -2,6 +2,7 @@
>  #define _LIBXT_SET_H
> =20
>  #include <unistd.h>
> +#include <fcntl.h>
>  #include <sys/types.h>
>  #include <sys/socket.h>
>  #include <errno.h>
> @@ -23,6 +24,12 @@ get_version(unsigned *version)
>  		xtables_error(OTHER_PROBLEM,
>  			      "Can't open socket to ipset.\n");
> =20
> +	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
> +		xtables_error(OTHER_PROBLEM,
> +			      "Could not set close on exec: %s\n",
> +			      strerror(errno));
> +	}
> +
>  	req_version.op =3D IP_SET_OP_VERSION;
>  	res =3D getsockopt(sockfd, SOL_IP, SO_IP_SET, &req_version, &size);
>  	if (res !=3D 0)
> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> index 13e41d525f28..63965e738596 100644
> --- a/libiptc/libiptc.c
> +++ b/libiptc/libiptc.c
> @@ -29,6 +29,8 @@
>   * 	- performance work: speedup initial ruleset parsing.
>   * 	- sponsored by ComX Networks A/S (http://www.comx.dk/)
>   */
> +#include <unistd.h>
> +#include <fcntl.h>
>  #include <sys/types.h>
>  #include <sys/socket.h>
>  #include <stdbool.h>
> @@ -1316,6 +1318,12 @@ TC_INIT(const char *tablename)
>  	if (sockfd < 0)
>  		return NULL;
> =20
> +	if (fcntl(sockfd, F_SETFD, FD_CLOEXEC) =3D=3D -1) {
> +		fprintf(stderr, "Could not set close on exec: %s\n",
> +			strerror(errno));
> +		abort();
> +	}
> +
>  retry:
>  	s =3D sizeof(info);
> =20

Looks fine, but since commit a677a039b (flag parameters: socket and
socketpair) from Ulrich Drepper, we can pass SOCK_CLOEXEC directly in
the socket() call, thus avoiding extra fcntl() call.

Not relevant to iptables (opening this socket in iptables is not
performance critical), but worth to mention for reference.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
