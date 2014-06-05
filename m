From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v4 2/3] expr: log: Use nft_rule_expr_set_* in
 the xml parsing code
Date: Thu, 5 Jun 2014 15:17:54 +0200
Message-ID: <20140605131754.GB20181@localhost>
References: <1401792116-17742-1-git-send-email-anarey@gmail.com>
 <1401792116-17742-3-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41748 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaFENSD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:18:03 -0400
Content-Disposition: inline
In-Reply-To: <1401792116-17742-3-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 03, 2014 at 12:41:55PM +0200, Ana Rey wrote:
> Code refactoring to use nft_rule_expr_set_* in parse functions.

Applied, but removed the netlink chunk, it should come in a separated
patch.
