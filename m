From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_acct: use PRIu64 and remove unnecessary cast
Date: Fri, 15 Mar 2013 12:47:27 +0100
Message-ID: <20130315114727.GA8329@localhost>
References: <20130305135943.GA4369@localhost>
 <51363C27.3020305@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter developer mailing list <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33519 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908Ab3COLrf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:47:35 -0400
Content-Disposition: inline
In-Reply-To: <51363C27.3020305@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 05, 2013 at 06:40:39PM +0000, Mr Dash Four wrote:
> This patch corrects all nfacct_snprintf_* functions to use PRIu64,
> given that we are using uint64_t type variables and also removes
> the unnecessary casts.

Applied, thanks.
