From: Tim Burress <tim@variosecure.net>
Subject: Kernel Oops in 2.4.33.3 GRE Conntrack Code
Date: Wed, 13 Dec 2006 20:36:12 +0900
Message-ID: <457FE5AC.3080902@variosecure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Just thought I would report this in case others have seen similar
behavior or have any helpful ideas. The oops occurs very rarely on a
uniprocessor machine configured as a router. Lots of PPTP traffic is
flowing through, which apparently engages the GRE protocol code in
conntrack.

The issue seems to be here:

-----------------------------------------------------------------------
void ip_ct_gre_keymap_destroy(struct ip_conntrack_expect *exp)
{
        DEBUGP("entering for exp %p\n", exp);
        WRITE_LOCK(&ip_ct_gre_lock);
        if (exp->proto.gre.keymap_orig) {
                DEBUGP("removing %p from list\n",
exp->proto.gre.keymap_orig);
                list_del(&exp->proto.gre.keymap_orig->list); <========
                kfree(exp->proto.gre.keymap_orig);
                exp->proto.gre.keymap_orig = NULL;
        }
        if (exp->proto.gre.keymap_reply) {
                DEBUGP("removing %p from list\n",
exp->proto.gre.keymap_reply);
                list_del(&exp->proto.gre.keymap_reply->list);
                kfree(exp->proto.gre.keymap_reply);
                exp->proto.gre.keymap_reply = NULL;
        }
        WRITE_UNLOCK(&ip_ct_gre_lock);
}
-----------------------------------------------------------------------

At the point where list_del() is called, the list component of the
keymap structure has already been zeroed out (the prev and next pointers
are zero). Apparently there's an implicit assumption that if the keymap
structure exists, it's linked into the list (i.e. next and prev are
valid pointers), but on rare occasions that assumption is wrong. Perhaps
there is another thread operating on the keymap structure without taking
ip_ct_gre_lock?

Here's the output from ksymoops. I'm not sure why the two modules aren't
found... they're there... but the machine code at the end of the oops
matches the list_del() call in the C code, so I assume that much is, at
least, correct:

-----------------------------------------------------------------------
ksymoops 2.4.9 on i686 2.4.33.3.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.4.33.3/ (default)
     -m system (specified)

Error (expand_objects): cannot stat(/modules/loop.o) for loop
ksymoops: No such file or directory
Error (expand_objects): cannot stat(/modules/awa692wd.o) for awa692wd
ksymoops: No such file or directory
Warning (map_ksym_to_module): cannot match loaded module awa692wd to a
unique module object.  Trace may not be reliable.
Unable to handle kernel NULL pointer dereference at virtual address 00000004
*pde = 00000000
Oops: 0002
CPU:    0
EIP:    0010:[<e02a135b>]    Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010282
eax: 00000000   ebx: c03f4000   ecx: de472654   edx: 00000000
esi: d4e9b58c   edi: d2f85eb4   ebp: de403a34   esp: c03f5c40
ds: 0018   es: 0018   ss: 0018
Process swapper (pid: 0, stackpage=c03f5000)
Stack: d4e9b58c d2f85e54 e02a3111 6018acd2 de403a48 00000094 e02a3574
c03f5d90
00000001 d2f85f08 00000001 00000094 d2f85e54 00000001 010aa8c0 c03eec00
c03f5d90 00000001 c03f5db4 c03f5d7c c02f9f62 00000001 64c2e4ca c03eec00
Call Trace:    [<e02a3111>] [<e02a3574>] [<c02f9f62>] [<c02f0d76>]
[<c02fa2c4>]
[<c02f917d>] [<c02f917d>] [<c02f3129>] [<c02f268b>] [<c02f3c20>]
[<e02a3900>]
[<c02f1a21>] [<c0289dee>] [<c02b92e3>] [<c028a1ad>] [<c02b92e3>]
[<c02b909f>]
[<c02b92e3>] [<c028190b>] [<e017b9eb>] [<c027d7ad>] [<e017b63f>]
[<e017b763>]
[<c0281ae4>] [<c011fa04>] [<c0109d36>] [<c0105000>] [<c010c0c3>]
[<c010698e>]
[<c0105000>] [<c01069b8>] [<c0106a10>]
Code: 89 50 04 89 02 c7 41 04 00 00 00 00 c7 01 00 00 00 00 8b 46


