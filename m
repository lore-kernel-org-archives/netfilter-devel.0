From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2 v3] evaluate: reject: accept a reject reason with
 incorrect network context
Date: Fri, 24 Oct 2014 12:04:43 +0200
Message-ID: <20141024100443.GC4806@salvia>
References: <1413984353-16029-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755809AbaJXKDO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:03:14 -0400
Content-Disposition: inline
In-Reply-To: <1413984353-16029-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 22, 2014 at 03:25:52PM +0200, Alvaro Neira Ayuso wrote:
> nft add rule bridge test-bridge input ether type ip \
> 				reject with icmpv6 type no-route
> 
> This rule pass the evaluation step but the network context is incompatible with
> the reject reason. In that cases, we have to throw an error like "conflicting
> protocols specified: ip vs ip6"

Applied, thanks.
