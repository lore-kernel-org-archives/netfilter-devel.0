From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Thu, 10 May 2007 08:34:07 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sparclinux@vger.kernel.org
To: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On May 10 2007 08:27, Jan Engelhardt wrote:
>Hi,
>
>
>the following command gives an error:
>
>	iptables -t mangle -I FORWARD -m conntrack --ctstate NEW
>
>output is:
>
>	iptables: Unknown error 4294967295
>
>As mentioned in the topic, I suspect it is due to 32-bit iptables not 
>coping correctly with the 64-bit kernel (sometimes, patches to fix these 
>are posted, so I thought it could be related). OS is Aurora Linux 2.98, 
>with their latest(?) kernel 2.6.20-1.2986.al3.3smp.

And the following cmd oopsed it:

	# iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW
	-j sshcheck;

Output:

Unable to handle kernel NULL pointer dereference
tsk->{mm,active_mm}->context = 000000000000078d
tsk->{mm,active_mm}->pgd = fffff80055a48000
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
iptables(9865): Oops [#1]
TSTATE: 0000009911009606 TPC: 000000000052853c TNPC: 0000000000528540 Y:
00000000    Not tainted
TPC: <atomic_sub_ret+0xc/0x30>
g0: fffff8001fdf4000 g1: 000000001029a340
g2: 00000000000000c8 g3: 0000000000000000
g4: fffff8007fbe6f00 g5: fffff80000e80000
g6: fffff8001fdf4000 g7: 0000000000000005
o0: 0000000000000001 o1: 0000000000000010
o2: 0000000010284810 o3: 0000000000000050
o4: 0000000000000048 o5: 0000000000000640
sp: fffff8001fdf70a1 ret_pc: 000000001029a350
RPC: <hashlimit_destroy+0x18/0xc0 [xt_hashlimit]>
l0: 000000001028f000 l1: 0000000000000000
l2: 0000000000000040 l3: 0000000000000000
l4: 0000000000030bbc l5: 000000000002f690
l6: 0000000000031600 l7: 000000000002ca50
i0: 0000000000000000 i1: 000000001029d400
i2: 0000000010284800 i3: fffff8001a0fb4a0
i4: 0000000000000002 i5: 0000000000000006
i6: fffff8001fdf7161 i7: 000000001022a2a8
I7: <compat_do_ipt_set_ctl+0x7d4/0xa04 [ip_tables]>
Caller[000000001022a2a8]: compat_do_ipt_set_ctl+0x7d4/0xa04 [ip_tables]
Caller[00000000006155b4]: compat_nf_sockopt+0x130/0x16c
Caller[0000000000615628]: compat_nf_setsockopt+0x24/0x30
Caller[0000000000623e74]: compat_ip_setsockopt+0xac/0xc0
Caller[00000000005f10e4]: compat_sock_common_setsockopt+0x48/0x54
Caller[0000000000609ba0]: compat_sys_setsockopt+0x4b4/0x4ec
Caller[0000000000406c14]: linux_sparc_syscall32+0x3c/0x40
Caller[0000000000019340]: 0x19348
Instruction DUMP: 81c3e008  01000000  8143e003 <c2024000> 8e204008  cfe25001
80a04007  1247fffc  8e21c008



	Jan
-- 
