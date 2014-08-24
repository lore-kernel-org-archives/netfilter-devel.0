From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] [nft] src: Add support for cpu in meta expresion
Date: Sun, 24 Aug 2014 14:55:30 +0200
Message-ID: <20140824125530.GC7864@salvia>
References: <1407394858-26841-1-git-send-email-anarey@gmail.com>
 <1407394858-26841-3-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59674 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbaHXMyt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 08:54:49 -0400
Content-Disposition: inline
In-Reply-To: <1407394858-26841-3-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 07, 2014 at 09:00:57AM +0200, Ana Rey wrote:
> This allows you to match cpu handling with a packet.
> 
> This is an example of the syntax for this new attribute:
> 
> nft add rule ip test input meta cpu 1 counter
> nft add rule ip test input meta cpu 1-3 counter
> nft add rule ip test input meta cpu { 1, 3} counter

Applied, thanks Ana.

