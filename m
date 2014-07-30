From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: nfnetlink_acct: dump unmodified nfacct
 flags
Date: Wed, 30 Jul 2014 18:25:53 +0200
Message-ID: <20140730162553.GA6018@salvia>
References: <1406733475-5222-1-git-send-email-a.perevalov@samsung.com>
 <1406733475-5222-3-git-send-email-a.perevalov@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: alexey.perevalov@hotmail.com, mathieu.poirier@linaro.org,
	netfilter-devel@vger.kernel.org, kyungmin.park@samsung.com,
	hs81.go@samsung.com
To: Alexey Perevalov <a.perevalov@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59693 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbaG3QZ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:25:56 -0400
Content-Disposition: inline
In-Reply-To: <1406733475-5222-3-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 30, 2014 at 07:17:55PM +0400, Alexey Perevalov wrote:
> NFNL_MSG_ACCT_GET_CTRZERO modifies dumped flags, in this case
> client see unmodified (uncleared) counter value and cleared
> overquota state - end user doesn't know anything about overquota state,
> unless end user subscribed on overquota report.

Indeed, the old flags are relevant information for userspace. Applied,
thanks Alexey.
