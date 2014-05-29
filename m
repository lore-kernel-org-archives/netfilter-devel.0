From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2] src: expr: log: Code refactoring in
 nft_rule_expr_log_snprintf
Date: Thu, 29 May 2014 14:58:57 +0200
Message-ID: <20140529125857.GA10282@localhost>
References: <1401362800-30749-1-git-send-email-anarey@gmail.com>
 <1401362800-30749-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49467 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbaE2M7G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 08:59:06 -0400
Content-Disposition: inline
In-Reply-To: <1401362800-30749-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 29, 2014 at 01:26:39PM +0200, Ana Rey wrote:
> This process adds three new functions:
> 
> * nft_rule_expr_log_snprintf_default
> * nft_rule_expr_log_snprintf_xml
> * nft_rule_expr_log_snprintf_json

Applied this cleanup, thanks Ana.
