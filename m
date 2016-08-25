From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH nf-next 1/2] rhashtable: add
 rhashtable_lookup_get_insert_key()
Date: Thu, 25 Aug 2016 12:21:22 +0800
Message-ID: <20160825042122.GB9906@gondor.apana.org.au>
References: <1472048595-7214-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tgraf@suug.ch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37222 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755699AbcHYFEy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 01:04:54 -0400
Content-Disposition: inline
In-Reply-To: <1472048595-7214-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 24, 2016 at 04:23:14PM +0200, Pablo Neira Ayuso wrote:
> This patch modifies __rhashtable_insert_fast() so it returns the
> existing element that clashes with the one that you want to insert.
> This adds a new rhashtable_lookup_get_insert_key() interface to fetch
> this existing element.
> 
> nf_tables needs this change to improve handling of EEXIST cases via
> honoring the NLM_F_EXCL flag and by checking if the data part of the
> mapping matches what we have.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Thomas Graf <tgraf@suug.ch>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I would prefer an interface where you returned the object if it
exists, NULL if it does not and the insertion was successful, and
an ERR_PTR otherwise.  But it's not a deal-breaker.

However, you missed the rhashtable_insert_slow path.  It too
needs to be updated to incorporate your new logic.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
