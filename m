From: Matt Walters <mattw@parasun.com>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Mon, 16 Aug 2004 17:40:43 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092703243.22731.1778.camel@marx.mindlink.net>
References: <E1BwO5M-000718-NF@giant.mindlink.net>
	 <1092692707.22731.1687.camel@marx.mindlink.net>
	 <41213777.9050701@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41213777.9050701@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2004-08-16 at 15:38, Patrick McHardy wrote:
> Matt Walters wrote:
> 
> >Greetings, friends-
> >
> >	I've inlined a patch for ip_queue.c (diff -u is the standard
> >patch-o-matic format, right?) which will fix the issue I've been having
> >with large packets coming back from userspace causing kernel panics.  It
> >should probably be added to the nonlinear_skbs patch, since it's the
> >same type of fix (memcpy --> copy_skb_bits).  There's also a
> >storage-type modification for ipq_rcv_skb - skb_len is an unsigned int
> >and it was being stored in an int.
> >
> The skb_copy_bits can't be right. You change skb from being the destination
> to the source. If the skb really is nonlinear, we need to linearize it. But

	..whoops.  Perhaps some sleep is in order.  It seemed like a  success
because (naturally) the test program wasn't mangling the packets...

> skb_tailroom should return 0 in this case and the skb should be linearized
> by skb_copy_expand already. The check isn't triggered because this line is
> wrong:
> 
> diff = v->data_len - e->skb->len
> 
> skb->len is the total length, including fragments. If we want to copy to it,
> we either need to linearize it or look at skb_headlen(skb). It's complicated
> getting everything right, I need to think about it some more.

	Yeah, and for some twisted reason I was figuring on skb_copy_bits to do
that (since it *does* unwind fragment lists, etc).  My apologies for the
waste of bandwidth.

	I'm going to get some sleep and have another look at this later. 
Thanks for the smack on the head.

-Matt
