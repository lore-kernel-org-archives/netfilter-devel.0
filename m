From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] netlink: do not SIGSEGV when socket() fails
Date: Wed, 4 Dec 2013 20:30:37 +0100
Message-ID: <CAOkSjBjay9HZ9Lz2b8Amf=BQLsZac_YCpM+J_KnVxaLy1cg+tg@mail.gmail.com>
References: <1386184340-74134-1-git-send-email-shawn@churchofgit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shawn Landden <shawn@churchofgit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:46560 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933067Ab3LDTa7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:30:59 -0500
Received: by mail-la0-f51.google.com with SMTP id ec20so9744084lab.24
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2013 11:30:58 -0800 (PST)
In-Reply-To: <1386184340-74134-1-git-send-email-shawn@churchofgit.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 December 2013 20:12, Shawn Landden <shawn@churchofgit.com> wrote:
> ---
>  src/netlink.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>

Hi!

I would suggest to provide a description and a Signed-off-by line
within the patch.
Also, a small trace may help others (like me) to understand the situati=
on.

> diff --git a/src/netlink.c b/src/netlink.c
> index 533634a..664487d 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -33,8 +33,11 @@ static struct mnl_socket *nf_sock;
>  static void __init netlink_open_sock(void)
>  {
>         nf_sock =3D mnl_socket_open(NETLINK_NETFILTER);
> -       if (nf_sock =3D=3D NULL)
> +       if (nf_sock =3D=3D NULL) {
> +                fprintf(fdopen(STDERR_FILENO, "a"), "Could not open =
AF_NETLINK socket: %s\n",
> +                                        strerror(errno));

In your patch, the code seem indented with spaces. Tabs are used all
around the nft code.
Also, the second line should be aligned with the position+1 of first
'(' character of fprintf.

bonus: please consider adding a tag to the [PATCH] subject, like [nft
PATCH] or [libmnl PATCH].

regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
