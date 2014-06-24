From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 0/4] expr: exthdr: Do not print unset values in
 xml and json
Date: Tue, 24 Jun 2014 19:15:03 +0200
Message-ID: <20140624171503.GA23199@localhost>
References: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51053 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbaFXRPJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:15:09 -0400
Content-Disposition: inline
In-Reply-To: <1403613227-14134-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 24, 2014 at 02:33:43PM +0200, Ana Rey wrote:
> This patchset does tasks about does not print unset values in xml and json file
> and about refactoring code:
> * "expr: exthdr: Add nft_rule_expr_exthdr_snprinf_* functions"
> * "expr: exthdr: Use nft_rule_expr_set_* in the xml parsing code"
> 
> Ana Rey (4):
>   expr: exthdr: Add nft_rule_expr_exthdr_snprinf_* functions
>   expr: exthdr: Use nft_rule_expr_set_* in the xml parsing code
>   expr: exthdr: Do not print unset values in xml
>   expr: exthdr: Do not print unset values in json

Applied, thanks.
