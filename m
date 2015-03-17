From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/3] parser: Add operation not supported error
 message
Date: Tue, 17 Mar 2015 11:49:40 +0100
Message-ID: <20150317104940.GA6425@salvia>
References: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60186 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbbCQKpw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 06:45:52 -0400
Content-Disposition: inline
In-Reply-To: <1426518371-11717-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 16, 2015 at 04:06:09PM +0100, Alvaro Neira Ayuso wrote:
> If we try to import a ruleset in json or xml and the operation is not
> supported, we don't show any error message to this case.
> 
> This patch adds a new error path if the operation is not supported.
> Moreover, this patch sets up this error by default when we create the
> structure nft_parse_err.

Applied, thanks.

I have rewritten this summary a bit and renamed from
NFT_PARSE_OPNOTSUPP to NFT_PARSE_EOPNOTSUPP for consistency.
