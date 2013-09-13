From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v3] netfilter: ipset: Fix serious failure in CIDR
 tracking
Date: Fri, 13 Sep 2013 22:03:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309132156290.4634@blackhole.kfki.hu>
References: <1378894613-37279-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1613281.TIUUNvYVSf@gentoovm> <alpine.DEB.2.00.1309112117470.30814@blackhole.kfki.hu> <34508068.QlVPmtIuPd@gentoovm>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:43047 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab3IMUDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:03:37 -0400
In-Reply-To: <34508068.QlVPmtIuPd@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 12 Sep 2013, Oliver wrote:

> On Wednesday 11 September 2013 21:32:26 Jozsef Kadlecsik wrote:
> > On Wed, 11 Sep 2013, Oliver wrote:
> > > On Wednesday 11 September 2013 16:01:18 Jozsef Kadlecsik wrote:
> > > > On Wed, 11 Sep 2013, Oliver wrote:
> <snip>
> > > > 
> > > > If you restored the original code in the part above, then the whole
> > > > thing
> > > > could be collapsed into starting the next loop from j = i + 1 (and
> > > > changing the indices in the for body accordingly).
> > > 
> > > I'm not sure I follow; the whole problem is that the proceeding loop
> > > fails because the element at j gets set to zero, causing it to be
> > > skipped when we do our shift-up below - why would we want to bother with
> > > looping when we can just decrement and return immediately?
> > 
> > The for loop below would not be started due to the conditions: actually,
> > then conditions above ("i == net_end || !h->nets[i + 1].nets[n]") would be
> > "moved" here. In another words, would not be duplicated:
> > 
> > 	for (j = i + 1; j < nets_length - 1 && h->nets[j].nets[n]; j++)
> > 		h->nets[j - 1].cidr[n] = h->nets[j + 1].cidr[n];
> > 		..
> > 	}
> > 	if (j < nets_length)
> > 		h->nets[j - 1].nets[n] = 0;
> > 
> 
> I don't really like this idea; i + 1 after the second iteration will 
> point to whatever was shifted up, this obviously doesn't really present 
> a problem since if the element is empty, we won't iterate any more, but 
> I don't think it looks good for code clarity and it's just going to be a 
> non-changing value that the processor must pointlessly compare on every 
> iteration (first and second run notwithstanding).

I couldn't follow your reasoning above, maybe it's just too late here.

Anyway, I'd like to ask you two small modifications compared to v3 and 
that's all:

- Change the condition of the first "if" to an inequality, with a 
  continue statement in the if body. Thus the next lines can be shifted
  to the left, for better readability.
- Move the "i == net_end" test to the last position, because that is
  the less likely case.

Thanks! 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
