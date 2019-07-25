Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C26C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FEC522BEF
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 10:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfGYKoe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 06:44:34 -0400
Received: from mail.us.es ([193.147.175.20]:33082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfGYKod (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 06:44:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4FD56FC5EB
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:44:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F4B4DA732
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jul 2019 12:44:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 34BD15765B; Thu, 25 Jul 2019 12:44:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61C55DA732;
        Thu, 25 Jul 2019 12:44:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jul 2019 12:44:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.183.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ECBA34265A2F;
        Thu, 25 Jul 2019 12:44:27 +0200 (CEST)
Date:   Thu, 25 Jul 2019 12:44:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 2/2 nft] src: allow variable in chain policy
Message-ID: <20190725104425.2byt6gwruopkpqx6@salvia>
References: <20190722160236.12516-1-ffmancera@riseup.net>
 <20190722160236.12516-3-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722160236.12516-3-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 22, 2019 at 06:02:39PM +0200, Fernando Fernandez Mancera wrote:
> This patch introduces the use of nft input files variables in chain policy.
> e.g.
> 
> define default_policy = "accept"
> 
> add table ip foo
> add chain ip foo bar {type filter hook input priority filter; policy $default_policy}
> 
> table ip foo {
> 	chain bar {
> 		type filter hook input priority filter; policy accept;
> 	}
> }
> 
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  include/rule.h                                |  2 +-
>  src/evaluate.c                                | 51 +++++++++++++++++++
>  src/json.c                                    |  5 +-
>  src/mnl.c                                     |  9 ++--
>  src/netlink.c                                 |  8 ++-
>  src/parser_bison.y                            | 19 +++++--
>  src/parser_json.c                             | 17 +++++--
>  src/rule.c                                    | 13 +++--
>  .../testcases/nft-f/0025policy_variable_0     | 17 +++++++
>  .../testcases/nft-f/0026policy_variable_0     | 17 +++++++
>  .../testcases/nft-f/0027policy_variable_1     | 18 +++++++
>  .../testcases/nft-f/0028policy_variable_1     | 18 +++++++
>  .../nft-f/dumps/0025policy_variable_0.nft     |  5 ++
>  .../nft-f/dumps/0026policy_variable_0.nft     |  5 ++
>  14 files changed, 186 insertions(+), 18 deletions(-)
>  create mode 100755 tests/shell/testcases/nft-f/0025policy_variable_0
>  create mode 100755 tests/shell/testcases/nft-f/0026policy_variable_0
>  create mode 100755 tests/shell/testcases/nft-f/0027policy_variable_1
>  create mode 100755 tests/shell/testcases/nft-f/0028policy_variable_1
>  create mode 100644 tests/shell/testcases/nft-f/dumps/0025policy_variable_0.nft
>  create mode 100644 tests/shell/testcases/nft-f/dumps/0026policy_variable_0.nft
> 
> diff --git a/include/rule.h b/include/rule.h
> index c6e8716..b12165a 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -209,7 +209,7 @@ struct chain {
>  	const char		*hookstr;
>  	unsigned int		hooknum;
>  	struct prio_spec	priority;
> -	int			policy;
> +	struct expr		*policy;
>  	const char		*type;
>  	const char		*dev;
>  	struct scope		scope;
> diff --git a/src/evaluate.c b/src/evaluate.c
> index d2faee8..4d8bfbf 100755
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3415,6 +3415,52 @@ static uint32_t str2hooknum(uint32_t family, const char *hook)
>  	return NF_INET_NUMHOOKS;
>  }
>  
> +static bool evaluate_policy(struct eval_ctx *ctx, struct expr **policy)

better rename static bool ...(..., struct expr **exprp)

> +{
> +	char policy_str[NFT_NAME_MAXLEN];
> +	struct location loc;
> +	int policy_num;

so you can use 'int policy;'.

> +	ctx->ectx.len = NFT_NAME_MAXLEN * BITS_PER_BYTE;
> +	if (expr_evaluate(ctx, policy) < 0)
> +		return false;

probably cache this here:

        expr = *exprp;

so you don't need:

        (*expr)->...

in all this code below.

> +	if ((*policy)->etype != EXPR_VALUE) {
> +		expr_error(ctx->msgs, *policy, "%s is not a valid "
> +			   "policy expression", expr_name(*policy));
> +		return false;
> +	}
> +
> +	if ((*policy)->dtype->type == TYPE_STRING) {
> +		mpz_export_data(policy_str, (*policy)->value,
> +				BYTEORDER_HOST_ENDIAN,
> +				NFT_NAME_MAXLEN);
> +		loc = (*policy)->location;
> +		if (!strcmp(policy_str, "accept")) {
> +			expr_free(*policy);
> +			policy_num = NF_ACCEPT;
> +			*policy = constant_expr_alloc(&loc,
> +						      &integer_type,
> +						      BYTEORDER_HOST_ENDIAN,
> +						      sizeof(int) * BITS_PER_BYTE,
> +						      &policy_num);
> +		} else if (!strcmp(policy_str, "drop")) {
> +			expr_free(*policy);
> +			policy_num = NF_DROP;
> +			*policy = constant_expr_alloc(&(*policy)->location,
> +						      &integer_type,
> +						      BYTEORDER_HOST_ENDIAN,
> +						      sizeof(int) * BITS_PER_BYTE,
> +						      &policy_num);

Probably:

		if (!strcmp(policy_str, "accept")) {
                        policy = NF_ACCEPT;
                else (!strmp(policy_str, "drop")) {
                        policy = NF_DROP;
                } else {
                        ...
                }

                expr = constant_expr_alloc(...);

so this code becomes shorter and easier to read.

And I think you should do all this from the new policy_datype, not
from the evaluation phase itself.

Thanks.
