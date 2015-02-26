From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 3/3] netlink_delinearize: fix postprocessing
Date: Thu, 26 Feb 2015 08:40:02 +0000
Message-ID: <20150226084002.GA5498@acer.localdomain>
References: <1424908270-554-1-git-send-email-eric@regit.org>
 <1424908270-554-4-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62167 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbBZIkH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2015 03:40:07 -0500
Content-Disposition: inline
In-Reply-To: <1424908270-554-4-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.02, Eric Leblond wrote:
> The following rule:
>   ip protocol tcp counter packets 0 bytes 0 tcp dport ssh accept
> 
> is build in byte code as:
> 
>   ip test filter
>     [ payload load 1b @ network header + 9 => reg 1 ]
>     [ cmp eq reg 1 0x00000006 ]
>     [ counter pkts 0 bytes 0 ]
>     [ payload load 2b @ transport header + 2 => reg 1 ]
>     [ cmp eq reg 1 0x00001600 ]
>     [ immediate reg 0 accept ]
> 
> But the simplication process is reverting it to:
>   counter tcp dport ssh accept
> 
> Which is different rule.
> 
> This patch is fixing the issue by resetting the dependency when we
> are seeing a counter statement.

This isn't specific to the counter statement but any kind of statement
that is non-terminal.

Or more generally speaking, we only want to undo the automatic payload
expression generation, which always generates expressions like this

1. dependency expression (generated)
2. dependant expression

So I'd argue that we should at least reset it for all statements other
than STMT_EXPR. That case is more complicated to handle and I'd leave it
for now.

> @@ -1137,6 +1143,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
>  		case STMT_REJECT:
>  			stmt_reject_postprocess(rctx, stmt);
>  			break;
> +		case STMT_COUNTER:
> +			payload_dependency_reset(&rctx);
> +			break;
>  		default:
>  			break;
>  		}
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
