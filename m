From: Balazs Scheidler <bazsi@balabit.hu>
Subject: oops in tftp helper
Date: Mon, 29 Sep 2003 15:05:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030929130509.GA4010@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

We have encountered the following oops when trying to use the TFTP conntrack
helper. We do not use NAT, only connection tracking. The culprit seems to be
this code in init_conntrack():

        /* If the expectation is dying, then this is a looser. */
        if (expected
            && expected->expectant->helper->timeout
            && ! del_timer(&expected->timeout))
                expected = NULL;

Which is translated to (checked using objdump --disassemble):

     fbb:       85 db                   test   %ebx,%ebx		; ebx == expected
     fbd:       74 6f                   je     102e <init_conntrack+0x34e>
     fbf:       8b 43 14                mov    0x14(%ebx),%eax		; eax := expected->expectant
     fc2:       8b 40 6c                mov    0x6c(%eax),%eax		; eax := excepted->expectant->helper
     fc5:       83 78 18 00             cmpl   $0x0,0x18(%eax)		; eax == NULL => BOOM
     fc9:       74 15                   je     fe0 <init_conntrack+0x300>
     fcb:       8d 43 2c                lea    0x2c(%ebx),%eax
     fce:       50                      push   %eax
     fcf:       e8 fc ff ff ff          call   fd0 <init_conntrack+0x2f0>
     fd4:       89 c2                   mov    %eax,%edx
     fd6:       83 c4 04                add    $0x4,%esp
     fd9:       31 c0                   xor    %eax,%eax
     fdb:       85 d2                   test   %edx,%edx
     fdd:       0f 44 d8                cmove  %eax,%ebx
     fe0:       85 db                   test   %ebx,%ebx
     fe2:       74 4a                   je     102e <init_conntrack+0x34e>
     fe4:       8b 75 e8                mov    0xffffffe8(%ebp),%esi

The problem _might_ be caused by the fact that ip_conntrack_tftp has no lock
on its own, while all other helpers (ftp, irc and amanda checked) have their
own lock to serialize ip_conntrack_expect_related calls. I don't know the
conntrack core enough to be sure.

The ksymoops-ed dump is:

Oops: 0000
CPU:    0
EIP:    0010:[<f890b795>]       Not tainted
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010286
eax: 00000000   ebx: e76f9d00   ecx: c0375188   edx: 00000000
esi: 00000003   edi: c030fe5c   ebp: c030fe28   esp: c030fe04
ds: 0018        es: 0018        ss: 0018
Process swapper (pid: 0, stackpage=c030f000)
Stack: c030fe58 c030fe5c f0409a80 cd602500 cd602508 d1ed06c1 f890e2eb 4dee06c1
       00110d80 c030fed8 f890b99d c030fe5c f890ea20 f0409a80 c030fec8 c03b16e0
       c023e8d0 00000000 c030fe54 f890ea20 e6ead020 ed0ef880 4dee06c1 00000d80
Call Trace: [<f890e2eb>] [<f890b99d>] [<f890ea20>] [<c023e8d0>] [<f890ea20>]
  [<c0232d40>] [<c023e8d0>] [<c023e8d0>] [<c023308f>] [<c023e8d0>] [<f890e5a4>]
  [<c023e756>] [<c023e8d0>] [<c022c8cb>] [<c022c979>] [<c022caaf>] [<c011ee3d>]
  [<c010a2eb>] [<c0106d80>] [<c0105000>] [<c0106d80>] [<c0105000>] [<c0106da9>]
  [<c0106dfb>] [<c0105048>]
Code: 83 78 18 00 74 15 8d 43 2c 50 e8 ac 65 81 c7 89 c2 83 c4 04
 
 
>>EIP; f890b795 <[ip_conntrack]init_conntrack+2e5/3b4>   <=====
 
>>ebx; e76f9d00 <_end+2733358c/3853f88c>
>>ecx; c0375188 <irq_stat+8/1000>
>>edi; c030fe5c <init_task_union+1e5c/2000>
>>ebp; c030fe28 <init_task_union+1e28/2000>
>>esp; c030fe04 <init_task_union+1e04/2000>
 
Trace; f890e2eb <[ip_conntrack].rodata.end+28c/541>
Trace; f890b99d <[ip_conntrack]ip_conntrack_in+139/270>
Trace; f890ea20 <[ip_conntrack]ip_conntrack_protocol_udp+0/40>
Trace; c023e8d0 <ip_rcv_finish+0/219>
Trace; f890ea20 <[ip_conntrack]ip_conntrack_protocol_udp+0/40>
Trace; c0232d40 <nf_iterate+30/80>
Trace; c023e8d0 <ip_rcv_finish+0/219>
Trace; c023e8d0 <ip_rcv_finish+0/219>
Trace; c023308f <nf_hook_slow+d7/194>
Trace; c023e8d0 <ip_rcv_finish+0/219>
Trace; f890e5a4 <[ip_conntrack]ip_conntrack_in_ops+0/18>
Trace; c023e756 <ip_rcv+3b6/3fc>
Trace; c023e8d0 <ip_rcv_finish+0/219>
Trace; c022c8cb <netif_receive_skb+11b/148>
Trace; c022c979 <process_backlog+81/124>
Trace; c022caaf <net_rx_action+93/144>
Trace; c011ee3d <do_softirq+7d/dc>
Trace; c010a2eb <do_IRQ+db/ec>
Trace; c0106d80 <default_idle+0/34>
Trace; c0105000 <_stext+0/0>
Trace; c0106d80 <default_idle+0/34>
Trace; c0105000 <_stext+0/0>
Trace; c0106da9 <default_idle+29/34>
Trace; c0106dfb <cpu_idle+27/34>
Trace; c0105048 <rest_init+48/4c>
 
Code;  f890b795 <[ip_conntrack]init_conntrack+2e5/3b4>
00000000 <_EIP>:
Code;  f890b795 <[ip_conntrack]init_conntrack+2e5/3b4>   <=====
   0:   83 78 18 00               cmpl   $0x0,0x18(%eax)   <=====
Code;  f890b799 <[ip_conntrack]init_conntrack+2e9/3b4>
   4:   74 15                     je     1b <_EIP+0x1b> f890b7b0 <[ip_conntrack]init_conntrack+300/3b4>
Code;  f890b79b <[ip_conntrack]init_conntrack+2eb/3b4>
   6:   8d 43 2c                  lea    0x2c(%ebx),%eax
Code;  f890b79e <[ip_conntrack]init_conntrack+2ee/3b4>
   9:   50                        push   %eax
Code;  f890b79f <[ip_conntrack]init_conntrack+2ef/3b4>
   a:   e8 ac 65 81 c7            call   c78165bb <_EIP+0xc78165bb> c0121d50 <del_timer+0/54>
Code;  f890b7a4 <[ip_conntrack]init_conntrack+2f4/3b4>
   f:   89 c2                     mov    %eax,%edx
Code;  f890b7a6 <[ip_conntrack]init_conntrack+2f6/3b4>
  11:   83 c4 04                  add    $0x4,%esp


-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
