From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: synproxy: fix BUG_ON triggered by corrupt TCP
 packets
Date: Mon, 30 Sep 2013 12:45:54 +0200
Message-ID: <20130930104554.GA5462@localhost>
References: <1380527506-27585-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, mph@one.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51716 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab3I3KqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:46:09 -0400
Content-Disposition: inline
In-Reply-To: <1380527506-27585-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 08:51:46AM +0100, Patrick McHardy wrote:
> TCP packets hitting the SYN proxy through the SYNPROXY target are not
> validated by TCP conntrack. When th->doff is below 5, an underflow happens
> when calculating the options length, causing skb_header_pointer() to
> return NULL and triggering the BUG_ON().
> 
> Handle this case gracefully by checking for NULL instead of using BUG_ON().

Applied, thanks Patrick!
