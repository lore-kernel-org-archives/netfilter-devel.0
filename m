From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [RFC PATCHv2] netfilter: nf_tables: add insert operation
Date: Mon, 01 Jul 2013 10:01:14 +0300
Message-ID: <51D1293A.8020301@linux.intel.com>
References: <1371730620.6038.2.camel@ice-age.regit.org> <1372453518-4749-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:1326 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab3GAHGQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:06:16 -0400
In-Reply-To: <1372453518-4749-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

There is 2 long lines it seems,

> +		if (nla_put_be64(skb, NFTA_RULE_POSITION,
> +				 cpu_to_be64(((struct nft_rule *)rule->list.prev)->handle)))

Here,

> +			goto nla_put_failure;
> +	} else if (rule->list.next) {
> +		if (nla_put_be64(skb, NFTA_RULE_POSITION,
> +				 cpu_to_be64(((struct nft_rule *)rule->list.next)->handle)))

and there.

Tomasz
