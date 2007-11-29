From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [NET 00/02]: Remove NET_ACT_NAT dependency on NETFILTER
Date: Fri, 30 Nov 2007 01:32:58 +1100
Message-ID: <20071129143258.GA3456@gondor.apana.org.au>
References: <20071129095733.11756.86966.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4438 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759663AbXK2OdB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 09:33:01 -0500
Content-Disposition: inline
In-Reply-To: <20071129095733.11756.86966.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 29, 2007 at 10:57:34AM +0100, Patrick McHardy wrote:
> These patches remove the dependency of NET_ACT_NAT on NETFILTER
> by moving the netfilter checksum helpers to include/net/checksum
> and net/core/utils.c. I didn't find more appropriate locations,
> but I'd happily change it if someone suggests something better.

Looks good to me.  I've applied both to net-2.6.25.  Thanks Patrick!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
