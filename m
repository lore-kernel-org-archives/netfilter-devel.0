From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 0/5] queue: Do not print unset value
Date: Mon, 16 Jun 2014 12:11:55 +0200
Message-ID: <20140616101155.GA10466@localhost>
References: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47908 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbaFPKMI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:12:08 -0400
Content-Disposition: inline
In-Reply-To: <1402651913-15065-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 13, 2014 at 11:31:48AM +0200, Ana Rey wrote:
> This patchset does tasks about does not print unset value in xml and json file
> and about refactoring code: "Add nft_rule_expr_queue_snprinf_* functions"
> and "Use nft_rule_expr_* in the xml".
> 
> Also, It fixes some data type of variables.
> 
> Ana Rey (5):
>   expr: queue: Add nft_rule_expr_queue_snprinf_* functions
>   expr: queue: Use nft_rule_expr_* in the xml
>   expr: queue: Do not print unset values in xml
>   expr: queue: Do not print unset values in json
>   expr: queue: Use the correct data type.

Series applied, thanks Ana.
