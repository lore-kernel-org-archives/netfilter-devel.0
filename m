From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5] Don't load ip6?_tables module when already loaded.
Date: Tue, 19 Apr 2011 09:03:21 +0200
Message-ID: <4DAD33B9.3030802@trash.net>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com> <1303176233-14063-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <maze@google.com>,
	netfilter-devel@vger.kernel.org
To: =?UTF-8?B?TWFjaWVqIMW7ZW5jenlrb3dza2k=?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32846 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab1DSHDn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:03:43 -0400
In-Reply-To: <1303176233-14063-1-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.04.2011 03:23, Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> Signed-off-by: Maciej Zenczykowski <maze@google.com>
> ---
>  xshared.h |    2 ++
>  xtables.c |   34 +++++++++++++++++++++++++++++-----
>  2 files changed, 31 insertions(+), 5 deletions(-)
>=20

> +/* return true if a given file exists within procfs */
> +static bool proc_file_exists(const char *filename)
> +{
> +	struct stat s;
> +	struct statfs f;
> +
> +	if (lstat(filename, &s)) return false;

Please put these return statements on lines of their own.

> +	if (!S_ISREG(s.st_mode)) return false;
> +	if (statfs(filename, &f)) return false;
> +	if (f.f_type !=3D PROC_SUPER_MAGIC) return false;
> +	return true;
> +}
> +
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
