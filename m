From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Spelling fixes
Date: Sat, 5 Sep 2015 23:07:46 +0200
Message-ID: <20150905210746.GA13600@salvia>
References: <1441436676-10778-1-git-send-email-ville.skytta@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ville =?iso-8859-1?Q?Skytt=E4?= <ville.skytta@iki.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35947 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbbIEVBQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Sep 2015 17:01:16 -0400
Content-Disposition: inline
In-Reply-To: <1441436676-10778-1-git-send-email-ville.skytta@iki.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 05, 2015 at 10:04:36AM +0300, Ville Skytt=E4 wrote:
> Signed-off-by: Ville Skytt=E4 <ville.skytta@iki.fi>
> ---
>  iptables/ip6tables.c    | 6 +++---
>  iptables/iptables-xml.c | 2 +-
>  iptables/iptables.c     | 6 +++---
>  iptables/iptables.xslt  | 2 +-
>  libiptc/libiptc.c       | 2 +-
>  libxtables/xtables.c    | 2 +-
>  6 files changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> index 8db13b4..4a597b7 100644
> --- a/iptables/ip6tables.c
> +++ b/iptables/ip6tables.c
> @@ -1046,7 +1046,7 @@ static int print_match_save(const struct xt_ent=
ry_match *e,
>  	return 0;
>  }
> =20
> -/* print a given ip including mask if neccessary */
> +/* print a given ip including mask if necessary */
>  static void print_ip(const char *prefix, const struct in6_addr *ip,
>  		     const struct in6_addr *mask, int invert)
>  {
> @@ -1067,7 +1067,7 @@ static void print_ip(const char *prefix, const =
struct in6_addr *ip,
>  		printf("/%d", l);
>  }
> =20
> -/* We want this to be readable, so only print out neccessary fields.
> +/* We want this to be readable, so only print out necessary fields.
>   * Because that's the kind of world I want to live in.  */

While you're at it, would you also update the comment format for
these? I mean:

/* We want this to be readable, so only print out neccessary fields.
 * Because that's the kind of world I want to live in.
 */

The idea is to update only the comments that you have corrected.
Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
