From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Fri, 16 Sep 2005 16:38:16 +0300
Message-ID: <871x3p875j.fsf@aka.i.naked.iki.fi>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>
	<20050912.151120.104514011.davem@davemloft.net>
	<87br2xap9o.fsf@aka.i.naked.iki.fi>
	<877jdl9r1u.fsf@aka.i.naked.iki.fi> <4326FF69.9060004@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Just to reiterate, I still haven't been able to reproduce this on the
mainline kernel, only with RHEL 4 kernels. So if you want to skip
this, that's fine.

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
> to increase the refcnt when taking a reference. What kind of packet
> is this? And what kernel version are you running? Until recently
> ip_conntrack did some fiddling with skb->sk which could lead to
> a packet on the output path with skb->sk set but no reference taken.

I finally managed to add enough debug dumps to find out what packet it
is. It is a TCP FIN,ACK packet, going outwards, originating from the
machine which crashes. It seems that the TCP FIN,ACK packet get sent
outwards, is caught by the QUEUE target in netfilter, goes to
userspace, comes back, continues onwards, gets rejected by the filter
rule in packet socket and then hits the selinux outbound handler and
at that point, the socket has been freed, so it crashes. Atleast this
is my understanding at the moment. This all is very confusing, though.

-- Naked
