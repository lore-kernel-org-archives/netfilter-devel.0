From: Patrick McHardy <kaber@trash.net>
Subject: Re: BUG: atomic counter underflow at ip_conntrack_event_cache_init+0x91/0xb0
 (with patch)
Date: Mon, 01 Aug 2005 19:08:49 +0200
Message-ID: <42EE5721.1090509@trash.net>
References: <20050801141327.GA3909@inferi.kami.home> <42EE3169.6070604@trash.net> <20050801160537.GA3850@inferi.kami.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Harald Welte <laforge@netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262276AbVHARIz@vger.kernel.org>
To: Mattia Dongili <malattia@gmail.com>
In-Reply-To: <20050801160537.GA3850@inferi.kami.home>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mattia Dongili wrote:
> On Mon, Aug 01, 2005 at 04:27:53PM +0200, Patrick McHardy wrote:
> 
>>>--- include/linux/netfilter_ipv4/ip_conntrack.h.clean	2005-08-01 15:09:49.000000000 +0200
>>>+++ include/linux/netfilter_ipv4/ip_conntrack.h	2005-08-01 15:08:52.000000000 +0200
>>>@@ -298,6 +298,7 @@ static inline struct ip_conntrack *
>>> ip_conntrack_get(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
>>> {
>>> 	*ctinfo = skb->nfctinfo;
>>>+	nf_conntrack_get(skb->nfct);
>>> 	return (struct ip_conntrack *)skb->nfct;
>>> }
>>
>>This creates lots of refcnt leaks, which is probably why it makes the
>>underflow go away :) Please try this patch instead.
> 
> 
> this doesn't fix it actually, see dmesg below:

It looks like ip_ct_iterate_cleanup and ip_conntrack_event_cache_init
race against each other with assigning pointers and grabbing/putting the
refcounts if called from different contexts.

> While testing my patch I had the below error, is it related to the
> refcount leak or might it be a different issue?
> 
> ctevent: skb->ct != ecache->ct !!!
>  [<d0c6e4e8>] tcp_packet+0x278/0x5d0 [ip_conntrack]
>  [<d0c6b697>] __ip_conntrack_find+0x17/0xb0 [ip_conntrack]
>  [<d0c6b782>] ip_conntrack_find_get+0x52/0x60 [ip_conntrack]
>  [<d0c6c33f>] ip_conntrack_in+0xef/0x2f0 [ip_conntrack]
>  [<c029e420>] dst_output+0x0/0x30
>  [<c028ef38>] nf_iterate+0x78/0x90
>  [<c029e420>] dst_output+0x0/0x30
>  [<c029e420>] dst_output+0x0/0x30
>  [<c028f42e>] nf_hook_slow+0x7e/0x150
>  [<c029e420>] dst_output+0x0/0x30
>  [<c029c313>] ip_queue_xmit+0x403/0x570
>  [<c029e420>] dst_output+0x0/0x30
>  [<c022185a>] extract_buf+0xda/0x120
>  [<c02b1c05>] tcp_v4_send_check+0x55/0x100
>  [<c02ab818>] tcp_transmit_skb+0x478/0x720
>  [<c02ac890>] tcp_write_xmit+0x150/0x3f0
>  [<c02acb69>] __tcp_push_pending_frames+0x39/0xd0
>  [<c02a1226>] tcp_sendmsg+0x346/0xb70
>  [<c02c16ed>] inet_sendmsg+0x4d/0x60
>  [<c0278886>] sock_aio_write+0xf6/0x120
>  [<c015a381>] do_sync_write+0xd1/0x120
>  [<c0150439>] page_add_file_rmap+0x59/0x70
>  [<c014b43c>] handle_mm_fault+0xfc/0x250
>  [<c012f060>] autoremove_wake_function+0x0/0x60
>  [<c015a53d>] vfs_write+0x16d/0x180
>  [<c015a621>] sys_write+0x51/0x80
>  [<c0103185>] syscall_call+0x7/0xb

It could happen if the output path of a locally generated packet was
interrupted by a softirq, which would make the event cache point to a
different conntrack when it is resumed. But this doesn't happen in your
case, I don't understand how this happened.
