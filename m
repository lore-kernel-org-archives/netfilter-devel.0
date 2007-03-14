From: Nick Pasich <NewsLetters@NickAndBarb.net>
Subject: Problems Compiling Geoip on linux-2.6.21-rc3
Date: Wed, 14 Mar 2007 09:58:17 -0700
Message-ID: <20070314165817.GA22948@69.17.112.251>
References: <200703080637.WAA05730@NickAndBarb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Samuel Jean <jix@bugmachine.ca>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <200703080637.WAA05730@NickAndBarb.net>
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


Samuel,

Problem occurr when compiling geoip for Linux Kernel 2.6.21rc1 -> rc3 

Errors shown below.....

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
