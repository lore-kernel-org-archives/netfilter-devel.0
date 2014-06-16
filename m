From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 0/4] limit: Do not print unset value
Date: Mon, 16 Jun 2014 12:34:14 +0200
Message-ID: <20140616103414.GA12550@localhost>
References: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57033 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992AbaFPKeT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:34:19 -0400
Content-Disposition: inline
In-Reply-To: <1402909817-25325-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 16, 2014 at 11:10:13AM +0200, Ana Rey wrote:
> This patchset does tasks about does not print unset value in xml and json file
> and about refactoring code:
> "expr: limit: Add nft_rule_expr_limit_snprinf_* functions" and
> "expr: limit: Use nft_rule_expr_set_* in the xml parsing code"
> 
> Ana Rey (4):
>   expr: limit: Add nft_rule_expr_limit_snprinf_* functions
>   expr: limit: Use nft_rule_expr_set_* in the xml parsing code
>   expr: limit: Do not print unset values in json
>   expr: limit: Do not print unset values in xml

Series applied, thanks Ana.
