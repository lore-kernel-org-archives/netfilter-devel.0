From: Phil Oester <kernel@linuxace.com>
Subject: Re: Deadlocks
Date: Mon, 14 Jun 2004 21:47:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040615044723.GA16891@linuxace.com>
References: <20040609180909.GA11445@linuxace.com> <1087156709.11287.8.camel@ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <1087156709.11287.8.camel@ws>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I agree I am likely experiencing the deadlock you refer to:

CPU1:
conntrack-helper:help: lock(private_lock)
ip_conntrack_expect_related: write_lock(ip_conntrack_lock)

CPU2:
nat-core:do_bindings: read_lock(ip_conntrack_lock)
nat-helper:help: lock(private_lock)

However, it's unclear to me that the ip_ftp_lock can be trivially eliminated.

This code path looks particularly prickly in ip_nat_ftp.c:

help
  ftp_data_fixup
    ip_conntrack_change_expect

so the nat helper is changing the expectation -- potentially at the same time
the conntrack helper is calling ip_conntrack_expect.  If the private lock
were removed, could this not cause a race condition if the expectation got
created just after the nat-helper changed the expectation?  

It seems the ip_ftp_lock is needed, but perhaps needs to be reworked to avoid
the deadlock condition illustrated above.

Thoughts?

Phil


