From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
 not
Date: Tue, 13 Sep 2005 18:33:45 +0200
Message-ID: <4326FF69.9060004@trash.net>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>	<20050912.151120.104514011.davem@davemloft.net>	<87br2xap9o.fsf@aka.i.naked.iki.fi> <877jdl9r1u.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964863AbVIMQdx@vger.kernel.org>
To: Nuutti Kotivuori <naked@iki.fi>
In-Reply-To: <877jdl9r1u.fsf@aka.i.naked.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Nuutti Kotivuori wrote:
> 
> Appended here is a backtrace with the tg3 driver. Also, it seems that
> the bug cannot be reproduced with uniprocessor, only SMP.
> 
> Unable to handle kernel NULL pointer dereference at virtual address 00000018

This means inode->i_security was NULL. AFAICT it is only set to NULL in
inode_free_security() when the inode is freed. This shouldn't happen
while the packet is queued since the skb should hold a reference to
the socket on the output path. So it could be some protocol forgetting
to increase the refcnt when taking a reference. What kind of packet
is this? And what kernel version are you running? Until recently
ip_conntrack did some fiddling with skb->sk which could lead to
a packet on the output path with skb->sk set but no reference taken.
