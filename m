From: Pierre-Elliott =?iso-8859-1?Q?B=E9cue?= <peb@pimeys.fr>
Subject: Re: [Request for help] Kernel Panic in __nf_conntrack_find_get
Date: Wed, 11 May 2016 08:45:24 +0200
Message-ID: <20160511064524.GQ26005@pimeys.fr>
References: <20160509101318.GB26005@pimeys.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pimeys.fr ([62.210.178.115]:42111 "EHLO pimeys.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbcEKGxj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 May 2016 02:53:39 -0400
Received: from pimeys.fr (pimeys.fr [IPv6:2001:bc8:3520::1])
	(using TLSv1.2 with cipher ECDHE-RSA-DES-CBC3-SHA (112/168 bits))
	(No client certificate requested)
	by pimeys.fr (Postfix) with ESMTPSA id DA9FB28042A
	for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2016 08:45:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160509101318.GB26005@pimeys.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 09 mai 2016 =E0 12:13:18+0200, Pierre-Elliott B=E9cue a =E9cri=
t=A0:
> Dear Linux developers,
>=20
> At first, I'd like to apologize if this mailing list is not the appro=
priate
> one to ask for help about a kernel panic, but I'm a bit confused abou=
t who
> to ask for some help.
>=20
> I'm not sure this one is a bug in the kernel or elsewhere, but I've
> exhausted a lot of things in trying to identify what's happening, and=
 I'm
> not sure to be able to understand further what is happening.
>=20
> Basically, I have a Debian 8 router under 3.16.7 patched by canonical=
 kernel
> team. This router has periodic kernel panics which are caused by SWAP=
PER.
>=20
> I put a kexec/kdump setup to get crash logs, and this is what I get=A0=
:
>=20
>       KERNEL: /var/crash/201605082314/kernel_link
>     DUMPFILE: /var/crash/201605082314/dump.201605082314  [PARTIAL DUM=
P]
>         CPUS: 12
>         DATE: Sun May  8 23:14:31 2016
>       UPTIME: 3 days, 10:44:11
> LOAD AVERAGE: 0.85, 1.00, 1.10
>        TASKS: 264
>     NODENAME: odlyd
>      RELEASE: 3.16.0-4-amd64
>      VERSION: #1 SMP Debian 3.16.7-ckt25-2 (2016-04-08)
>      MACHINE: x86_64  (2593 Mhz)
>       MEMORY: 16 GB
>        PANIC: ""
>          PID: 0
>      COMMAND: "swapper/0"
>         TASK: ffffffff8181a460  (1 of 12)  [THREAD_INFO: ffffffff8180=
0000]
>          CPU: 0
>        STATE: TASK_RUNNING (PANIC)
>=20
> A backtrace gives me that=A0:
>=20
> PID: 0      TASK: ffffffff8181a460  CPU: 0   COMMAND: "swapper/0"
>  #0 [ffff88043f4039b0] machine_kexec at ffffffff8104c0a2
>  #1 [ffff88043f403a00] crash_kexec at ffffffff810df7da
>  #2 [ffff88043f403ac0] oops_end at ffffffff81016228
>  #3 [ffff88043f403ae0] general_protection at ffffffff815169c8
>     [exception RIP: __nf_conntrack_find_get+111]
>     RIP: ffffffffa0233e4f  RSP: ffff88043f403b90  RFLAGS: 00010246
>     RAX: 000060fbc02020e0  RBX: ffb00504023b9dc0  RCX: 0000000000002a=
d2
>     RDX: ffff88043f403c00  RSI: 0000000000015690  RDI: 0000000005e6ab=
45
>     RBP: ffff88043f403c00   R8: 0000000000000000   R9: 00000000ea00da=
68
>     R10: ffff88043f403c18  R11: 0000000000000010  R12: ffffffff818ba2=
00
>     R13: 00000000ab4bdd82  R14: 0000000000000000  R15: 00000000000000=
00
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #4 [ffff88043f403bb8] nf_conntrack_in at ffffffffa0235833 [nf_conntr=
ack]
>  #5 [ffff88043f403c88] nf_iterate at ffffffff8144fb65
>  #6 [ffff88043f403cc8] nf_hook_slow at ffffffff8144fc16
>  #7 [ffff88043f403d28] ip_rcv at ffffffff8145677d
>  #8 [ffff88043f403d50] __netif_receive_skb_core at ffffffff8141f1a3
>  #9 [ffff88043f403da0] netif_receive_skb_internal at ffffffff8141f42f
> #10 [ffff88043f403dc0] napi_gro_receive at ffffffff8141ff00
> #11 [ffff88043f403de0] tg3_poll_work at ffffffffa026589f [tg3]
> #12 [ffff88043f403e60] napi_gro_flush at ffffffff8141f615
> #13 [ffff88043f403e98] tg3_poll_msix at ffffffffa0265b85 [tg3]
> #14 [ffff88043f403ed0] net_rx_action at ffffffff8141f7b0
> #15 [ffff88043f403f20] __do_softirq at ffffffff8106c6a1
> #16 [ffff88043f403f78] irq_exit at ffffffff8106ca75
> #17 [ffff88043f403f80] do_IRQ at ffffffff81517822
> --- <IRQ stack> ---
> #18 [ffffffff81803e28] ret_from_intr at ffffffff8151566d
>     [exception RIP: cpuidle_enter_state+82]
>     RIP: ffffffff813e0122  RSP: ffffffff81803ed8  RFLAGS: 00000202
>     RAX: 00010ee477267826  RBX: ffffffff81074ae6  RCX: 00000000000000=
18
>     RDX: 0000000225c17d03  RSI: ffffffff81803fd8  RDI: 00010ee4772678=
26
>     RBP: ffffffff81803f00   R8: 00000000ffffffff   R9: 00000000000014=
a1
>     R10: 0000000000000030  R11: 0000000000000008  R12: 00000001046f0f=
95
>     R13: 00000001046f0f94  R14: 00000001046f0f94  R15: ffffffff81803e=
a0
>     ORIG_RAX: ffffffffffffff7b  CS: 0010  SS: 0018
> #19 [ffffffff81803f08] cpu_startup_entry at ffffffff810a8398
> #20 [ffffffff81803f68] start_kernel at ffffffff81903076
> #21 [ffffffff81803fa0] x86_64_start_kernel at ffffffff8190271f
>=20
> So I guess the exception that raised a general protection fault is ca=
used by
> __nf_conntrack_find_get+111.
>=20
> I had some troubles having something more readable (by me) than assem=
bly, but
> here is the __nf_conntrack_find_get disassembled by crash:
>=20
> 0xffffffffa0233de0 <__nf_conntrack_find_get>:   nopl   0x0(%rax,%rax,=
1) [FTRACE NOP]
> 0xffffffffa0233de5 <__nf_conntrack_find_get+5>: push   %r14
> 0xffffffffa0233de7 <__nf_conntrack_find_get+7>: mov    %esi,%r14d
> 0xffffffffa0233dea <__nf_conntrack_find_get+10>:        push   %r13
> 0xffffffffa0233dec <__nf_conntrack_find_get+12>:        push   %r12
> 0xffffffffa0233dee <__nf_conntrack_find_get+14>:        mov    %rdi,%=
r12
> 0xffffffffa0233df1 <__nf_conntrack_find_get+17>:        push   %rbp
> 0xffffffffa0233df2 <__nf_conntrack_find_get+18>:        mov    %rdx,%=
rbp
> 0xffffffffa0233df5 <__nf_conntrack_find_get+21>:        push   %rbx
> 0xffffffffa0233df6 <__nf_conntrack_find_get+22>:        mov    %ecx,%=
r13d
> 0xffffffffa0233df9 <__nf_conntrack_find_get+25>:        mov    0xaf0(=
%r12),%ecx
> 0xffffffffa0233e01 <__nf_conntrack_find_get+33>:        addl   $0x200=
,%gs:0xb860
> 0xffffffffa0233e0d <__nf_conntrack_find_get+45>:        imul   %r13,%=
rcx
> 0xffffffffa0233e11 <__nf_conntrack_find_get+49>:        shr    $0x20,=
%rcx
> 0xffffffffa0233e15 <__nf_conntrack_find_get+53>:        lea    0x0(,%=
rcx,8),%rsi
> 0xffffffffa0233e1d <__nf_conntrack_find_get+61>:        mov    %rsi,%=
rax
> 0xffffffffa0233e20 <__nf_conntrack_find_get+64>:        add    0xb00(=
%r12),%rax
> 0xffffffffa0233e28 <__nf_conntrack_find_get+72>:        mov    (%rax)=
,%rbx
> 0xffffffffa0233e2b <__nf_conntrack_find_get+75>:        test   $0x1,%=
bl
> 0xffffffffa0233e2e <__nf_conntrack_find_get+78>:        je     0xffff=
ffffa0233e4f
> 0xffffffffa0233e30 <__nf_conntrack_find_get+80>:        jmpq   0xffff=
ffffa0233f90
> 0xffffffffa0233e35 <__nf_conntrack_find_get+85>:        nopl   (%rax)
> 0xffffffffa0233e38 <__nf_conntrack_find_get+88>:        mov    0xb18(=
%r12),%rax
> 0xffffffffa0233e40 <__nf_conntrack_find_get+96>:        incl   %gs:(%=
rax)
> 0xffffffffa0233e43 <__nf_conntrack_find_get+99>:        mov    (%rbx)=
,%rbx
> 0xffffffffa0233e46 <__nf_conntrack_find_get+102>:       test   $0x1,%=
bl
> 0xffffffffa0233e49 <__nf_conntrack_find_get+105>:       jne    0xffff=
ffffa0233f90
> 0xffffffffa0233e4f <__nf_conntrack_find_get+111>:       mov    0x10(%=
rbx),%edi
> 0xffffffffa0233e52 <__nf_conntrack_find_get+114>:       cmp    %edi,0=
x0(%rbp)
> 0xffffffffa0233e55 <__nf_conntrack_find_get+117>:       movzbl 0x37(%=
rbx),%eax
> 0xffffffffa0233e59 <__nf_conntrack_find_get+121>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e5b <__nf_conntrack_find_get+123>:       mov    0x14(%=
rbx),%edx
> 0xffffffffa0233e5e <__nf_conntrack_find_get+126>:       cmp    %edx,0=
x4(%rbp)
> 0xffffffffa0233e61 <__nf_conntrack_find_get+129>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e63 <__nf_conntrack_find_get+131>:       mov    0x18(%=
rbx),%edi
> 0xffffffffa0233e66 <__nf_conntrack_find_get+134>:       cmp    %edi,0=
x8(%rbp)
> 0xffffffffa0233e69 <__nf_conntrack_find_get+137>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e6b <__nf_conntrack_find_get+139>:       mov    0x1c(%=
rbx),%edx
> 0xffffffffa0233e6e <__nf_conntrack_find_get+142>:       cmp    %edx,0=
xc(%rbp)
> 0xffffffffa0233e71 <__nf_conntrack_find_get+145>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e73 <__nf_conntrack_find_get+147>:       mov    0x20(%=
rbx),%edx
> 0xffffffffa0233e76 <__nf_conntrack_find_get+150>:       cmp    %edx,0=
x10(%rbp)
> 0xffffffffa0233e79 <__nf_conntrack_find_get+153>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e7b <__nf_conntrack_find_get+155>:       mov    0x24(%=
rbx),%edi
> 0xffffffffa0233e7e <__nf_conntrack_find_get+158>:       cmp    %edi,0=
x14(%rbp)
> 0xffffffffa0233e81 <__nf_conntrack_find_get+161>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e83 <__nf_conntrack_find_get+163>:       mov    0x28(%=
rbx),%edx
> 0xffffffffa0233e86 <__nf_conntrack_find_get+166>:       cmp    %edx,0=
x18(%rbp)
> 0xffffffffa0233e89 <__nf_conntrack_find_get+169>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e8b <__nf_conntrack_find_get+171>:       mov    0x2c(%=
rbx),%edx
> 0xffffffffa0233e8e <__nf_conntrack_find_get+174>:       cmp    %edx,0=
x1c(%rbp)
> 0xffffffffa0233e91 <__nf_conntrack_find_get+177>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e93 <__nf_conntrack_find_get+179>:       mov    0x30(%=
rbx),%edx
> 0xffffffffa0233e96 <__nf_conntrack_find_get+182>:       cmp    %edx,0=
x20(%rbp)
> 0xffffffffa0233e99 <__nf_conntrack_find_get+185>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233e9b <__nf_conntrack_find_get+187>:       mov    0x24(%=
rbp),%edi
> 0xffffffffa0233e9e <__nf_conntrack_find_get+190>:       mov    0x34(%=
rbx),%edx
> 0xffffffffa0233ea1 <__nf_conntrack_find_get+193>:       and    $0xfff=
fff,%edi
> 0xffffffffa0233ea7 <__nf_conntrack_find_get+199>:       and    $0xfff=
fff,%edx
> 0xffffffffa0233ead <__nf_conntrack_find_get+205>:       cmp    %edx,%=
edi
> 0xffffffffa0233eaf <__nf_conntrack_find_get+207>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233eb1 <__nf_conntrack_find_get+209>:       lea    0x0(,%=
rax,8),%rdx
> 0xffffffffa0233eb9 <__nf_conntrack_find_get+217>:       shl    $0x6,%=
rax
> 0xffffffffa0233ebd <__nf_conntrack_find_get+221>:       mov    %rbx,%=
rdi
> 0xffffffffa0233ec0 <__nf_conntrack_find_get+224>:       sub    %rdx,%=
rax
> 0xffffffffa0233ec3 <__nf_conntrack_find_get+227>:       add    $0x10,=
%rax
> 0xffffffffa0233ec7 <__nf_conntrack_find_get+231>:       sub    %rax,%=
rdi
> 0xffffffffa0233eca <__nf_conntrack_find_get+234>:       mov    0xe8(%=
rdi),%rdx
> 0xffffffffa0233ed1 <__nf_conntrack_find_get+241>:       test   %rdx,%=
rdx
> 0xffffffffa0233ed4 <__nf_conntrack_find_get+244>:       je     0xffff=
ffffa023405e
> 0xffffffffa0233eda <__nf_conntrack_find_get+250>:       movzwl 0x1a(%=
rdx),%eax
> 0xffffffffa0233ede <__nf_conntrack_find_get+254>:       test   %ax,%a=
x
> 0xffffffffa0233ee1 <__nf_conntrack_find_get+257>:       je     0xffff=
ffffa0233eef
> 0xffffffffa0233ee3 <__nf_conntrack_find_get+259>:       add    %rax,%=
rdx
> 0xffffffffa0233ee6 <__nf_conntrack_find_get+262>:       je     0xffff=
ffffa023405e
> 0xffffffffa0233eec <__nf_conntrack_find_get+268>:       movzwl (%rdx)=
,%eax
> 0xffffffffa0233eef <__nf_conntrack_find_get+271>:       cmp    %ax,%r=
14w
> 0xffffffffa0233ef3 <__nf_conntrack_find_get+275>:       jne    0xffff=
ffffa0233e38
> 0xffffffffa0233ef9 <__nf_conntrack_find_get+281>:       mov    0x80(%=
rdi),%rax
> 0xffffffffa0233f00 <__nf_conntrack_find_get+288>:       test   $0x8,%=
al
> 0xffffffffa0233f02 <__nf_conntrack_find_get+290>:       je     0xffff=
ffffa0233e38
> 0xffffffffa0233f08 <__nf_conntrack_find_get+296>:       mov    $0x200=
,%esi
> 0xffffffffa0233f0d <__nf_conntrack_find_get+301>:       mov    $0xfff=
fffffa0233f08,%rdi
> 0xffffffffa0233f14 <__nf_conntrack_find_get+308>:       mov    0xb18(=
%r12),%rax
> 0xffffffffa0233f1c <__nf_conntrack_find_get+316>:       incl   %gs:0x=
4(%rax)
> 0xffffffffa0233f20 <__nf_conntrack_find_get+320>:       callq  0xffff=
ffff8106c8f0 <__local_bh_enable_ip>
> 0xffffffffa0233f25 <__nf_conntrack_find_get+325>:       test   %rbx,%=
rbx
> 0xffffffffa0233f28 <__nf_conntrack_find_get+328>:       je     0xffff=
ffffa0234076
> 0xffffffffa0233f2e <__nf_conntrack_find_get+334>:       movzbl 0x37(%=
rbx),%eax
> 0xffffffffa0233f32 <__nf_conntrack_find_get+338>:       mov    %rbx,%=
rdi
> 0xffffffffa0233f35 <__nf_conntrack_find_get+341>:       lea    0x0(,%=
rax,8),%rdx
> 0xffffffffa0233f3d <__nf_conntrack_find_get+349>:       shl    $0x6,%=
rax
> 0xffffffffa0233f41 <__nf_conntrack_find_get+353>:       sub    %rdx,%=
rax
> 0xffffffffa0233f44 <__nf_conntrack_find_get+356>:       add    $0x10,=
%rax
> 0xffffffffa0233f48 <__nf_conntrack_find_get+360>:       sub    %rax,%=
rdi
> 0xffffffffa0233f4b <__nf_conntrack_find_get+363>:       mov    0x80(%=
rdi),%rax
> 0xffffffffa0233f52 <__nf_conntrack_find_get+370>:       test   $0x2,%=
ah
> 0xffffffffa0233f55 <__nf_conntrack_find_get+373>:       jne    0xffff=
ffffa0234076
> 0xffffffffa0233f5b <__nf_conntrack_find_get+379>:       mov    (%rdi)=
,%edx
> 0xffffffffa0233f5d <__nf_conntrack_find_get+381>:       test   %edx,%=
edx
> 0xffffffffa0233f5f <__nf_conntrack_find_get+383>:       je     0xffff=
ffffa0234076
> 0xffffffffa0233f65 <__nf_conntrack_find_get+389>:       lea    0x1(%r=
dx),%ecx
> 0xffffffffa0233f68 <__nf_conntrack_find_get+392>:       mov    %edx,%=
eax
> 0xffffffffa0233f6a <__nf_conntrack_find_get+394>:       lock cmpxchg =
%ecx,(%rdi)
> 0xffffffffa0233f6e <__nf_conntrack_find_get+398>:       cmp    %eax,%=
edx
> 0xffffffffa0233f70 <__nf_conntrack_find_get+400>:       mov    %eax,%=
ecx
> 0xffffffffa0233f72 <__nf_conntrack_find_get+402>:       jne    0xffff=
ffffa023407e
> 0xffffffffa0233f78 <__nf_conntrack_find_get+408>:       mov    0x10(%=
rbx),%esi
> 0xffffffffa0233f7b <__nf_conntrack_find_get+411>:       cmp    %esi,0=
x0(%rbp)
> 0xffffffffa0233f7e <__nf_conntrack_find_get+414>:       movzbl 0x37(%=
rbx),%eax
> 0xffffffffa0233f82 <__nf_conntrack_find_get+418>:       je     0xffff=
ffffa0233fad
> 0xffffffffa0233f84 <__nf_conntrack_find_get+420>:       callq  0xffff=
ffffa0233240 <nf_conntrack_put>
> 0xffffffffa0233f89 <__nf_conntrack_find_get+425>:       jmpq   0xffff=
ffffa0233df9
> 0xffffffffa0233f8e <__nf_conntrack_find_get+430>:       xchg   %ax,%a=
x
> 0xffffffffa0233f90 <__nf_conntrack_find_get+432>:       shr    %rbx
> 0xffffffffa0233f93 <__nf_conntrack_find_get+435>:       cmp    %rbx,%=
rcx
> 0xffffffffa0233f96 <__nf_conntrack_find_get+438>:       je     0xffff=
ffffa0234065
> 0xffffffffa0233f9c <__nf_conntrack_find_get+444>:       mov    0xb18(=
%r12),%rax
> 0xffffffffa0233fa4 <__nf_conntrack_find_get+452>:       incl   %gs:0x=
3c(%rax)
> 0xffffffffa0233fa8 <__nf_conntrack_find_get+456>:       jmpq   0xffff=
ffffa0233e1d
> 0xffffffffa0233fad <__nf_conntrack_find_get+461>:       mov    0x14(%=
rbx),%esi
> 0xffffffffa0233fb0 <__nf_conntrack_find_get+464>:       cmp    %esi,0=
x4(%rbp)
> 0xffffffffa0233fb3 <__nf_conntrack_find_get+467>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fb5 <__nf_conntrack_find_get+469>:       mov    0x18(%=
rbx),%esi
> 0xffffffffa0233fb8 <__nf_conntrack_find_get+472>:       cmp    %esi,0=
x8(%rbp)
> 0xffffffffa0233fbb <__nf_conntrack_find_get+475>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fbd <__nf_conntrack_find_get+477>:       mov    0x1c(%=
rbx),%esi
> 0xffffffffa0233fc0 <__nf_conntrack_find_get+480>:       cmp    %esi,0=
xc(%rbp)
> 0xffffffffa0233fc3 <__nf_conntrack_find_get+483>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fc5 <__nf_conntrack_find_get+485>:       mov    0x20(%=
rbx),%esi
> 0xffffffffa0233fc8 <__nf_conntrack_find_get+488>:       cmp    %esi,0=
x10(%rbp)
> 0xffffffffa0233fcb <__nf_conntrack_find_get+491>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fcd <__nf_conntrack_find_get+493>:       mov    0x24(%=
rbx),%esi
> 0xffffffffa0233fd0 <__nf_conntrack_find_get+496>:       cmp    %esi,0=
x14(%rbp)
> 0xffffffffa0233fd3 <__nf_conntrack_find_get+499>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fd5 <__nf_conntrack_find_get+501>:       mov    0x28(%=
rbx),%esi
> 0xffffffffa0233fd8 <__nf_conntrack_find_get+504>:       cmp    %esi,0=
x18(%rbp)
> 0xffffffffa0233fdb <__nf_conntrack_find_get+507>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fdd <__nf_conntrack_find_get+509>:       mov    0x2c(%=
rbx),%esi
> 0xffffffffa0233fe0 <__nf_conntrack_find_get+512>:       cmp    %esi,0=
x1c(%rbp)
> 0xffffffffa0233fe3 <__nf_conntrack_find_get+515>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fe5 <__nf_conntrack_find_get+517>:       mov    0x30(%=
rbx),%esi
> 0xffffffffa0233fe8 <__nf_conntrack_find_get+520>:       cmp    %esi,0=
x20(%rbp)
> 0xffffffffa0233feb <__nf_conntrack_find_get+523>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0233fed <__nf_conntrack_find_get+525>:       mov    0x24(%=
rbp),%ecx
> 0xffffffffa0233ff0 <__nf_conntrack_find_get+528>:       mov    0x34(%=
rbx),%edx
> 0xffffffffa0233ff3 <__nf_conntrack_find_get+531>:       and    $0xfff=
fff,%ecx
> 0xffffffffa0233ff9 <__nf_conntrack_find_get+537>:       and    $0xfff=
fff,%edx
> 0xffffffffa0233fff <__nf_conntrack_find_get+543>:       cmp    %edx,%=
ecx
> 0xffffffffa0234001 <__nf_conntrack_find_get+545>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0234003 <__nf_conntrack_find_get+547>:       lea    0x0(,%=
rax,8),%rdx
> 0xffffffffa023400b <__nf_conntrack_find_get+555>:       shl    $0x6,%=
rax
> 0xffffffffa023400f <__nf_conntrack_find_get+559>:       mov    %rbx,%=
rcx
> 0xffffffffa0234012 <__nf_conntrack_find_get+562>:       sub    %rdx,%=
rax
> 0xffffffffa0234015 <__nf_conntrack_find_get+565>:       add    $0x10,=
%rax
> 0xffffffffa0234019 <__nf_conntrack_find_get+569>:       sub    %rax,%=
rcx
> 0xffffffffa023401c <__nf_conntrack_find_get+572>:       mov    0xe8(%=
rcx),%rdx
> 0xffffffffa0234023 <__nf_conntrack_find_get+579>:       test   %rdx,%=
rdx
> 0xffffffffa0234026 <__nf_conntrack_find_get+582>:       je     0xffff=
ffffa023407a
> 0xffffffffa0234028 <__nf_conntrack_find_get+584>:       movzwl 0x1a(%=
rdx),%eax
> 0xffffffffa023402c <__nf_conntrack_find_get+588>:       test   %ax,%a=
x
> 0xffffffffa023402f <__nf_conntrack_find_get+591>:       je     0xffff=
ffffa0234039
> 0xffffffffa0234031 <__nf_conntrack_find_get+593>:       add    %rdx,%=
rax
> 0xffffffffa0234034 <__nf_conntrack_find_get+596>:       je     0xffff=
ffffa023407a
> 0xffffffffa0234036 <__nf_conntrack_find_get+598>:       movzwl (%rax)=
,%eax
> 0xffffffffa0234039 <__nf_conntrack_find_get+601>:       cmp    %ax,%r=
14w
> 0xffffffffa023403d <__nf_conntrack_find_get+605>:       jne    0xffff=
ffffa0233f84
> 0xffffffffa0234043 <__nf_conntrack_find_get+611>:       mov    0x80(%=
rcx),%rax
> 0xffffffffa023404a <__nf_conntrack_find_get+618>:       test   $0x8,%=
al
> 0xffffffffa023404c <__nf_conntrack_find_get+620>:       je     0xffff=
ffffa0233f84
> 0xffffffffa0234052 <__nf_conntrack_find_get+626>:       mov    %rbx,%=
rax
> 0xffffffffa0234055 <__nf_conntrack_find_get+629>:       pop    %rbx
> 0xffffffffa0234056 <__nf_conntrack_find_get+630>:       pop    %rbp
> 0xffffffffa0234057 <__nf_conntrack_find_get+631>:       pop    %r12
> 0xffffffffa0234059 <__nf_conntrack_find_get+633>:       pop    %r13
> 0xffffffffa023405b <__nf_conntrack_find_get+635>:       pop    %r14
> 0xffffffffa023405d <__nf_conntrack_find_get+637>:       retq  =20
> 0xffffffffa023405e <__nf_conntrack_find_get+638>:       xor    %eax,%=
eax
> 0xffffffffa0234060 <__nf_conntrack_find_get+640>:       jmpq   0xffff=
ffffa0233eef
> 0xffffffffa0234065 <__nf_conntrack_find_get+645>:       mov    $0x200=
,%esi
> 0xffffffffa023406a <__nf_conntrack_find_get+650>:       mov    $0xfff=
fffffa0234065,%rdi
> 0xffffffffa0234071 <__nf_conntrack_find_get+657>:       callq  0xffff=
ffff8106c8f0 <__local_bh_enable_ip>
> 0xffffffffa0234076 <__nf_conntrack_find_get+662>:       xor    %ebx,%=
ebx
> 0xffffffffa0234078 <__nf_conntrack_find_get+664>:       jmp    0xffff=
ffffa0234052
> 0xffffffffa023407a <__nf_conntrack_find_get+666>:       xor    %eax,%=
eax
> 0xffffffffa023407c <__nf_conntrack_find_get+668>:       jmp    0xffff=
ffffa0234039
> 0xffffffffa023407e <__nf_conntrack_find_get+670>:       test   %ecx,%=
ecx
> 0xffffffffa0234080 <__nf_conntrack_find_get+672>:       je     0xffff=
ffffa0234076
> 0xffffffffa0234082 <__nf_conntrack_find_get+674>:       lea    0x1(%r=
cx),%edx
> 0xffffffffa0234085 <__nf_conntrack_find_get+677>:       mov    %ecx,%=
eax
> 0xffffffffa0234087 <__nf_conntrack_find_get+679>:       lock cmpxchg =
%edx,(%rdi)
> 0xffffffffa023408b <__nf_conntrack_find_get+683>:       cmp    %ecx,%=
eax
> 0xffffffffa023408d <__nf_conntrack_find_get+685>:       je     0xffff=
ffffa0233f78
> 0xffffffffa0234093 <__nf_conntrack_find_get+691>:       mov    %eax,%=
ecx
> 0xffffffffa0234095 <__nf_conntrack_find_get+693>:       jmp    0xffff=
ffffa023407e
> 0xffffffffa0234097 <__nf_conntrack_find_get+695>:       nopw   0x0(%r=
ax,%rax,1)
>=20
> I could not directly find the source file of this function, but a lit=
tle
> digging in kernel sources of the debian package led me to
> net/netfilter/nf_conntrack_core.c
>=20
> I compiled it with the .config used by debian to build the kernel, an=
d with GDB
> I tracked down the code with list at the good offset address, even if=
 the dumps
