From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink_acct: Fixing memory leak
Date: Mon, 2 Jun 2014 10:48:14 +0200
Message-ID: <20140602084814.GA5551@localhost>
References: <1401673378-20755-1-git-send-email-mathieu.poirier@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, dan.carpenter@oracle.com
To: mathieu.poirier@linaro.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43925 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbaFBIsb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:48:31 -0400
Content-Disposition: inline
In-Reply-To: <1401673378-20755-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 01, 2014 at 07:42:58PM -0600, mathieu.poirier@linaro.org wrote:
> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> 
> Allocation of memory need only to happen once, that is
> after the proper checks on the NFACCT_FLAGS have been
> done.  Otherwise the code can return without freeing
> already allocated memory.

Applied, thanks.
