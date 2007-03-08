From: Nick Pasich <NewsLetters@NickAndBarb.net>
Subject: Problems With Geoip and linux-2.6.21-rc3
Date: Wed, 7 Mar 2007 16:02:09 -0800
Message-ID: <20070308000209.GA11071@69.17.112.251>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


All of the Linux Kernel 2.6.21rc1->3 have problems compiling geoip 


       Thanks,

         Nick Pasich


*****************************************************************************
*****************************************************************************

Kernel: arch/i386/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 256 modules
WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_geoip.ko] undefined!
WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_geoip.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

*****************************************************************************
*****************************************************************************
