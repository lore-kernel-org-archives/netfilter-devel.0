From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH v3] netfilter: ipset: Fix serious failure in CIDR tracking
Date: Thu, 12 Sep 2013 09:45:47 +0200
Message-ID: <34508068.QlVPmtIuPd@gentoovm>
References: <1378894613-37279-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1613281.TIUUNvYVSf@gentoovm> <alpine.DEB.2.00.1309112117470.30814@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:37321 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab3ILHqY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:46:24 -0400
In-Reply-To: <alpine.DEB.2.00.1309112117470.30814@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 11 September 2013 21:32:26 Jozsef Kadlecsik wrote:
> On Wed, 11 Sep 2013, Oliver wrote:
> > On Wednesday 11 September 2013 16:01:18 Jozsef Kadlecsik wrote:
> > > On Wed, 11 Sep 2013, Oliver wrote:
<snip>
> > > 
> > > If you restored the original code in the part above, then the whole
> > > thing
> > > could be collapsed into starting the next loop from j = i + 1 (and
> > > changing the indices in the for body accordingly).
> > 
> > I'm not sure I follow; the whole problem is that the proceeding loop
> > fails because the element at j gets set to zero, causing it to be
> > skipped when we do our shift-up below - why would we want to bother with
> > looping when we can just decrement and return immediately?
> 
> The for loop below would not be started due to the conditions: actually,
> then conditions above ("i == net_end || !h->nets[i + 1].nets[n]") would be
> "moved" here. In another words, would not be duplicated:
> 
> 	for (j = i + 1; j < nets_length - 1 && h->nets[j].nets[n]; j++)
> 		h->nets[j - 1].cidr[n] = h->nets[j + 1].cidr[n];
> 		..
> 	}
> 	if (j < nets_length)
> 		h->nets[j - 1].nets[n] = 0;
> 

I don't really like this idea; i + 1 after the second iteration will point to 
whatever was shifted up, this obviously doesn't really present a problem since 
if the element is empty, we won't iterate any more, but I don't think it looks 
good for code clarity and it's just going to be a non-changing value that the 
processor must pointlessly compare on every iteration (first and second run 
notwithstanding).

Checking i against net_end is not a problem either, but again, I don't see why 
we would want to make the processor pointlessly recompare something that is 
guaranteed to be true on every iteration, especially since it's not going to 
make the code "simpler" or easier to follow.

> > > > -	for (j = i; j < nets_length - 1 && h->nets[j].nets[n]; j++) {
> > > > +	for (j = i; j < net_end && h->nets[j].nets[n]; j++) {
> > > > 
> > > >  		h->nets[j].cidr[n] = h->nets[j + 1].cidr[n];
> > > >  		h->nets[j].nets[n] = h->nets[j + 1].nets[n];
> > > >  	
> > > >  	}
> > > > 
> > > > +	h->nets[j].nets[n] = 0;
> > > 
> > > Here the checking of the value "j" is missing.
> > 
> > I suppose we can check this, but what's the point really? j is always
> > going to be nets_length - 1, so setting that element to zero is either
> > necessary for cleanup, or won't do anything of use (nor harm) - why add
> > in a memory read to see if we need to do a memory write when there's no
> > harm in just doing it regardless?
> 
> What is the difference between the first for loop in this function and
> this second one, from the loop variable point of view? Or, what is the
> value of "j" after the for loop, if all nets[j] slots are filled up?

Sorry, I explained this inaccurately; obviously if the array is not completely 
filled, the last element is going to be taken care of by virtue of the fact 
that j+1 would have had to be zero, thereby making the unconditional write 
after the loop basically a do-nothing operation. However, if it was completely 
filled, we *do* then need to zero it since net_end would be the reason for 
termination of loop iteration, leaving the old "copy" of the net element right 
at the end. So the question is, what is faster - reading and checking if we 
need to write the memory location before we do so, or just unconditionally 
writing it? Evidently in most cases the value is most likely going to be 0 
already, so is a mem write slower than a read and compare? Do we really care 
that much?

In any case, I do see scope for redoing the flow so that we just do everything 
we need under the very first for loop in the function, so I'll refactor it 
accordingly and mail it out. But, I would prefer not to be pontificating over 
syntactic sugar. Anything to do with errors I'll of course happily discuss 
endlessly, so if you believe one still exists, no problem.

My hope was to get a change in that fixes the issue with minimal reorganisation 
of the code flow so that anyone looking at it later on can see, relatively 
quickly, exactly what was done to resolve the issue - if you want to then 
clean up the semantics too, fine, throw that in as a separate commit - that 
also avoids undermining git bisect should the clean-up introduce its own 
errors, somehow.

Kind Regards,
Oliver.