On Sun, Jun 13, 2004 at 09:58:29PM +0200, Patrick McHardy wrote:
> On Wed, 2004-06-09 at 20:09, Phil Oester wrote:
> > For the past 3 months I've been experiencing deadlocks on some heavily
> > used gateway/firewall boxes which started after upgrading from 2.4.20.
> > 
> > I can confirm that moving back to 2.4.20 stops the hangs, moving to 2.4.21
> > (or any kernel after that) makes them return.  I am in the process of testing
> > out each individual 2.4.21-pre to find out where exactly the problem is.
> > 
> > In the interim, I've collected some SysRq output which may help in the
> > analysis.  Below are two separate lockups on a 2.6.6 kernel.  Anyone have
> > any bright ideas?
> 
> This looks like the problem I described a couple of month ago:
> http://lists.netfilter.org/pipermail/netfilter-devel/2003-November/013130.html
> I went through the 2.4.21 patch, but couldn't find anything that looks
> related to this. The patch attached to the email above should apply to
> something around 2.4.23. Please also enable CONFIG_NETFILTER_DEBUG, so
> we can see where exactly the problem occurs.
> 
> Regards
> Patrick
> 
> > 
> > Phil Oester
> > 
> > 
> > Lockup #1:
> > Pid: 0, comm:              swapper
> > EIP: 0060:[<c024a3e7>] CPU: 1
> > EIP is at __write_lock_failed+0xf/0x20
> >  EFLAGS: 00000287    Not tainted  (2.6.6)
> > EAX: c0283360 EBX: ffffffff ECX: 7d9d14aa EDX: ee83c1e0
> > ESI: f454b910 EDI: ffffffff EBP: 0000007d DS: 007b ES: 007b
> > CR0: 8005003b CR2: 08076ac4 CR3: 37b34000 CR4: 00000690
> > Call Trace:
> >  [<c0237f28>] .text.lock.ip_conntrack_core+0x7d/0xd5
> >  [<c023cf6d>] do_bindings+0x8d/0x260
> >  [<c0238855>] try_rfc959+0x25/0x30
> >  [<c0238dd7>] help+0x2f7/0x430
> >  [<c0238830>] try_rfc959+0x0/0x30
> >  [<c0238251>] tcp_packet+0xd1/0x160
> >  [<c0236ea0>] ip_conntrack_in+0x100/0x220
> >  [<c01fd182>] nf_iterate+0x72/0xb0
> >  [<c0205fc0>] ip_rcv_finish+0x0/0x245
> >  [<c01fd468>] nf_hook_slow+0x78/0x110
> >  [<c0205fc0>] ip_rcv_finish+0x0/0x245
> >  [<c0205da1>] ip_rcv+0x3c1/0x480
> >  [<c0205fc0>] ip_rcv_finish+0x0/0x245
> >  [<c01effe2>] alloc_skb+0x32/0xd0
> >  [<c01f4d72>] netif_receive_skb+0x162/0x190
> >  [<c01c9889>] e1000_clean_rx_irq+0x399/0x410
> >  [<c01c9244>] e1000_clean+0x34/0xb0
> >  [<c01f4f3f>] net_rx_action+0x7f/0x110
> >  [<c011ae84>] __do_softirq+0xb4/0xc0
> >  [<c0106b9c>] do_softirq+0x4c/0x60
> >  =======================
> >  [<c0106275>] do_IRQ+0x145/0x180
> >  [<c010467c>] common_interrupt+0x18/0x20
> >  [<c0101e20>] default_idle+0x0/0x40
> >  [<c0101e4c>] default_idle+0x2c/0x40
> >  [<c0101edb>] cpu_idle+0x3b/0x50
> >  [<c01177b7>] __call_console_drivers+0x57/0x60
> >  [<c01178af>] call_console_drivers+0x7f/0x100
> > 
> > 
> > Lockup #2:
> > Pid: 0, comm:              swapper
> > EIP: 0060:[<c0261bd0>] CPU: 0
> > EIP is at .text.lock.ip_nat_ftp+0x19/0x29
> >  EFLAGS: 00000286    Not tainted  (2.6.6)
> > EAX: 00000001 EBX: c0306000 ECX: d31c3034 EDX: eaeb8ac0
> > ESI: 00000019 EDI: eaeb8a48 EBP: c0306d24 DS: 007b ES: 007b
> > CR0: 8005003b CR2: 4024f0ec CR3: 31515000 CR4: 00000690
> > Call Trace:
> >  [<c0260592>] tcp_exp_matches_pkt+0x32/0x79
> >  [<c0266e5f>] do_bindings+0x34f/0x570
> >  [<c0264c17>] ip_nat_fn+0x77/0x310
> >  [<c021f0be>] nf_iterate+0x6e/0xc0
> >  [<c022dcb0>] ip_finish_output2+0x0/0x1cb
> >  [<c021f406>] nf_hook_slow+0x86/0x150
> >  [<c022dcb0>] ip_finish_output2+0x0/0x1cb
> >  [<c022b8b3>] ip_finish_output+0x43/0x50
> >  [<c022dcb0>] ip_finish_output2+0x0/0x1cb
> >  [<c022a47c>] ip_forward_finish+0x2c/0x50
> >  [<c021f45a>] nf_hook_slow+0xda/0x150
> >  [<c022a450>] ip_forward_finish+0x0/0x50
> >  [<c022a3b7>] ip_forward+0x137/0x1d0
> >  [<c022a450>] ip_forward_finish+0x0/0x50
> >  [<c02290b8>] ip_rcv_finish+0x1e8/0x25d
> >  [<c021f0be>] nf_iterate+0x6e/0xc0
> >  [<c0228ed0>] ip_rcv_finish+0x0/0x25d
> >  [<c021f45a>] nf_hook_slow+0xda/0x150
> >  [<c0228ed0>] ip_rcv_finish+0x0/0x25d
> >  [<c0228cad>] ip_rcv+0x18d/0x240
> >  [<c0228ed0>] ip_rcv_finish+0x0/0x25d
> >  [<c0215a14>] netif_receive_skb+0x174/0x1a0
> >  [<c01e60f8>] e1000_clean_rx_irq+0x3d8/0x490
> >  [<c01e5a2c>] e1000_clean+0x3c/0xb0
> >  [<c0215bf0>] net_rx_action+0x90/0x130
> >  [<c011f204>] __do_softirq+0xb4/0xc0
> >  [<c010764f>] do_softirq+0x4f/0x60
> >  =======================
> >  [<c0106979>] do_IRQ+0x1a9/0x260
> >  [<c011091c>] smp_apic_timer_interrupt+0xcc/0x130
> >  [<c0104bb0>] common_interrupt+0x18/0x20
> >  [<c0102150>] default_idle+0x0/0x40
> >  [<c010217f>] default_idle+0x2f/0x40
> >  [<c010220b>] cpu_idle+0x3b/0x50
> >  [<c02d7520>] unknown_bootoption+0x0/0x120
> >  [<c02d7943>] start_kernel+0x173/0x1c0
> >  [<c02d7520>] unknown_bootoption+0x0/0x120
> > 
> > 
> 
> 
