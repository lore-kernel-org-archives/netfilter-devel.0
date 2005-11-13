From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 1/4] fix leak of fragment queue at unloading
 nf_conntrack_ipv6
Date: Sun, 13 Nov 2005 21:38:36 +0900 (JST)
Message-ID: <200511131238.jADCcbwu004077@toshiba.co.jp>
References: <200511130850.jAD8ohfY012005@toshiba.co.jp>
	<20051113100837.GG17476@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20051113100837.GG17476@sunbeam.de.gnumonks.org>
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


From: Harald Welte <laforge@netfilter.org>
Date: Sun, 13 Nov 2005 11:08:37 +0100

> On Sun, Nov 13, 2005 at 05:50:42PM +0900, Yasuyuki KOZAKAI wrote:
> > 
> > This makes nf_conntrack_ipv6 free all IPv6 fragment queues at unloading.
> > This also check inconsistency between memory tracking and actual usage
> > to avoid endless loop at eviction.
> 
> I'm fine with this, but:
> 
> >  		tmp = nf_ct_frag6_lru_list.next;
> > +		if (tmp == NULL) {
> > +			if (net_ratelimit())
> > +				printk(KERN_ERR
> > +				       "nf_ct_reasm: no queue to be evicted");
> > +			return;
> > +		}
> 
> Why is it an error if we don't have a defrag queue at unloading time?
> Isn't it possible that we never process any fragments (or finished
> processing of all fragments some time ago) and thus have an empty queue?

Sorry for short explanation. This function may be called when memory usage
exceeds threshold. And I just want to be noticed existence of bug
in memory tracking and avoid NULL pointer access.

> If I understand this correctly, it should be a DEBUG message, at most.

OK.

> Please comment.

Is it overly cautions to avoid NULL pointer access in this case ?
Indeed we can notice bug early if we doesn't introduce this check.

-- Yasuyuki kozakai
