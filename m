From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Optimise nfq_queue_cb
Date: Fri, 12 Jun 2015 15:08:19 +0200
Message-ID: <20150612130819.GA15960@salvia>
References: <E1Z0RG2-0008UB-BF@BRA-J2N4P12.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Paul Aitken <paitken@brocade.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37078 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbbFLNDI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Jun 2015 09:03:08 -0400
Content-Disposition: inline
In-Reply-To: <E1Z0RG2-0008UB-BF@BRA-J2N4P12.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 04, 2015 at 10:15:00AM +0100, Paul Aitken wrote:
> ct and myct have both already been checked for non-NULL,
> so there's no need to check either of them again later.

Applied, thanks.


