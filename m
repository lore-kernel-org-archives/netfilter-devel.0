From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: 2.6 IPSEC + SNAT
Date: Wed, 1 Oct 2003 22:16:48 +1000
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20031001121648.GA8755@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
To: kuznet@ms2.inr.ac.ru, davem@redhat.com, jmorris@redhat.com,
	linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi:

I have received bug reports saying that SNAT does not work when the
packets have to be SNATed before they can enter an IPSEC tunnel
under the 2.6 IPSEC stack.

The problem is that SNAT can only be performed in POSTROUTING while
IPSEC policy lookups are done at the same time as the route lookup.

Has anyone else thought about this problem?

I have considered introducing a new NAT chain between filtering
and routing where you can place SNAT rules into.  Of course, the
same thing applies to reverse DNAT rules as well.

Any opinions on this would be appreciated.

Thanks,
-- 
Debian GNU/Linux 3.0 is out! ( http://www.debian.org/ )
Email:  Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
