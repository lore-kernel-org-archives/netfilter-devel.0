From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: expr: target: fixed error in
 nft_rule_expr_target_parse
Date: Tue, 19 Nov 2013 21:12:02 +0100
Message-ID: <20131119201202.GC4590@localhost>
References: <1384883654-10040-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43155 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab3KSUMH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:12:07 -0500
Content-Disposition: inline
In-Reply-To: <1384883654-10040-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 19, 2013 at 06:54:14PM +0100, Ana Rey wrote:
> If I run my automatic unit test of libnftable, It shows:
> 
> ERROR: Expr NFT_EXPR_TG_INFO size mismatches size a: 32 b: 36
> 
> The problem was in nft_rule_expr_target_parse function.
> 
> With the attached patch, we use "mnl_attr_get_payload_len" in instead of
> "mnl_attr_get_len".

Good catches, thanks for these fixes Ana.
