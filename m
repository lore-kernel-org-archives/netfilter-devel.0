Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD02C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 23:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhLOXXE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 18:23:04 -0500
Received: from mail.netfilter.org ([217.70.188.207]:56496 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhLOXXE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 18:23:04 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 041D4607E0;
        Thu, 16 Dec 2021 00:20:33 +0100 (CET)
Date:   Thu, 16 Dec 2021 00:22:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] src: propagate key datatype for anonymous sets
Message-ID: <Ybp40gmoXMtPpDDm@salvia>
References: <20211209151131.22618-1-fw@strlen.de>
 <20211209151131.22618-3-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211209151131.22618-3-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 09, 2021 at 04:11:31PM +0100, Florian Westphal wrote:
> set s10 {
>   typeof tcp option mptcp subtype
>   elements = { mp-join, dss }
> }
> 
> is listed correctly: typeof provides the 'mptcpopt_subtype'
> datatype, so listing will print the elements with their sybolic types.
> 
> In anon case this doesn't work:
> tcp option mptcp subtype { mp-join, dss }
> 
> gets shown as 'tcp option mptcp subtype { 1,  2}' because the anon
> set has integer type.
> 
> This change propagates the datatype to the individual members
> of the anon set.
> 
> After this change, multiple existing data types such as
> TYPE_ICMP_TYPE could be replaced by integer-type aliases, but those
> data types are already exposed to userspace via the 'set type'
> directive so doing this may break existing set definitions.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/expression.c              | 34 ++++++++++++++++++++++++++++++++++
>  tests/py/any/tcpopt.t         |  2 +-
>  tests/py/any/tcpopt.t.payload | 10 +++++-----
>  3 files changed, 40 insertions(+), 6 deletions(-)
> 
> diff --git a/src/expression.c b/src/expression.c
> index f1cca8845376..9de70c6cc1a4 100644
> --- a/src/expression.c
> +++ b/src/expression.c
> @@ -1249,6 +1249,31 @@ static void set_ref_expr_destroy(struct expr *expr)
>  	set_free(expr->set);
>  }
>  
> +static void set_ref_expr_set_type(const struct expr *expr,
> +				  const struct datatype *dtype,
> +				  enum byteorder byteorder)
> +{
> +	const struct set *s = expr->set;
> +
> +	/* normal sets already have a precise datatype that is given in
> +	 * the set definition via type foo.
> +	 *
> +	 * Anon sets do not have this, and need to rely on type info
> +	 * generated at rule creation time.
> +	 *
> +	 * For most cases, the type info is correct.
> +	 * In some cases however, the kernel only stores TYPE_INTEGER.
> +	 *
> +	 * This happens with expressions that only use an integer alias
> +	 * type, such as mptcp_suboption.
> +	 *
> +	 * In this case nft would print '1', '2', etc. instead of symbolic
> +	 * names because the base type lacks ->sym_tbl information.
> +	 */
> +	if (s->init && set_is_anonymous(s->flags))
> +		expr_set_type(s->init, dtype, byteorder);

Will this work with concatenations?
