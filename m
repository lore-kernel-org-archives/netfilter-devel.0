From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: expr: log: fixed error in nft_rule_expr_log_build
Date: Tue, 19 Nov 2013 21:11:32 +0100
Message-ID: <20131119201132.GB4590@localhost>
References: <1384880178-32530-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43118 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab3KSULk convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:11:40 -0500
Content-Disposition: inline
In-Reply-To: <1384880178-32530-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 19, 2013 at 05:56:18PM +0100, Ana Rey wrote:
> If I run my automatic unit test of libnftable, It shows:
> "ERROR: Expr NFT_EXPR_LOG_PREFIX mismatches"
> a: test
> b: test
> 
> The problem was in nft_rule_expr_log_build function.
> 
> With the attached patch, we use "mnl_attr_put_strz" in instead of
> "mnl_attr_put_str".

Applied, thanks.
