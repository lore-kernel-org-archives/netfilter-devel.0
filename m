From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests: regression: any/meta: revisit meta tests
Date: Fri, 20 Feb 2015 16:58:33 +0100
Message-ID: <20150220155833.GD3834@salvia>
References: <1424431734-2305-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey Botello <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36500 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbbBTPzI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2015 10:55:08 -0500
Content-Disposition: inline
In-Reply-To: <1424431734-2305-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 20, 2015 at 12:28:54PM +0100, Ana Rey Botello wrote:
> From: Ana Rey <anarey@gmail.com>
> 
> Add, delete and rewrite some default outputs depending on the case.
> 
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  tests/regression/any/meta.t |   28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/tests/regression/any/meta.t b/tests/regression/any/meta.t
> index f11fd00..4b3d3fa 100644
> --- a/tests/regression/any/meta.t
> +++ b/tests/regression/any/meta.t
> @@ -9,8 +9,8 @@
>  meta length 1000;ok
>  meta length 22;ok
>  meta length != 233;ok
> -meta length 33-45;ok
> -meta length != 33-45;ok
> +meta length 33-45;ok;meta length >= 33 meta length <= 45
> +meta length != 33-45;ok;meta length < 33 meta length > 45

I'd rather like to get this fixed in nft, it should be not too
complicated to make it.
