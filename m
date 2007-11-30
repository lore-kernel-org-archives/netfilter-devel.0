From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [NETFILTER 00/03]: Netfilter fixes
Date: Sat, 1 Dec 2007 00:04:28 +1100
Message-ID: <20071130130428.GI26848@gondor.apana.org.au>
References: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4404 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762217AbXK3NEc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:04:32 -0500
Content-Disposition: inline
In-Reply-To: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Nov 30, 2007 at 12:57:12AM +0100, Patrick McHardy wrote:
> 
> these patches for 2.6.24 fix a number of netfilter bugs: a refcount leak in a
> CONNMARK and CONNSECMARK error path, a network triggerable WARN_ON in the
> IPv6 TCPMSS target and an endless loop caused by passing a zero-length pattern
> to the string match.
> 
> Please apply, thanks.

All applied.  Thanks a lot Patrick.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
