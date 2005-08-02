From: Mattia Dongili <malattia@gmail.com>
Subject: Re: BUG: atomic counter underflow at
	ip_conntrack_event_cache_init+0x91/0xb0 (with patch)
Date: Tue, 2 Aug 2005 15:29:22 +0200
Message-ID: <20050802132922.GA3834@inferi.kami.home>
References: <20050801141327.GA3909@inferi.kami.home>
	<42EE3169.6070604@trash.net>
	<20050801160537.GA3850@inferi.kami.home>
	<42EE5721.1090509@trash.net> <42EEC2BB.3020105@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42EEC2BB.3020105@trash.net>
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

On Tue, Aug 02, 2005 at 02:47:55AM +0200, Patrick McHardy wrote:
> Patrick McHardy wrote:
> > Mattia Dongili wrote:
[...]
> This should be a fist step towards fixing it. It's probably incomplete
> (I'm too tired to check it now), but it should fix the problem you're
> seeing. Could you give it a spin?

Done, also this patch fixes the uderflow problem.

> BTW, ip_ct_iterate_cleanup can only be called from ipt_MASQUERADE when
> a device goes down. It seems a bit odd that this is happending on boot,
> is there anything special about your setup?

So I played a little more with the BUGgy kernel and I traked some simple
actions to trigger the underflow:

0- boot at init 1

1- modprobe ipt_MASQUERADE
Netfilter messages via NETLINK v0.30.
ip_conntrack version 2.3 (2044 buckets, 16352 max) - 252 bytes per conntrack
ip_tables: (C) 2000-2002 Netfilter core team

2- ifup eth0
e100: eth0: e100_watchdog: link up, 10Mbps, half-duplex
BUG: atomic counter underflow at:
 [<d0c6738a>] ip_ct_iterate_cleanup+0xfa/0x100 [ip_conntrack]
 [<d0c441d3>] masq_inet_event+0x33/0x40 [ipt_MASQUERADE]
 [<d0c441e0>] device_cmp+0x0/0x40 [ipt_MASQUERADE]
 [<c012733d>] notifier_call_chain+0x2d/0x50
 [<c02bea43>] inet_del_ifa+0x93/0x1d0
 [<c02bf6af>] devinet_ioctl+0x4af/0x5a0
 [<c02c1946>] inet_ioctl+0x66/0xb0
 [<c0278be9>] sock_ioctl+0xc9/0x230
 [<c016df2e>] do_ioctl+0x8e/0xa0
 [<c02d5e08>] do_page_fault+0x188/0x613
 [<c016e0f5>] vfs_ioctl+0x65/0x1f0
 [<c016e2c5>] sys_ioctl+0x45/0x70
 [<c0103185>] syscall_call+0x7/0xb

3- ifdown eth0 && ifup eth0
e100: eth0: e100_watchdog: link up, 10Mbps, half-duplex
BUG: atomic counter underflow at:
 [<d0c6738a>] ip_ct_iterate_cleanup+0xfa/0x100 [ip_conntrack]
 [<d0c441d3>] masq_inet_event+0x33/0x40 [ipt_MASQUERADE]
 [<d0c441e0>] device_cmp+0x0/0x40 [ipt_MASQUERADE]
 [<c012733d>] notifier_call_chain+0x2d/0x50
 [<c02bea43>] inet_del_ifa+0x93/0x1d0
 [<c02bf6af>] devinet_ioctl+0x4af/0x5a0
 [<c02c1946>] inet_ioctl+0x66/0xb0
 [<c0278be9>] sock_ioctl+0xc9/0x230
 [<c016df2e>] do_ioctl+0x8e/0xa0
 [<c02d5e08>] do_page_fault+0x188/0x613
 [<c016e0f5>] vfs_ioctl+0x65/0x1f0
 [<c016e2c5>] sys_ioctl+0x45/0x70
 [<c0103185>] syscall_call+0x7/0xb

and that's all. So iflugd has not any influence here.
-- 
mattia
:wq!
