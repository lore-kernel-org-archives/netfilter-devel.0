From: David Miller <davem@davemloft.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Thu, 10 May 2007 00:16:43 -0700 (PDT)
Message-ID: <20070510.001643.75191263.davem@davemloft.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, sparclinux@vger.kernel.org
To: jengelh@linux01.gwdg.de
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705100832050.32349@yvahk01.tjqt.qr>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Date: Thu, 10 May 2007 08:34:07 +0200 (MEST)

> Unable to handle kernel NULL pointer dereference
> tsk->{mm,active_mm}->context = 000000000000078d
> tsk->{mm,active_mm}->pgd = fffff80055a48000
>               \|/ ____ \|/
>               "@'/ .. \`@"
>               /_| \__/ |_\
>                  \__U_/
> iptables(9865): Oops [#1]
> TSTATE: 0000009911009606 TPC: 000000000052853c TNPC: 0000000000528540 Y:
> 00000000    Not tainted
> TPC: <atomic_sub_ret+0xc/0x30>
> g0: fffff8001fdf4000 g1: 000000001029a340
> g2: 00000000000000c8 g3: 0000000000000000
> g4: fffff8007fbe6f00 g5: fffff80000e80000
> g6: fffff8001fdf4000 g7: 0000000000000005
> o0: 0000000000000001 o1: 0000000000000010
> o2: 0000000010284810 o3: 0000000000000050
> o4: 0000000000000048 o5: 0000000000000640
> sp: fffff8001fdf70a1 ret_pc: 000000001029a350
> RPC: <hashlimit_destroy+0x18/0xc0 [xt_hashlimit]>

in hashlimit_destroy(), r->hinfo is NULL, and this NULL pointer
is being passed to atomic_sub_ret() via htable_put()'s

	if (atomic_dec_and_test(&hinfo->use))

call.

It would be interesting if the current 2.6.21 vanilla kernel
gives you the same problem, please built that and retest because
I believe some compat issues were fixed between 2.6.20 and
2.6.21

Thanks.

