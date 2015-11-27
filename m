From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft]evaluate function should have a explicitly return
 value
Date: Fri, 27 Nov 2015 10:43:05 +0100
Message-ID: <20151127094305.GB1431@salvia>
References: <0A900C78B9F2324AB7F4F7A51D1A2F8577978450@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Linmujia <linmujia@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53940 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbbK0JnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 04:43:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 437E318CDC6
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 10:43:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 34897DA861
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 10:43:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3CC6ADA860
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Nov 2015 10:43:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <0A900C78B9F2324AB7F4F7A51D1A2F8577978450@szxema505-mbs.china.huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 27, 2015 at 09:16:49AM +0000, Linmujia wrote:
> evaluate function should have a explicitly return value,otherwise the return value is random.
> 
> Signed-off-by: linmujia <linmujia@huawei.com>
> ---
>  src/evaluate.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 7aab6aa..df4bf17 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1319,6 +1319,7 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
>  	default:
>  		BUG("unknown expression type %s\n", (*expr)->ops->name);
>  	}
> +	return 0;
>  }
>  
>  static int stmt_evaluate_expr(struct eval_ctx *ctx, struct stmt *stmt)
> @@ -1446,6 +1447,7 @@ static int stmt_reject_gen_dependency(struct eval_ctx *ctx, struct stmt *stmt,
>  		ret = reject_payload_gen_dependency_family(ctx, stmt, &payload);
>  		break;
>  	default:
> +		ret = 1;
>  		BUG("cannot generate reject dependency for type %d",
>  		    stmt->reject.type);

Bug stops the execution of the tool, so I think this will not be very
useful.
