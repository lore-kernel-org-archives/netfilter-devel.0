From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/3] Netfilter: Remove ip_conntrack_tuple_hash "ctrack"
Date: Mon, 24 Jan 2005 13:56:21 +1100
Message-ID: <1106535381.19666.6.camel@localhost.localdomain>
References: <1105444254.19331.43.camel@localhost.localdomain>
	<m3k6q52ubw.fsf@igel.m5r.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andreas Schwab <schwab@suse.de>
In-Reply-To: <m3k6q52ubw.fsf@igel.m5r.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2005-01-22 at 19:26 +0100, Andreas Schwab wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> 
> > Index: linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
> > ===================================================================
> > --- linux-2.6.10-bk13-Netfilter.orig/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-01-11 21:04:11.743513264 +1100
> > +++ linux-2.6.10-bk13-Netfilter/include/linux/netfilter_ipv4/ip_conntrack_tuple.h	2005-01-11 21:05:20.015134400 +1100
> > @@ -64,7 +64,10 @@
> >  		} u;
> >  
> >  		/* The protocol. */
> > -		u_int16_t protonum;
> > +		u8 protonum;
> > +
> > +		/* The direction (for tuplehash) */
> > +		u8 dir;
> >  	} dst;
> >  };
> >  
> 
> Doesn't this break the iptables conntrack module on big-endian systems?

I don't see why... we only need 8 bits for the protocol, and we used to
use 16 (because we had them).  I wanted to add a field, so I reduced
protonum to 8 bits and added another 8 bit field.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
