From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq, kernel panics/oopses, and other undesirable traits
Date: Tue, 17 Aug 2004 00:38:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41213777.9050701@trash.net>
References: <E1BwO5M-000718-NF@giant.mindlink.net> <1092692707.22731.1687.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Walters <mattw@parasun.com>
In-Reply-To: <1092692707.22731.1687.camel@marx.mindlink.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matt Walters wrote:

>Greetings, friends-
>
>	I've inlined a patch for ip_queue.c (diff -u is the standard
>patch-o-matic format, right?) which will fix the issue I've been having
>with large packets coming back from userspace causing kernel panics.  It
>should probably be added to the nonlinear_skbs patch, since it's the
>same type of fix (memcpy --> copy_skb_bits).  There's also a
>storage-type modification for ipq_rcv_skb - skb_len is an unsigned int
>and it was being stored in an int.
>
The skb_copy_bits can't be right. You change skb from being the destination
to the source. If the skb really is nonlinear, we need to linearize it. But
skb_tailroom should return 0 in this case and the skb should be linearized
by skb_copy_expand already. The check isn't triggered because this line is
wrong:

diff = v->data_len - e->skb->len

skb->len is the total length, including fragments. If we want to copy to it,
we either need to linearize it or look at skb_headlen(skb). It's complicated
getting everything right, I need to think about it some more.

Regards
Patrick
