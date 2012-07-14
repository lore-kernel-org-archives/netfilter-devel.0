From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxt_recent: remove unused variable
Date: Sat, 14 Jul 2012 15:55:01 +0200
Message-ID: <20120714135501.GA2008@1984>
References: <1341438834-24509-1-git-send-email-eldad@fogrefinery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eldad Zack <eldad@fogrefinery.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48164 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab2GNNzE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:55:04 -0400
Content-Disposition: inline
In-Reply-To: <1341438834-24509-1-git-send-email-eldad@fogrefinery.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 04, 2012 at 11:53:54PM +0200, Eldad Zack wrote:
> The info variable is assigned but never read in recent_check().

Applied, thanks Eldad.
