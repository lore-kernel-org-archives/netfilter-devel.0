From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Kernel oops during netfilter memory allocation
Date: Tue, 21 Aug 2007 11:33:55 +0200
Message-ID: <200708211133.56261.thomas.jarosch@intra2net.com>
References: <200708201808.08880.thomas.jarosch@intra2net.com>
	<20070820193103.GC2488@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070820193103.GC2488@martell.zuzino.mipt.ru>
Content-Disposition: inline
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

On Monday, 20. August 2007, Alexey Dobriyan wrote:
> 	kernel BUG at arch/i386/mm/highmem.c:38
>
> Try this.
>
> commit b8c1c5da1520977cb55a358f20fc09567d40cad9
> tree c762e6ad77297beed0978337ce2f5b0c50add739
> parent 01e457cfcd5b6b6f18d0bb8cec0c5d43df56557e
> author Andrew Morton <akpm@linux-foundation.org> 1185303760 -0700
> committer Linus Torvalds <torvalds@woody.linux-foundation.org> 1185305099
> -0700
>
> slab: correctly handle __GFP_ZERO
>
> Use the correct local variable when calling into the page allocator.  Local
> `flags' can have __GFP_ZERO set, which causes us to pass __GFP_ZERO into
> the page allocator, possibly from illegal contexts.  The page allocator
> will later do prep_zero_page()->kmap_atomic(..., KM_USER0) from irq
> contexts and will then go BUG.

Thanks for the patch. Unfortunately it didn't cure the problem.
After some searching I found one of those rare serial port brackets
in the attic, so I am now able to get a dump from the serial console.

Here's the output with the patch applied:

------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:38!
invalid opcode: 0000 [#1]
Modules linked in: ipt_CRASH(U) deflate zlib_deflate twofish twofish_common 
serpent blowfish des cbc ecb blkcipher aes xcbc sha256 crypto_null xfrm_user 
xfrm4_tunnel tunnel4 ipcomp esp4 ah4 af_key dummy tg3 e1000 iptable_mangle 
ipt_iprange xt_CONNMARK ipt_REDIRECT ipt_MASQUERADE iptable_nat xt_conntrack 
xt_connmark ipt_LOG xt_limit xt_TCPMSS ipt_REJECT ipt_recent 
nf_conntrack_ipv4 xt_state ipt_ACCOUNT xt_tcpudp xt_condition xt_policy 
xt_multiport iptable_filter ip_tables x_tables nf_nat_tftp nf_nat_sip 
nf_nat_irc nf_nat_pptp nf_nat_proto_gre nf_nat_ftp nf_nat nf_conntrack_tftp 
nf_conntrack_socks nf_conntrack_sip nf_conntrack_irc nf_conntrack_pptp 
nf_conntrack_proto_gre nf_conntrack_ftp nf_conntrack nfnetlink ext3 jbd 
mbcache reiserfs sr_mod cdrom sg ata_piix libata generic
CPU:    0
EIP:    0060:[<c0114425>]    Not tainted VLI
EFLAGS: 00010286   (2.6.21-1.i2n #4)
EIP is at kmap_atomic+0x24/0x88
eax: 0000000c   ebx: c0002ee4   ecx: c16fa5e0   edx: 00000003
esi: 00000003   edi: 00000001   ebp: c16fa5e0   esp: f7723a98
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process pop3.monitor (pid: 3015, ti=f7722000 task=dfdc3530 task.ti=f7722000)
Stack: c16fa5e0 00000000 c013c01b 00000001 00000044 00000044 00000001 00000000
       00028220 c036dea4 c036dc04 00000000 00000001 f7723b78 00000001 00000286
       00008220 00008220 c036dea0 dfdc3530 c013c0fa 00000044 00000002 f79da4b4
Call Trace:
 [<c013c01b>] get_page_from_freelist+0x1e6/0x273
 [<c013c0fa>] __alloc_pages+0x52/0x286
 [<f8890194>] nf_conntrack_tcp_update+0x1068/0x10e8 [nf_conntrack]
 [<c013c394>] get_zeroed_page+0x2c/0x3a
 [<f89f8000>] ipt_crash_target+0x0/0x48 [ipt_CRASH]
 [<f89f8012>] ipt_crash_target+0x12/0x48 [ipt_CRASH]
 [<f893b360>] ipt_do_table+0x27b/0x2d3 [ip_tables]
 [<c029085c>] nf_iterate+0x38/0x6a
 [<c0290986>] nf_hook_slow+0x4d/0xb5
 [<c0295336>] ip_local_deliver_finish+0x0/0x166
 [<c0295983>] ip_local_deliver+0x6f/0x1e0
 [<c0295336>] ip_local_deliver_finish+0x0/0x166
 [<c02958e7>] ip_rcv+0x3ad/0x3da
 [<c0295140>] ip_rcv_finish+0x0/0x1f6
 [<c027f42c>] netif_receive_skb+0x217/0x260
 [<c027ba46>] __alloc_skb+0x49/0xf7
 [<f89b4f8c>] e1000_read_pci_cfg+0x5eb/0x1903 [e1000]
 [<f89b4c42>] e1000_read_pci_cfg+0x2a1/0x1903 [e1000]
 [<f89b3f8f>] e1000_reinit_locked+0x1aba/0x24cc [e1000]
 [<c013c0fa>] __alloc_pages+0x52/0x286
 [<f89f8000>] ipt_crash_target+0x0/0x48 [ipt_CRASH]
 [<c0280a80>] net_rx_action+0x52/0x10e
 [<c011ae94>] __do_softirq+0x35/0x75
 [<c011aef6>] do_softirq+0x22/0x26
 [<c01061ef>] do_IRQ+0x5c/0x71
 [<c010460f>] common_interrupt+0x23/0x28
 [<c01a31be>] __copy_to_user_ll+0xcb/0xd6
 [<c01384f4>] file_read_actor+0x6b/0xca
 [<c0138c48>] do_generic_mapping_read+0x172/0x40a
 [<c013a90a>] generic_file_aio_read+0x150/0x182
 [<c0138489>] file_read_actor+0x0/0xca
 [<c0157b18>] do_path_lookup+0x14a/0x19a
 [<c015156b>] get_empty_filp+0x4f/0xcc
 [<c0150613>] do_sync_read+0xc7/0x10a
 [<c0125574>] autoremove_wake_function+0x0/0x35
 [<c0107979>] sys_mmap2+0x6f/0xb7
 [<c015054c>] do_sync_read+0x0/0x10a
 [<c0150d76>] vfs_read+0x88/0x10a
 [<c0151098>] sys_read+0x41/0x67
 [<c0103c66>] syscall_call+0x7/0xb
 =======================
Code: c8 e9 f9 c4 02 00 c3 56 89 c1 53 89 d6 89 e0 25 00 e0 ff ff ff 40 14 8b 
1d b4 f7 3e c0 8d 04 95 00 00 00 00 29 c3 83 3b 00 74 04 <0f> 0b eb fe 8b 01 
c1 e8 1e 69 c0 44 01 00 00 05 c0 da 36 c0 8b
EIP: [<c0114425>] kmap_atomic+0x24/0x88 SS:ESP 0068:f7723a98
Kernel panic - not syncing: Fatal exception in interrupt
------------------------------------


I've replaced the Intel e1000 card with a bulk Realtek 8139 card just to make 
sure it's not related to the e1000 driver. Here's the backtrace:

------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:38!
invalid opcode: 0000 [#1]
Modules linked in: ipt_CRASH(U) iptable_filter ip_tables x_tables 8139too mii 
deflate zlib_deflate twofish twofish_common serpent blowfish des cbc ecb blkc
CPU:    0
EIP:    0060:[<c0114425>]    Not tainted VLI
EFLAGS: 00010286   (2.6.21-1.i2n #4)
EIP is at kmap_atomic+0x24/0x88
eax: 0000000c   ebx: c0002ee4   ecx: c167b2c0   edx: 00000003
esi: 00000003   edi: 00000001   ebp: c167b2c0   esp: f7a73c74
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process imap.monitor (pid: 3181, ti=f7a72000 task=dfc8ea30 task.ti=f7a72000)
Stack: c167b2c0 00000000 c013c01b 00000001 00000044 00000002 00000001 00000000
       00028220 c036dea4 c036dc04 00000000 00000001 00000000 00000001 dfdfde40
       00008220 00008220 c036dea0 dfc8ea30 c013c0fa 00000044 c013c0fa 00000044
Call Trace:
 [<c013c01b>] get_page_from_freelist+0x1e6/0x273
 [<c013c0fa>] __alloc_pages+0x52/0x286
 [<c013c0fa>] __alloc_pages+0x52/0x286
 [<c013a66b>] filemap_nopage+0x156/0x2a5
 [<c013c394>] get_zeroed_page+0x2c/0x3a
 [<f8933000>] ipt_crash_target+0x0/0x48 [ipt_CRASH]
 [<f8933012>] ipt_crash_target+0x12/0x48 [ipt_CRASH]
 [<f893b360>] ipt_do_table+0x27b/0x2d3 [ip_tables]
 [<c029085c>] nf_iterate+0x38/0x6a
 [<c0290986>] nf_hook_slow+0x4d/0xb5
 [<c0295336>] ip_local_deliver_finish+0x0/0x166
 [<c0295983>] ip_local_deliver+0x6f/0x1e0
 [<c0295336>] ip_local_deliver_finish+0x0/0x166
 [<c02958e7>] ip_rcv+0x3ad/0x3da
 [<c027f42c>] netif_receive_skb+0x217/0x260
 [<c027ba46>] __alloc_skb+0x49/0xf7
 [<f8a4540c>] init_module+0xc140c/0xc22b0 [8139too]
 [<c0280a80>] net_rx_action+0x52/0x10e
 [<c011ae94>] __do_softirq+0x35/0x75
 [<c011aef6>] do_softirq+0x22/0x26
 [<c01061ef>] do_IRQ+0x5c/0x71
 [<c010460f>] common_interrupt+0x23/0x28
 [<c0142282>] __handle_mm_fault+0x1aa/0x7a6
 [<c0113922>] do_page_fault+0x20d/0x4d3
 [<c0113715>] do_page_fault+0x0/0x4d3
 [<c02ca89c>] error_code+0x74/0x7c
 =======================
Code: c8 e9 f9 c4 02 00 c3 56 89 c1 53 89 d6 89 e0 25 00 e0 ff ff ff 40 14 8b 
1d b4 f7 3e c0 8d 04 95 00 00 00 00 29 c3 83 3b 00 74 04 <0f> 0b eb fe 8b 01
EIP: [<c0114425>] kmap_atomic+0x24/0x88 SS:ESP 0068:f7a73c74
Kernel panic - not syncing: Fatal exception in interrupt
------------------------------------

I can't trigger the bug by force if I boot the system with mem=512m.

Anything I could try?

Thomas
