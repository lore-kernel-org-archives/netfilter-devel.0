From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: RE: [PATCH 3/7] netfilter: xt_HMARK: modulus is expensive for hash
 calculation
Date: Thu, 17 May 2012 10:39:28 +0200
Message-ID: <1337243968.3403.3.camel@edumazet-glaptop>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6F10@saturn3.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org
To: David Laight <David.Laight@ACULAB.COM>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6F10@saturn3.aculab.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2012-05-17 at 09:16 +0100, David Laight wrote:
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Use:
> > 
> > ((u64)(HASH_VAL * HASH_SIZE)) >> 32
> > 
> > as suggested by David S. Miller.
> 
> That (u64) cast is very unlikely to have any effect.
> If you want a 64 bit result from the product of two
> 32 bit values, you have to cast one of the 32 bit values
> prior to the multiply - as in the patch below.

Hey, Changelog is a bit wrong (for several reasons) but code is correct.

return (((u64)hash * info->hmodulus) >> 32) + info->hoffset;
