From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Tue, 13 Sep 2005 21:22:07 +0300
Message-ID: <873bo8akvk.fsf@aka.i.naked.iki.fi>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>
	<20050912.151120.104514011.davem@davemloft.net>
	<87br2xap9o.fsf@aka.i.naked.iki.fi>
	<877jdl9r1u.fsf@aka.i.naked.iki.fi> <4326FF69.9060004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4326FF69.9060004@trash.net> (Patrick McHardy's message of "Tue,
	13 Sep 2005 18:33:45 +0200")
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

Patrick McHardy wrote:
> Nuutti Kotivuori wrote:
>>
>> Appended here is a backtrace with the tg3 driver. Also, it seems that
>> the bug cannot be reproduced with uniprocessor, only SMP.
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 00000018
>
> This means inode->i_security was NULL. AFAICT it is only set to NULL in
> inode_free_security() when the inode is freed. This shouldn't happen
> while the packet is queued since the skb should hold a reference to
> the socket on the output path. So it could be some protocol forgetting
> to increase the refcnt when taking a reference.

Right.

> What kind of packet is this? And what kernel version are you
> running? Until recently ip_conntrack did some fiddling with skb->sk
> which could lead to a packet on the output path with skb->sk set but
> no reference taken.

This happens on Red Hat Enterprise Linux 4, with a 2.6.9 kernel (with
a gazillion of Red Hat patches in it, latest ones being from 2.6.11)
and the ip_queue patch that adds the bottom-half disabling. I will
know for sure tomorrow, but it seems that it doesn't appear on vanilla
2.6.13.1 or without SMP.

It is very hard to know which packet specifically triggers this. The
machine is under heavy load in general, a lot of packets are handled
via a QUEUE target, and some packets are captured via packet socket.

I will post more details tomorrow, but if you could point me towards
the changes in ip_conntrack that affected this, it would be very
helpful. I could check if they are in the Red Hat kernel and if not,
patch them manually and see if it makes a difference. The problem is
now reproduciable in a couple hours, so it shouldn't be too hard.

Thanks,
-- Naked