> don't look exactly the same (the offset of the assembly code that tri=
ggers
> general protection fault seems to be the same)
>=20
> (gdb) disassemble __nf_conntrack_find_get
> Dump of assembler code for function __nf_conntrack_find_get:
>    0x00000000000022a0 <+0>: callq  0x22a5 <__nf_conntrack_find_get+5>
>    0x00000000000022a5 <+5>: push   %r14
>    0x00000000000022a7 <+7>: mov    %esi,%r14d
>    0x00000000000022aa <+10>:    push   %r13
>    0x00000000000022ac <+12>:    mov    %rdx,%r13
>    0x00000000000022af <+15>:    push   %r12
>    0x00000000000022b1 <+17>:    mov    %rdi,%r12
>    0x00000000000022b4 <+20>:    push   %rbp
>    0x00000000000022b5 <+21>:    push   %rbx
>    0x00000000000022b6 <+22>:    mov    %ecx,%ebp
>    0x00000000000022b8 <+24>:    mov    0xaf0(%r12),%edx
>    0x00000000000022c0 <+32>:    addl   $0x200,%gs:0x0
>    0x00000000000022cc <+44>:    imul   %rbp,%rdx
>    0x00000000000022d0 <+48>:    shr    $0x20,%rdx
>    0x00000000000022d4 <+52>:    lea    0x0(,%rdx,8),%rcx
>    0x00000000000022dc <+60>:    mov    %rcx,%rax
>    0x00000000000022df <+63>:    add    0xb00(%r12),%rax
>    0x00000000000022e7 <+71>:    mov    (%rax),%rbx
>    0x00000000000022ea <+74>:    test   $0x1,%bl
>    0x00000000000022ed <+77>:    je     0x230f <__nf_conntrack_find_ge=
t+111>
>    0x00000000000022ef <+79>:    jmpq   0x2470 <__nf_conntrack_find_ge=
t+464>
>    0x00000000000022f4 <+84>:    nopl   0x0(%rax)
>    0x00000000000022f8 <+88>:    mov    0xb18(%r12),%rax
>    0x0000000000002300 <+96>:    incl   %gs:(%rax)
>    0x0000000000002303 <+99>:    mov    (%rbx),%rbx
>    0x0000000000002306 <+102>:   test   $0x1,%bl
>    0x0000000000002309 <+105>:   jne    0x2470 <__nf_conntrack_find_ge=
t+464>
>    0x000000000000230f <+111>:   mov    0x10(%rbx),%edi
>    0x0000000000002312 <+114>:   cmp    %edi,0x0(%r13)
>    0x0000000000002316 <+118>:   movzbl 0x37(%rbx),%eax
>    0x000000000000231a <+122>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x000000000000231c <+124>:   mov    0x14(%rbx),%esi
>    0x000000000000231f <+127>:   cmp    %esi,0x4(%r13)
>    0x0000000000002323 <+131>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x0000000000002325 <+133>:   mov    0x18(%rbx),%esi
>    0x0000000000002328 <+136>:   cmp    %esi,0x8(%r13)
>    0x000000000000232c <+140>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x000000000000232e <+142>:   mov    0x1c(%rbx),%esi
>    0x0000000000002331 <+145>:   cmp    %esi,0xc(%r13)
>    0x0000000000002335 <+149>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x0000000000002337 <+151>:   mov    0x20(%rbx),%esi
>    0x000000000000233a <+154>:   cmp    %esi,0x10(%r13)
>    0x000000000000233e <+158>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x0000000000002340 <+160>:   mov    0x24(%rbx),%esi
>    0x0000000000002343 <+163>:   cmp    %esi,0x14(%r13)
>    0x0000000000002347 <+167>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x0000000000002349 <+169>:   mov    0x28(%rbx),%esi
>    0x000000000000234c <+172>:   cmp    %esi,0x18(%r13)
>    0x0000000000002350 <+176>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x0000000000002352 <+178>:   mov    0x2c(%rbx),%esi
>    0x0000000000002355 <+181>:   cmp    %esi,0x1c(%r13)
>    0x0000000000002359 <+185>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x000000000000235b <+187>:   mov    0x30(%rbx),%esi
>    0x000000000000235e <+190>:   cmp    %esi,0x20(%r13)
>    0x0000000000002362 <+194>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x0000000000002364 <+196>:   mov    0x24(%r13),%edi
>    0x0000000000002368 <+200>:   mov    0x34(%rbx),%esi
>    0x000000000000236b <+203>:   and    $0xffffff,%edi
>    0x0000000000002371 <+209>:   and    $0xffffff,%esi
>    0x0000000000002377 <+215>:   cmp    %esi,%edi
>    0x0000000000002379 <+217>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x000000000000237f <+223>:   lea    0x0(,%rax,8),%rsi
>    0x0000000000002387 <+231>:   shl    $0x6,%rax
>    0x000000000000238b <+235>:   mov    %rbx,%rdi
>    0x000000000000238e <+238>:   sub    %rsi,%rax
>    0x0000000000002391 <+241>:   add    $0x10,%rax
>    0x0000000000002395 <+245>:   sub    %rax,%rdi
>    0x0000000000002398 <+248>:   mov    0xe8(%rdi),%rsi
>    0x000000000000239f <+255>:   test   %rsi,%rsi
>    0x00000000000023a2 <+258>:   je     0x24b0 <__nf_conntrack_find_ge=
t+528>
>    0x00000000000023a8 <+264>:   movzwl 0x1a(%rsi),%eax
>    0x00000000000023ac <+268>:   test   %ax,%ax
>    0x00000000000023af <+271>:   je     0x23bd <__nf_conntrack_find_ge=
t+285>
>    0x00000000000023b1 <+273>:   add    %rsi,%rax
>    0x00000000000023b4 <+276>:   je     0x24b0 <__nf_conntrack_find_ge=
t+528>
>    0x00000000000023ba <+282>:   movzwl (%rax),%eax
>    0x00000000000023bd <+285>:   cmp    %ax,%r14w
>    0x00000000000023c1 <+289>:   jne    0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x00000000000023c7 <+295>:   mov    0x80(%rdi),%rax
>    0x00000000000023ce <+302>:   test   $0x8,%al
>    0x00000000000023d0 <+304>:   je     0x22f8 <__nf_conntrack_find_ge=
t+88>
>    0x00000000000023d6 <+310>:   mov    $0x200,%esi
>    0x00000000000023db <+315>:   mov    $0x0,%rdi
>    0x00000000000023e2 <+322>:   mov    0xb18(%r12),%rax
>    0x00000000000023ea <+330>:   incl   %gs:0x4(%rax)
>    0x00000000000023ee <+334>:   callq  0x23f3 <__nf_conntrack_find_ge=
t+339>
>    0x00000000000023f3 <+339>:   test   %rbx,%rbx
>    0x00000000000023f6 <+342>:   je     0x2590 <__nf_conntrack_find_ge=
t+752>
>    0x00000000000023fc <+348>:   movzbl 0x37(%rbx),%eax
>    0x0000000000002400 <+352>:   mov    %rbx,%rdi
>    0x0000000000002403 <+355>:   lea    0x0(,%rax,8),%rdx
>    0x000000000000240b <+363>:   shl    $0x6,%rax
>    0x000000000000240f <+367>:   sub    %rdx,%rax
>    0x0000000000002412 <+370>:   add    $0x10,%rax
>    0x0000000000002416 <+374>:   sub    %rax,%rdi
>    0x0000000000002419 <+377>:   mov    0x80(%rdi),%rax
>    0x0000000000002420 <+384>:   test   $0x2,%ah
>    0x0000000000002423 <+387>:   jne    0x2590 <__nf_conntrack_find_ge=
t+752>
>    0x0000000000002429 <+393>:   mov    (%rdi),%ecx
>    0x000000000000242b <+395>:   test   %ecx,%ecx
>    0x000000000000242d <+397>:   je     0x2590 <__nf_conntrack_find_ge=
t+752>
>    0x0000000000002433 <+403>:   lea    0x1(%rcx),%edx
>    0x0000000000002436 <+406>:   mov    %ecx,%eax
>    0x0000000000002438 <+408>:   lock cmpxchg %edx,(%rdi)
>    0x000000000000243c <+412>:   cmp    %eax,%ecx
>    0x000000000000243e <+414>:   mov    %eax,%edx
>    0x0000000000002440 <+416>:   jne    0x248f <__nf_conntrack_find_ge=
t+495>
>    0x0000000000002442 <+418>:   mov    0x10(%rbx),%ecx
>    0x0000000000002445 <+421>:   cmp    %ecx,0x0(%r13)
>    0x0000000000002449 <+425>:   movzbl 0x37(%rbx),%eax
>    0x000000000000244d <+429>:   je     0x24c0 <__nf_conntrack_find_ge=
t+544>
>    0x000000000000244f <+431>:   test   %rdi,%rdi
>    0x0000000000002452 <+434>:   je     0x22b8 <__nf_conntrack_find_ge=
t+24>
>    0x0000000000002458 <+440>:   lock decl (%rdi)
>    0x000000000000245b <+443>:   je     0x25b3 <__nf_conntrack_find_ge=
t+787>
>    0x0000000000002461 <+449>:   jmpq   0x22b8 <__nf_conntrack_find_ge=
t+24>
>    0x0000000000002466 <+454>:   nopw   %cs:0x0(%rax,%rax,1)
>    0x0000000000002470 <+464>:   shr    %rbx
>    0x0000000000002473 <+467>:   cmp    %rbx,%rdx
>    0x0000000000002476 <+470>:   je     0x259e <__nf_conntrack_find_ge=
t+766>
>    0x000000000000247c <+476>:   mov    0xb18(%r12),%rax
>    0x0000000000002484 <+484>:   incl   %gs:0x3c(%rax)
>    0x0000000000002488 <+488>:   jmpq   0x22dc <__nf_conntrack_find_ge=
t+60>
>    0x000000000000248d <+493>:   mov    %eax,%edx
>    0x000000000000248f <+495>:   test   %edx,%edx
>    0x0000000000002491 <+497>:   je     0x2590 <__nf_conntrack_find_ge=
t+752>
>    0x0000000000002497 <+503>:   lea    0x1(%rdx),%ecx
>    0x000000000000249a <+506>:   mov    %edx,%eax
>    0x000000000000249c <+508>:   lock cmpxchg %ecx,(%rdi)
>    0x00000000000024a0 <+512>:   cmp    %edx,%eax
>    0x00000000000024a2 <+514>:   je     0x2442 <__nf_conntrack_find_ge=
t+418>
>    0x00000000000024a4 <+516>:   jmp    0x248d <__nf_conntrack_find_ge=
t+493>
>    0x00000000000024a6 <+518>:   nopw   %cs:0x0(%rax,%rax,1)
>    0x00000000000024b0 <+528>:   xor    %eax,%eax
>    0x00000000000024b2 <+530>:   jmpq   0x23bd <__nf_conntrack_find_ge=
t+285>
>    0x00000000000024b7 <+535>:   nopw   0x0(%rax,%rax,1)
>    0x00000000000024c0 <+544>:   mov    0x14(%rbx),%ecx
>    0x00000000000024c3 <+547>:   cmp    %ecx,0x4(%r13)
>    0x00000000000024c7 <+551>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x00000000000024c9 <+553>:   mov    0x18(%rbx),%ecx
>    0x00000000000024cc <+556>:   cmp    %ecx,0x8(%r13)
>    0x00000000000024d0 <+560>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x00000000000024d6 <+566>:   mov    0x1c(%rbx),%ecx
>    0x00000000000024d9 <+569>:   cmp    %ecx,0xc(%r13)
>    0x00000000000024dd <+573>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x00000000000024e3 <+579>:   mov    0x20(%rbx),%ecx
>    0x00000000000024e6 <+582>:   cmp    %ecx,0x10(%r13)
>    0x00000000000024ea <+586>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x00000000000024f0 <+592>:   mov    0x24(%rbx),%ecx
>    0x00000000000024f3 <+595>:   cmp    %ecx,0x14(%r13)
>    0x00000000000024f7 <+599>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x00000000000024fd <+605>:   mov    0x28(%rbx),%ecx
>    0x0000000000002500 <+608>:   cmp    %ecx,0x18(%r13)
>    0x0000000000002504 <+612>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x000000000000250a <+618>:   mov    0x2c(%rbx),%ecx
>    0x000000000000250d <+621>:   cmp    %ecx,0x1c(%r13)
>    0x0000000000002511 <+625>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x0000000000002517 <+631>:   mov    0x30(%rbx),%ecx
>    0x000000000000251a <+634>:   cmp    %ecx,0x20(%r13)
>    0x000000000000251e <+638>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x0000000000002524 <+644>:   mov    0x24(%r13),%ecx
>    0x0000000000002528 <+648>:   mov    0x34(%rbx),%edx
>    0x000000000000252b <+651>:   and    $0xffffff,%ecx
>    0x0000000000002531 <+657>:   and    $0xffffff,%edx
>    0x0000000000002537 <+663>:   cmp    %edx,%ecx
>    0x0000000000002539 <+665>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x000000000000253f <+671>:   lea    0x0(,%rax,8),%rdx
>    0x0000000000002547 <+679>:   shl    $0x6,%rax
>    0x000000000000254b <+683>:   mov    %rbx,%rcx
>    0x000000000000254e <+686>:   sub    %rdx,%rax
>    0x0000000000002551 <+689>:   add    $0x10,%rax
>    0x0000000000002555 <+693>:   sub    %rax,%rcx
>    0x0000000000002558 <+696>:   mov    0xe8(%rcx),%rdx
>    0x000000000000255f <+703>:   test   %rdx,%rdx
>    0x0000000000002562 <+706>:   je     0x25bd <__nf_conntrack_find_ge=
t+797>
>    0x0000000000002564 <+708>:   movzwl 0x1a(%rdx),%eax
>    0x0000000000002568 <+712>:   test   %ax,%ax
>    0x000000000000256b <+715>:   je     0x2575 <__nf_conntrack_find_ge=
t+725>
>    0x000000000000256d <+717>:   add    %rdx,%rax
>    0x0000000000002570 <+720>:   je     0x25bd <__nf_conntrack_find_ge=
t+797>
>    0x0000000000002572 <+722>:   movzwl (%rax),%eax
>    0x0000000000002575 <+725>:   cmp    %ax,%r14w
>    0x0000000000002579 <+729>:   jne    0x244f <__nf_conntrack_find_ge=
t+431>
>    0x000000000000257f <+735>:   mov    0x80(%rcx),%rax
>    0x0000000000002586 <+742>:   test   $0x8,%al
>    0x0000000000002588 <+744>:   je     0x244f <__nf_conntrack_find_ge=
t+431>
>    0x000000000000258e <+750>:   jmp    0x2592 <__nf_conntrack_find_ge=
t+754>
>    0x0000000000002590 <+752>:   xor    %ebx,%ebx
>    0x0000000000002592 <+754>:   mov    %rbx,%rax
>    0x0000000000002595 <+757>:   pop    %rbx
>    0x0000000000002596 <+758>:   pop    %rbp
>    0x0000000000002597 <+759>:   pop    %r12
>    0x0000000000002599 <+761>:   pop    %r13
>    0x000000000000259b <+763>:   pop    %r14
>    0x000000000000259d <+765>:   retq  =20
>    0x000000000000259e <+766>:   mov    $0x200,%esi
>    0x00000000000025a3 <+771>:   mov    $0x0,%rdi
>    0x00000000000025aa <+778>:   xor    %ebx,%ebx
>    0x00000000000025ac <+780>:   callq  0x25b1 <__nf_conntrack_find_ge=
t+785>
>    0x00000000000025b1 <+785>:   jmp    0x2592 <__nf_conntrack_find_ge=
t+754>
>    0x00000000000025b3 <+787>:   callq  0x25b8 <__nf_conntrack_find_ge=
t+792>
>    0x00000000000025b8 <+792>:   jmpq   0x22b8 <__nf_conntrack_find_ge=
t+24>
>    0x00000000000025bd <+797>:   xor    %eax,%eax
>    0x00000000000025bf <+799>:   jmp    0x2575 <__nf_conntrack_find_ge=
t+725>
> End of assembler dump.
>=20
> (gdb) list *0x000000000000230f
> 0x230f is in __nf_conntrack_find_get (include/linux/netfilter.h:24).
> 19  static inline int nf_inet_addr_cmp(const union nf_inet_addr *a1,
> 20                     const union nf_inet_addr *a2)
> 21  {
> 22      return a1->all[0] =3D=3D a2->all[0] &&
> 23             a1->all[1] =3D=3D a2->all[1] &&
> 24             a1->all[2] =3D=3D a2->all[2] &&
> 25             a1->all[3] =3D=3D a2->all[3];
> 26  }
> 27 =20
> 28  static inline void nf_inet_addr_mask(const union nf_inet_addr *a1=
,
>=20
> Basically, I have two questions=A0:
>=20
>  * Did I understand correctly the backtrace, and did I dig at the goo=
d
>    place? (okay, that's already two questions)
>  * Admitting I'm good in my research, the only way this code would cr=
ash
>    would be if a1 or a2 is a pointer to a NULL or non-dereferencable
>    address. I guess that'd mean no IP address has been provided in a1=
 or a2.
>    Would it be a bug in the kernel or a bug in a software that propag=
ates to
>    the kernel?
>=20
> How could I investigate further more?
>=20
> Thanks for your help, and in advance, I apologize for the noise.

Dear netfilter developers,

May I ask you for some help regarding a kernel panic backtracking that =
I
submitted on linux-kernel mailing list two days ago, but which should
probably have been sent directly to you?

Thanks in advance for your help.

--=20
PEB
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
