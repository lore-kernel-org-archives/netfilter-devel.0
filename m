From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2 v4] bridge: set the pktinfo for IPv4/IPv6 traffic
Date: Thu, 27 Nov 2014 12:59:53 +0100
Message-ID: <20141127115953.GB14723@salvia>
References: <1416993697-18285-1-git-send-email-alvaroneay@gmail.com>
 <1416993697-18285-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39283 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbaK0L5m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:57:42 -0500
Content-Disposition: inline
In-Reply-To: <1416993697-18285-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:21:37AM +0100, Alvaro Neira Ayuso wrote:
> This patch adds the missing bits to allow to match per meta l4proto from
> the bridge. Example:
> 
>   nft add rule bridge filter input ether type {ip, ip6} meta l4proto udp counter

Applied with changes, please see the nf-next tree.

Thanks.
