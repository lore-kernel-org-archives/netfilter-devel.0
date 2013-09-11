From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v3] netfilter: ipset: Fix serious failure in CIDR
 tracking
Date: Wed, 11 Sep 2013 21:32:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309112117470.30814@blackhole.kfki.hu>
References: <1378894613-37279-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309111555360.27719@blackhole.kfki.hu> <1613281.TIUUNvYVSf@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:33002 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3IKTc2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:32:28 -0400
In-Reply-To: <1613281.TIUUNvYVSf@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 11 Sep 2013, Oliver wrote:

> On Wednesday 11 September 2013 16:01:18 Jozsef Kadlecsik wrote:
> > 
> > On Wed, 11 Sep 2013, Oliver wrote:
> > > From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > > 
> > > This fixes a serious bug affecting all hash types with a net element -
> > > specifically, if a CIDR value is deleted such that none of the same size
> > > exist any more, all larger (less-specific) values will then fail to
> > > match. Adding back any prefix with a CIDR equal to or more specific than
> > > the one deleted will fix it.
> > > 
> > > Steps to reproduce:
> > > ipset -N test hash:net
> > > ipset -A test 1.1.0.0/16
> > > ipset -A test 2.2.2.0/24
> > > ipset -T test 1.1.1.1		#1.1.1.1 IS in set
> > > ipset -D test 2.2.2.0/24
> > > ipset -T test 1.1.1.1		#1.1.1.1 IS NOT in set
> > > 
> > > This is due to the fact that the nets counter was unconditionally
> > > decremented prior to the iteration that shifts up the entries. Now, we
> > > first check if there is a proceeding entry and if not, decrement it and
> > > return. Otherwise, we proceed to iterate and then clean up the last
> > > element afterwards.
> > > 
> > > Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> > > ---
> > > 
> > >  kernel/net/netfilter/ipset/ip_set_hash_gen.h | 13 +++++++------
> > >  1 file changed, 7 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> > > b/kernel/net/netfilter/ipset/ip_set_hash_gen.h index 7a5b776..6599ea8
> > > 100644
> > > --- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> > > +++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
> > > @@ -307,19 +307,20 @@ mtype_add_cidr(struct htype *h, u8 cidr, u8
> > > nets_length, u8 n)> 
> > >  static void
> > >  mtype_del_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
> > >  {
> > > 
> > > -	u8 i, j;
> > > +	u8 i, j, net_end = nets_length - 1;
> > > 
> > > -	for (i = 0; i < nets_length - 1 && h->nets[i].cidr[n] != cidr; i++)
> > > +	for (i = 0; i < net_end && h->nets[i].cidr[n] != cidr; i++)
> > > 
> > >  		;
> > > 
> > > -	h->nets[i].nets[n]--;
> > > -
> > > -	if (h->nets[i].nets[n] != 0)
> > > +	if (h->nets[i].nets[n] > 1 || i == net_end || !h->nets[i + 1].nets[n]) 
> {
> > > +		h->nets[i].nets[n]--;
> > > 
> > >  		return;
> > > 
> > > +	}
> > 
> > If you restored the original code in the part above, then the whole thing
> > could be collapsed into starting the next loop from j = i + 1 (and
> > changing the indices in the for body accordingly).
> 
> I'm not sure I follow; the whole problem is that the proceeding loop 
> fails because the element at j gets set to zero, causing it to be 
> skipped when we do our shift-up below - why would we want to bother with 
> looping when we can just decrement and return immediately?

The for loop below would not be started due to the conditions: actually, 
then conditions above ("i == net_end || !h->nets[i + 1].nets[n]") would be 
"moved" here. In another words, would not be duplicated:

	for (j = i + 1; j < nets_length - 1 && h->nets[j].nets[n]; j++)
		h->nets[j - 1].cidr[n] = h->nets[j + 1].cidr[n];
		..
	}
	if (j < nets_length)
		h->nets[j - 1].nets[n] = 0;

> > > -	for (j = i; j < nets_length - 1 && h->nets[j].nets[n]; j++) {
> > > +	for (j = i; j < net_end && h->nets[j].nets[n]; j++) {
> > > 
> > >  		h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
> > >  		h->nets[j].nets[n] = h->nets[j + 1].nets[n];
> > >  	
> > >  	}
> > > 
> > > +	h->nets[j].nets[n] = 0;
> > 
> > Here the checking of the value "j" is missing.
> 
> I suppose we can check this, but what's the point really? j is always 
> going to be nets_length - 1, so setting that element to zero is either 
> necessary for cleanup, or won't do anything of use (nor harm) - why add 
> in a memory read to see if we need to do a memory write when there's no 
> harm in just doing it regardless?

What is the difference between the first for loop in this function and 
this second one, from the loop variable point of view? Or, what is the 
value of "j" after the for loop, if all nets[j] slots are filled up?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
