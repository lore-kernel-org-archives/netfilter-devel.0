From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH 2/2] reject: add ICMP code field parameter for
 indicating the type of error
Date: Mon, 16 Jun 2014 12:00:54 +0200
Message-ID: <20140616100054.GB9296@localhost>
References: <1402505463-8420-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43394 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbaFPKBD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:01:03 -0400
Content-Disposition: inline
In-Reply-To: <1402505463-8420-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 06:51:03PM +0200, Alvaro Neira Ayuso wrote:
> This patch allows to indicate the code field in case that we
> use reject. Before, we have sent always network unreachable error
> like code fiend and now we can determine the code field that
> we want to use. Example:
> 
> nft add rule filter input tcp dport 22 reject with host-unreach
> or
> nft add rule filter input udp dport 22 reject with host-unreach
> 
> In this case, we are going to use the code field host unreachable.
> 
> The default code field still is network unreachable and we can use
> also the rules without the with like that:
> 
> nft add rule filter input udp dport 22 reject

Also applied, thanks.
