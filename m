From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: The latest nf_conntrack
Date: Thu, 11 Nov 2004 06:51:23 +0900 (JST)
Message-ID: <200411102151.iAALpOKa016683@toshiba.co.jp>
References: <200411010827.iA18RJGT024881@toshiba.co.jp>
	<20041108134709.GE12437@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20041108134709.GE12437@sunbeam.de.gnumonks.org>
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


Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Mon, 8 Nov 2004 14:47:09 +0100

> I allowed myself to commit a minor modification:  The include path for
> new header files is <linux/netfilter/ipv4> instead of
> <linux/netfilter_ipv4>.  Old headers stay at their current position, but
> I think in the end (after nf_conntrack is merged) they should be moved
> too (and we just provide dummy include files that include the new files
> for backwards compatibility).  

OK.

> > And I re-implemented handling fragmented IPv6 packets. This code is what
> > I imagined after workshop, but I recently found that my idea is different
> > with the results of discussion at workshop. Then I may change some parts.
> 
> Which differences are you talking about?  Is it that you pass the
> individual fragments instead of the refreagmented packet?

Yes,

>                                                           I think we
> were undecided at the workshop about what to do, so it's not really a
> difference from the proposed solution ;)

OK, I look like misunderstanding.

> > By this processing,
> > 	1. We can prevent disturbing IPv6 stack. If we introduce
> > 	   ip_conntrack style, and when large fragmented packets came in,
> > 	   "Too big" isn't sent. Instead, resized fragmented packets are
> > 	   forwarded. That isn't natural.
>
> yes.  I think it is even worth to change nf_conntrack_ipv4 to do it the
> same way as ipv6 now does it.  But let's not change too many things at
> the same time,

Sounds good and it's challenging because we have to consider about IPv4 NAT.

> > comments ?
> 
> I again have to congratulate you on your work.  I think nf_conntrack was
> not an easy task, and you managed very well, especially without any strong
> previous netfilter development background.  Thanks also to USAGI and
> Toshiba for enabling you to contribute this work.
> 
> Let me give it some testing.  Maybe I even get around doing some
> benchmarking of ip_conntrack versus nf_conntrack, just to get an idea
> how big the performance impact of the generalization is.
> 
> If everything goes well, I think we can merge in one to two weeks!

Great! I think it's better to test more before merging.
I may forget some changes of ip_conntrack. Actually, I found a missing
code for marking and fixed today.

By the way, could you check copyright and so on ? I have no idea about
the correct way. At least, nf_conntrack_l3proto_ipv6.c is written from scratch
and has no problem, I think.

And please note that I applied some patches from Michal to add some changes
for ip_conntrack in linux 2.6.9. His Signed-off-by is following.

	Signed-off-by: Michal Rokos <michal@rokos.info>

But as you know, these changes are mixed in nf_conntrack of pom-ng
and I don't have trees just before/after applying them.

And a lot codes are copied from ip_conntrack, I suspects that we can
enumerate all Signed-off-by. How we should manage this ?

> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
