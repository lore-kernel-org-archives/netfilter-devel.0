From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: modify pr_debug() to use printf and introduce
 to pr_gmp_debug()
Date: Thu, 8 Jan 2015 13:09:13 +0000
Message-ID: <20150108130912.GQ13765@acer.localdomain>
References: <1420721766-12130-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61144 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbbAHNJR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2015 08:09:17 -0500
Content-Disposition: inline
In-Reply-To: <1420721766-12130-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.01, Pablo Neira Ayuso wrote:
> Modify pr_debug() to use printf so we get debugging traces for
> proto-ctx with --with-mini-gmp is enabled.
> 
> Add pr_gmp_debug(), this is disabled with --with-mini-gmp since it
> relies on the gmp_printf(), which is not available in the mini-gmp
> implementation.
> 
> Suggested by Patrick.

Looks good to me.
