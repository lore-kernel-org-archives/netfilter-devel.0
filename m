From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Tue, 11 Oct 2005 07:22:48 +1000
Message-ID: <1128979368.8218.8.camel@localhost.localdomain>
References: <1128536584.9868.1.camel@localhost.localdomain>
	<200510071227.j97CRrgx027931@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200510071227.j97CRrgx027931@toshiba.co.jp>
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

On Fri, 2005-10-07 at 21:27 +0900, Yasuyuki KOZAKAI wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Thu, 06 Oct 2005 04:23:03 +1000
> 
> > +static u_int32_t
> > +hash_conntrack(const struct ip_conntrack_tuple *tuple)
> > +{
> > +	return __hash_conntrack(tuple, ip_conntrack_htable_size);
> >  }
> 
> Why don't we use inline ?

Just checking you were reading.  Well done, Yasuyuki!

We should use "u32", too, not those types I made the mistake of using
when I was young and foolish.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
