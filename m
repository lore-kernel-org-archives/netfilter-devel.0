From: =?UTF-8?Q?Carlos_Falgueras_Garc=c3=ada?= <carlosfg@riseup.net>
Subject: Re: [PATCH libnftnl] set: Fix nftnl_set_set_str
Date: Mon, 27 Jun 2016 18:29:11 +0200
Message-ID: <914b6fa7-7f1c-771b-17ad-72bc9b1cefa5@riseup.net>
References: <20160627162425.4376-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:37783 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbcF0Q3T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jun 2016 12:29:19 -0400
In-Reply-To: <20160627162425.4376-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06/27/2016 06:24 PM, Carlos Falgueras Garc=C3=ADa wrote:
> We need the string length
>
> Signed-off-by: Carlos Falgueras Garc=C3=ADa <carlosfg@riseup.net>
> ---
>  src/set.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/src/set.c b/src/set.c
> index 879100c..edbcbe5 100644
> --- a/src/set.c
> +++ b/src/set.c
> @@ -203,7 +203,7 @@ EXPORT_SYMBOL_ALIAS(nftnl_set_set_u64, nft_set_at=
tr_set_u64);
>
>  int nftnl_set_set_str(struct nftnl_set *s, uint16_t attr, const char=
 *str)
>  {
> -	return nftnl_set_set(s, attr, str);
> +	return nftnl_set_set_data(s, attr, str, strlen(str));
>  }
>  EXPORT_SYMBOL_ALIAS(nftnl_set_set_str, nft_set_attr_set_str);

This bug has gone unnoticed because all tests check if the set attribut=
e=20
was equal to the parsed one, but not check if it was really set. If you=
=20
try to set an string but it fail, the test compares two empty strings=20
and says that it is correct.

Maybe we can impove the tests if it checks too if the gotten attribute=20
is equal to the set one.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
