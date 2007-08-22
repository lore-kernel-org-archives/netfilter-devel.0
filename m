From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Kernel oops during netfilter memory allocation
Date: Wed, 22 Aug 2007 17:09:04 +0200
Message-ID: <200708221709.04992.thomas.jarosch@intra2net.com>
References: <200708201808.08880.thomas.jarosch@intra2net.com> <20070820193103.GC2488@martell.zuzino.mipt.ru> <200708211133.56261.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764024AbXHVPJ2@vger.kernel.org>
In-Reply-To: <200708211133.56261.thomas.jarosch@intra2net.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

> > 	kernel BUG at arch/i386/mm/highmem.c:38
> >
> > Try this.

I just tried kernel 2.6.22.4 and 2.6.23-rc3. Using 2.6.23-rc3 vanilla,
the box survives only 3 seconds with ipt_CRASH. Here's the backtrace,
it's only slightly different:

------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:38!
invalid opcode: 0000 [#1]
Modules linked in: ipt_CRASH iptable_filter ip_tables x_tables deflate 
zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkcipher 
aes xcbcd
CPU:    0
EIP:    0060:[<c011401f>]    Not tainted VLI
EFLAGS: 00010286   (2.6.23-rc3 #1)
EIP is at kmap_atomic_prot+0x24/0x83
eax: 0000000c   ebx: c16eba60   ecx: c0002edc   edx: 00000003
esi: 00000163   edi: 00000001   ebp: c16eba60   esp: f75f1b9c
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process info_iponline (pid: 3469, ti=f75f0000 task=f7269ab0 task.ti=f75f0000)
Stack: c16eba60 00000000 c013c695 00000001 00000044 40000000 00000001 00000000
       00028020 c0327a3c c0327648 00000000 00000001 00000000 00000001 00000000
       00008020 00008020 00000000 c0327a38 c013c778 00000044 63d210ac 00000000
Call Trace:
 [<c013c695>] get_page_from_freelist+0x1ed/0x284
 [<c013c778>] __alloc_pages+0x4c/0x282
 [<c013ca31>] get_zeroed_page+0x3c/0x4a
 [<f894e000>] ipt_crash_target+0x0/0x48 [ipt_CRASH]
 [<f894e012>] ipt_crash_target+0x12/0x48 [ipt_CRASH]
 [<f8958331>] ipt_do_table+0x26d/0x2c8 [ip_tables]
 [<c0258484>] nf_iterate+0x38/0x6a
 [<c02585ed>] nf_hook_slow+0x4d/0xb5
 [<c025d1b3>] ip_local_deliver_finish+0x0/0x16b
 [<c025d85c>] ip_local_deliver+0x72/0x1ea
 [<c025d1b3>] ip_local_deliver_finish+0x0/0x16b
 [<c025d7bd>] ip_rcv+0x3fb/0x428
 [<c01287c4>] getnstimeofday+0x2b/0xaf
 [<c0127776>] ktime_get_real+0xf/0x2b
 [<c024540c>] netif_receive_skb+0x219/0x269
 [<f8998fa0>] e1000_clean_rx_irq+0x35a/0x42a [e1000]
 [<f8998c46>] e1000_clean_rx_irq+0x0/0x42a [e1000]
 [<f8997f88>] e1000_clean+0x304/0x4ae [e1000]
 [<c014f745>] get_unused_fd_flags+0x42/0xaa
 [<c0161327>] mntput_no_expire+0x11/0x47
 [<c01580c1>] __link_path_walk+0x83f/0x9de
 [<c01394cc>] do_generic_mapping_read+0x3cd/0x3d5
 [<c02471ff>] net_rx_action+0x52/0xe9
 [<c011b83c>] __do_softirq+0x35/0x75
 [<c011b89e>] do_softirq+0x22/0x26
 [<c0105e8c>] do_IRQ+0x58/0x6c
 [<c0138e42>] find_lock_page+0x12/0x62
 [<c0104573>] common_interrupt+0x23/0x28
 [<c0141996>] __do_fault+0x136/0x2d1
 [<c0142eac>] handle_mm_fault+0x2c5/0x571
 [<c0145665>] vma_merge+0x120/0x178
 [<c0113560>] do_page_fault+0x212/0x58a
 [<c011334e>] do_page_fault+0x0/0x58a
 [<c0292f2a>] error_code+0x6a/0x70
 [<c0290000>] tpacket_rcv+0x142/0x38e
 =======================
Code: 03 05 00 eb 38 c0 c3 56 89 ce 53 89 c3 89 e0 25 00 e0 ff ff ff 40 14 8b 
0d f0 17 38 c0 8d 04 95 00 00 00 00 29 c1 83 39 00 74 04 <0f> 0b eb fe 8b 03
EIP: [<c011401f>] kmap_atomic_prot+0x24/0x83 SS:ESP 0068:f75f1b9c
Kernel panic - not syncing: Fatal exception in interrupt
------------------------------------

Disabling highmem support seems to work as a temporary solution.
Or does it only hide the symptoms of something really going wrong?

Any help is greatly appreciated.

Thomas
