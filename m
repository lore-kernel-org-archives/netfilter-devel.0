From: Matt Walters <mattw@parasun.com>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Tue, 17 Aug 2004 13:40:15 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1092775215.22731.1958.camel@marx.mindlink.net>
References: <E1BwO5M-000718-NF@giant.mindlink.net>
	 <1092692707.22731.1687.camel@marx.mindlink.net>
	 <41213777.9050701@trash.net>
	 <1092703243.22731.1778.camel@marx.mindlink.net>
	 <4121E082.6050602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4121E082.6050602@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2004-08-17 at 03:40, Patrick McHardy wrote:
> Matt Walters wrote:
> 
> >On Mon, 2004-08-16 at 15:38, Patrick McHardy wrote:
> >
> >>skb_tailroom should return 0 in this case and the skb should be linearized
> >>by skb_copy_expand already. The check isn't triggered because this line is
> >>wrong:
> >>
> >>diff = v->data_len - e->skb->len
> >>
> >>skb->len is the total length, including fragments. If we want to copy to it,
> >>we either need to linearize it or look at skb_headlen(skb). It's complicated
> >>getting everything right, I need to think about it some more.
> >>    
> >>
> 
> This patch on top of the ip_queue_nonlinear_skbs patch should fix the 
> problem.
> It wastes a couple of bytes when enlarging a non-linear skb, but that 
> shouldn't be
> a problem. When you test it, please try all three possibilities (replace 
> by smaller,
> equally sized and larger packet).

Thanks Patrick-

	A quick test shows that unaltered packets being passed back from
userspace no longer cause kernel panics (yay) but also that they are not
being responded to (boo).  I'll have a look deeper into it later on.

-Matt
