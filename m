From: CaT <cat@zip.com.au>
Subject: 2.5.65: sleeping function called from illegal context
Date: Tue, 18 Mar 2003 20:16:01 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030318091601.GE504__46154.1906734512$1048415432@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
   pekkas@netcore.fi
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

I'm not sure if there was a fix produced for this, but this bug is still
present in 2.5.56:

kernel: eth0: no IPv6 routers present
kernel: Debug: sleeping function called from illegal context at include/linux/rwsem.h:43
kernel: Call Trace:
kernel:  [__might_sleep+84/92] __might_sleep+0x54/0x5c
kernel:  [crypto_alg_lookup+33/208] crypto_alg_lookup+0x21/0xd0
kernel:  [crypto_alg_mod_lookup+13/52] crypto_alg_mod_lookup+0xd/0x34
kernel:  [crypto_alloc_tfm+17/192] crypto_alloc_tfm+0x11/0xc0
kernel:  [__ipv6_regen_rndid+160/500] __ipv6_regen_rndid+0xa0/0x1f4
kernel:  [wake_up_process+13/20] wake_up_process+0xd/0x14
kernel:  [ipv6_regen_rndid+46/196] ipv6_regen_rndid+0x2e/0xc4
kernel:  [run_timer_softirq+241/324] run_timer_softirq+0xf1/0x144
kernel:  [ipv6_regen_rndid+0/196] ipv6_regen_rndid+0x0/0xc4
kernel:  [do_softirq+81/176] do_softirq+0x51/0xb0
kernel:  [do_IRQ+244/272] do_IRQ+0xf4/0x110
kernel:  [default_idle+0/52] default_idle+0x0/0x34
kernel:  [default_idle+0/52] default_idle+0x0/0x34
kernel:  [common_interrupt+24/32] common_interrupt+0x18/0x20
kernel:  [default_idle+0/52] default_idle+0x0/0x34
kernel:  [default_idle+0/52] default_idle+0x0/0x34
kernel:  [default_idle+38/52] default_idle+0x26/0x34
kernel:  [cpu_idle+53/68] cpu_idle+0x35/0x44
kernel:  [rest_init+0/92] _stext+0x0/0x5c
kernel:  [rest_init+85/92] _stext+0x55/0x5c
kernel: 
kernel: __ipv6_regen_rndid(): too short regeneration interval; timer diabled for eth0.

-- 
"Other countries of course, bear the same risk. But there's no doubt his
hatred is mainly directed at us. After all this is the guy who tried to
kill my dad."
        - George W. Bush Jr, 'President' of Regime of the United States
          September 26, 2002 (from a political fundraiser in Huston, Texas)
