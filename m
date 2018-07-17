From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH net] netfilter: nf_conntrack: prevent uninit-value in gc_worker
Date: Tue, 17 Jul 2018 16:26:25 +0200
Message-ID: <CACT4Y+YhzR30WZSX52KtFjOMnOi=nL0tk8yAdLACY81YesJ9zQ@mail.gmail.com>
References: <20180712004037.197064-1-edumazet@google.com> <20180712090044.lwukow7nqzzht67g@breakpoint.cc>
 <9a877bfc-67f3-2242-a681-5814dc1c1dd4@gmail.com> <CACT4Y+buOFu2CLkGoqupQSHYpuxDsUPPdfSmpDa_6Sht9LesTQ@mail.gmail.com>
 <20180717135931.dexnlxtnv3daunit@breakpoint.cc> <CACT4Y+bMbU=hjhafhu2foGzz3poeH364859PaDeS2_rqPsKtGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+bMbU=hjhafhu2foGzz3poeH364859PaDeS2_rqPsKtGg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 17, 2018 at 4:13 PM, Dmitry Vyukov <dvyukov@google.com> wrote:
> On Tue, Jul 17, 2018 at 3:59 PM, Florian Westphal <fw@strlen.de> wrote:
>> Dmitry Vyukov <dvyukov@google.com> wrote:
>>> What should have been initialized it?
>>
>> nf_ct_refresh_acct()
>>
>>> I assume it should have been happened in between init_conntrack and
>>> nf_conntrack_confirm, because nf_conntrack_confirm already adds to an
>>> uninit timeout value.
>>
>> Yes.
>>
>>> Since we got only 3 such reports and no reproducer, I would suspect
>>> that there is some race involved. Is it possible that timeout
>>> initialization (presumably a call to nf_ct_refresh_acct) happens after
>>> and non-atomically with the corresponding connection state update, so
>>> that the call to nf_conntrack_confirm sneaks before it?
>>
>> Unconfirmed conntrack isn't in the hash table, so all events should
>> occur in order on same cpu:
>> 1. allocation (init_conntrack)
>> 2. timeout initialisation (via l4 tracker, can be generic one too)
>> 3. nf_conntrack_confirm (insertion in hash table)
>>
>> What could be possible is that another core is registering/unregistering
>> the conntrack hooks in parallel, I guess in that case we could have:
>>
>> 1. allocation (init_conntrack)
>> (other cpu: remove conntrack hooks)
>> (other cpu: add conntrack hooks)
>> 3. nf_conntrack_confirm (insertion in hash table)
>>
>> Just a theory of course.
>> In any case patch looks good to me.
>
>
>
> We also got 30 of the following reports, which look quite similar.
> That bug also have 2 reproducers, but they look more or less as just
> sending a packet:
>
> # See https://goo.gl/kgGztJ for information about syzkaller reproducers.
> #{"threaded":true,"repeat":true,"procs":8,"sandbox":"","fault_call":-1}
> r0 =3D socket$inet6(0xa, 0x3, 0x20000000021)
> sendto$inet6(r0, &(0x7f0000000000), 0xfedf, 0x0,
> &(0x7f0000000180)=3D{0xa, 0x0, 0x0, @local=3D{0xfe, 0x80, [], 0xaa}},
> 0x1a)
> openat$snapshot(0xffffffffffffff9c,
> &(0x7f0000000000)=3D'/dev/snapshot\x00', 0xa0000, 0x0)
>
>
> # See https://goo.gl/kgGztJ for information about syzkaller reproducers.
> #{"repeat":true,"procs":1,"sandbox":"none","fault_call":-1,"netdev":true}
> r0 =3D socket$inet6(0xa, 0x3, 0x3c)
> connect$inet6(r0, &(0x7f0000000180)=3D{0xa, 0x0, 0x0, @remote=3D{0xfe,
> 0x80, [], 0xbb}, 0x9}, 0x1c)
> sendto$inet6(r0, &(0x7f0000000200)=3D'!', 0x1, 0x8000, 0x0, 0x0)
> sendmsg(r0, &(0x7f0000000040)=3D{0x0, 0x0,
> &(0x7f0000000080)=3D[{&(0x7f0000000300)=3D"119a0e63c9476288b671afdbd53a59=
94e137381f62021d1951b627b8dda57a5d17d744648c81c5703ed8146ab1b0171f89091b1dd=
323ff07dbb633fb3804849f7768e586df460963245dedb4013ee555af99499e44ad420dbf65=
fd46fbc9ba1274429e2d5783751815828ec8cb3553110cca66460215353d19f6d8bbd8fb08a=
d0491634ac2fd10e2cd30bcd7fede24263a7fff16e53ea293f3551b7147c33a44ea437fb1f7=
7f94db4e65807582990a0a5efddf12de3caea6611173f964de99645e2c02bef138b406ca064=
4146ae4bb91e0438f8c47beddb0ed22f56bc0851def35824ca6c7258c",
> 0xe7}], 0x1, &(0x7f0000003b40)}, 0x0)
>
>
>
>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in ____nf_conntrack_find
> net/netfilter/nf_conntrack_core.c:539 [inline]
> BUG: KMSAN: uninit-value in __nf_conntrack_find_get+0xc15/0x2190
> net/netfilter/nf_conntrack_core.c:573
> CPU: 0 PID: 4610 Comm: syz-executor884 Not tainted 4.18.0-rc4+ #24
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x185/0x1e0 lib/dump_stack.c:113
>  kmsan_report+0x195/0x2c0 mm/kmsan/kmsan.c:1092
>  __msan_warning_32+0x7d/0xe0 mm/kmsan/kmsan_instr.c:640
>  ____nf_conntrack_find net/netfilter/nf_conntrack_core.c:539 [inline]
>  __nf_conntrack_find_get+0xc15/0x2190 net/netfilter/nf_conntrack_core.c:5=
73
>  resolve_normal_ct net/netfilter/nf_conntrack_core.c:1331 [inline]
>  nf_conntrack_in+0x1674/0x2070 net/netfilter/nf_conntrack_core.c:1416
>  ipv6_conntrack_local+0xc3/0xf0
> net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:179
>  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
>  nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
>  nf_hook include/linux/netfilter.h:242 [inline]
>  __ip6_local_out+0x64c/0x770 net/ipv6/output_core.c:164
>  ip6_local_out+0xa4/0x1d0 net/ipv6/output_core.c:174
>  ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
>  ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
>  rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
>  rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
>  inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:641 [inline]
>  sock_sendmsg net/socket.c:651 [inline]
>  __sys_sendto+0x798/0x8e0 net/socket.c:1797
>  __do_sys_sendto net/socket.c:1809 [inline]
>  __se_sys_sendto net/socket.c:1805 [inline]
>  __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
>  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> RIP: 0033:0x4459c9
> Code: e8 bc e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 0f 83 2b 0e fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007fa03df22d98 EFLAGS: 00000212 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00000000006dac24 RCX: 00000000004459c9
> RDX: 000000000000fedf RSI: 0000000020000000 RDI: 0000000000000004
> RBP: 0000000000000000 R08: 0000000020000180 R09: 000000000000001a
> R10: 0000000000000000 R11: 0000000000000212 R12: 00000000006dac20
> R13: 616e732f7665642f R14: 00007fa03df239c0 R15: 0000000000000001
>
> Uninit was stored to memory at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
>  kmsan_save_stack mm/kmsan/kmsan.c:271 [inline]
>  kmsan_internal_chain_origin+0x13c/0x240 mm/kmsan/kmsan.c:683
>  __msan_chain_origin+0x76/0xd0 mm/kmsan/kmsan_instr.c:483
>  __nf_conntrack_confirm+0x2700/0x3f70 net/netfilter/nf_conntrack_core.c:7=
93
>  nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:71 [inlin=
e]
>  ipv6_confirm+0x573/0x740 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:=
165
>  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
>  nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
>  nf_hook include/linux/netfilter.h:242 [inline]
>  NF_HOOK_COND include/linux/netfilter.h:275 [inline]
>  ip6_output+0x37d/0x710 net/ipv6/ip6_output.c:171
>  dst_output include/net/dst.h:444 [inline]
>  ip6_local_out+0x164/0x1d0 net/ipv6/output_core.c:176
>  ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
>  ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
>  rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
>  rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
>  inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:641 [inline]
>  sock_sendmsg net/socket.c:651 [inline]
>  __sys_sendto+0x798/0x8e0 net/socket.c:1797
>  __do_sys_sendto net/socket.c:1809 [inline]
>  __se_sys_sendto net/socket.c:1805 [inline]
>  __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
>  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
>
> Uninit was created at:
>  kmsan_save_stack_with_flags mm/kmsan/kmsan.c:256 [inline]
>  kmsan_internal_poison_shadow+0xc8/0x1d0 mm/kmsan/kmsan.c:181
>  kmsan_kmalloc+0xa1/0x120 mm/kmsan/kmsan_hooks.c:91
>  kmem_cache_alloc+0xad2/0xbb0 mm/slub.c:2739
>  __nf_conntrack_alloc+0x166/0x670 net/netfilter/nf_conntrack_core.c:1137
>  init_conntrack+0x635/0x2840 net/netfilter/nf_conntrack_core.c:1219
>  resolve_normal_ct net/netfilter/nf_conntrack_core.c:1333 [inline]
>  nf_conntrack_in+0x1812/0x2070 net/netfilter/nf_conntrack_core.c:1416
>  ipv6_conntrack_local+0xc3/0xf0
> net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c:179
>  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
>  nf_hook_slow+0x15d/0x3e0 net/netfilter/core.c:511
>  nf_hook include/linux/netfilter.h:242 [inline]
>  __ip6_local_out+0x64c/0x770 net/ipv6/output_core.c:164
>  ip6_local_out+0xa4/0x1d0 net/ipv6/output_core.c:174
>  ip6_send_skb net/ipv6/ip6_output.c:1696 [inline]
>  ip6_push_pending_frames+0x218/0x4d0 net/ipv6/ip6_output.c:1716
>  rawv6_push_pending_frames net/ipv6/raw.c:616 [inline]
>  rawv6_sendmsg+0x45f0/0x5410 net/ipv6/raw.c:935
>  inet_sendmsg+0x3fc/0x760 net/ipv4/af_inet.c:798
>  sock_sendmsg_nosec net/socket.c:641 [inline]
>  sock_sendmsg net/socket.c:651 [inline]
>  __sys_sendto+0x798/0x8e0 net/socket.c:1797
>  __do_sys_sendto net/socket.c:1809 [inline]
>  __se_sys_sendto net/socket.c:1805 [inline]
>  __x64_sys_sendto+0x1a1/0x210 net/socket.c:1805
>  do_syscall_64+0x15b/0x230 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x63/0xe7
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Here is that bug:

https://syzkaller.appspot.com/bug?extid=3D6f18401420df260e37ed
https://groups.google.com/forum/#!msg/syzkaller-bugs/F7KnbAmMa7E/VSbaYHyQCA=
AJ
