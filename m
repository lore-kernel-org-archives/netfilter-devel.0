From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 9/9] netfilter: nft_log: complete logging support
Date: Thu, 26 Jun 2014 13:37:30 +0200
Message-ID: <20140626113730.GA5939@macbook.localnet>
References: <1403699563-3604-1-git-send-email-pablo@netfilter.org>
 <1403699563-3604-10-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51120 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbaFZLhg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:37:36 -0400
Content-Disposition: inline
In-Reply-To: <1403699563-3604-10-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 25, 2014 at 02:32:43PM +0200, Pablo Neira Ayuso wrote:
> +	switch (li->type) {
> +	case NF_LOG_TYPE_LOG:
> +		if (tb[NFTA_LOG_SYSLOG] != NULL) {
> +			li->u.log.level =
> +				ntohl(nla_get_be32(tb[NFTA_LOG_SYSLOG]));;
> +		} else {
> +			li->u.log.level = 4;
> +		}

I'd suggest to call it what it is, NFTA_LOG_LEVEL. Besides this minor issue,
the patches look good to me.
