From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] linealize: generate unary expression with the
 appropiate operation
Date: Tue, 19 Aug 2014 00:09:42 +0200
Message-ID: <20140818220942.GA4567@salvia>
References: <1408395612-9791-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49922 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaHRWJF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Aug 2014 18:09:05 -0400
Content-Disposition: inline
In-Reply-To: <1408395612-9791-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mon, Aug 18, 2014 at 11:00:12PM +0200, Alvaro Neira Ayuso wrote:
> If we add a unary expression which the operation is ntoh, we use hton.
> This looks like a typo.

Applied, thanks.

