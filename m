From: husnu demir <hdemir@metu.edu.tr>
Subject: Compile errors for debian-amd64
Date: Tue, 8 May 2007 14:09:05 +0300
Message-ID: <20070508110905.GA3768482@metu.edu.tr>
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

Hi,

I am getting compile errors on debian-amd64. Can somebody point me correct place?


hdemir.

Thanks.

# uname -a
Linux auth 2.6.18.8 #2 SMP Tue May 1 06:43:45 EDT 2007 x86_64 GNU/Linux



compile for linux-2.6.21.1

# make 
..
..

  OBJCOPY arch/x86_64/boot/vmlinux.bin
  HOSTCC  arch/x86_64/boot/tools/build
  BUILD   arch/x86_64/boot/bzImage
Root device is (104, 1)
Boot sector 512 bytes.
Setup is 7343 bytes.
System is 1742 kB
Kernel: arch/x86_64/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 754 modules
WARNING: "ip6t_register_target" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!
WARNING: "ip6t_unregister_target" [net/ipv6/netfilter/ip6t_ROUTE.ko] undefined!
WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_connlimit.ko] undefined!
WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_connlimit.ko] undefined!
WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_ROUTE.ko] undefined!
WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_ROUTE.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


All the added modules gave the same error for the PoM-ng. I select the "Layer 3 Independent Connection tracking". 