>>EIP; e02a135b <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+3b/e9>
  <=====

>>ebx; c03f4000 <init_task_union+0/2000>
>>ecx; de472654 <_end+1dfdbebc/1fbc98c8>
>>esi; d4e9b58c <_end+14a04df4/1fbc98c8>
>>edi; d2f85eb4 <_end+12aef71c/1fbc98c8>
>>ebp; de403a34 <_end+1df6d29c/1fbc98c8>
>>esp; c03f5c40 <init_task_union+1c40/2000>

Trace; e02a3111 <[ip_conntrack_pptp]pptp_timeout_related+1b/56>
Trace; e02a3574 <[ip_conntrack_pptp]conntrack_pptp_help+428/48e>
Trace; c02f9f62 <get_unique_tuple+e1/1c0>
Trace; c02f0d76 <__ip_conntrack_find+e/6a>
Trace; c02fa2c4 <ip_nat_setup_info+283/2a2>
Trace; c02f917d <ip_nat_cheat_check+1c/34>
Trace; c02f917d <ip_nat_cheat_check+1c/34>
Trace; c02f3129 <tcp_in_window+b2/34b>
Trace; c02f268b <ip_ct_refresh+5d/bd>
Trace; c02f3c20 <tcp_packet+64b/65a>
Trace; e02a3900 <[ip_conntrack_pptp]pptp+0/47>
Trace; c02f1a21 <ip_conntrack_in+218/26c>
Trace; c0289dee <nf_iterate+3a/5a>
Trace; c02b92e3 <ip_rcv_finish+0/206>
Trace; c028a1ad <nf_hook_slow+dd/1a1>
Trace; c02b92e3 <ip_rcv_finish+0/206>
Trace; c02b909f <ip_rcv+1b0/3f4>
Trace; c02b92e3 <ip_rcv_finish+0/206>
Trace; c028190b <netif_receive_skb+171/1a1>
Trace; e017b9eb <[e1000]e1000_clean_rx_irq+fb/520>
Trace; c027d7ad <__kfree_skb+151/154>
Trace; e017b63f <[e1000]e1000_clean+7f/2a0>
Trace; e017b763 <[e1000]e1000_clean+1a3/2a0>
Trace; c0281ae4 <net_rx_action+a0/136>
Trace; c011fa04 <do_softirq+78/df>
Trace; c0109d36 <do_IRQ+124/130>
Trace; c0105000 <_stext+0/0>
Trace; c010c0c3 <call_do_IRQ+5/12>
Trace; c010698e <default_idle+0/2d>
Trace; c0105000 <_stext+0/0>
Trace; c01069b8 <default_idle+2a/2d>
Trace; c0106a10 <cpu_idle+3a/48>

Code;  e02a135b <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+3b/e9>
00000000 <_EIP>:
Code;  e02a135b <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+3b/e9>
  <=====
   0:   89 50 04                  mov    %edx,0x4(%eax)   <=====
Code;  e02a135e <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+3e/e9>
   3:   89 02                     mov    %eax,(%edx)
Code;  e02a1360 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+40/e9>
   5:   c7 41 04 00 00 00 00      movl   $0x0,0x4(%ecx)
Code;  e02a1367 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+47/e9>
   c:   c7 01 00 00 00 00         movl   $0x0,(%ecx)
Code;  e02a136d <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+4d/e9>
  12:   8b 46 00                  mov    0x0(%esi),%eax

<0>Kernel panic: Aiee, killing interrupt handler!

1 warning and 2 errors issued.  Results may not be reliable.
-----------------------------------------------------------------------

We're building a new kernel with some debugging. Maybe we'll catch
something. If anyone has any hints of where else to look or what else we
could do to isolate this, I'd sure appreciate it!

Thanks!

Tim
