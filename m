From: Andrea <andang76@gmail.com>
Subject: problems applying ipset patch
Date: Wed, 23 May 2007 09:47:02 +0200
Message-ID: <4653F176.4040604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

I've tried to apply the ipset patch in my CentOS 4.4 distribution, 
without success.

I've followed instructions here 
http://www.howtoforge.com/kernel_compilation_centos_p2?s=aabdb730a09fa747d00f2b9a3ff431cc& 
   (CentOS Kernel Compile) and here 
http://ipset.netfilter.org/install.html (ipset patch apply).

The patch is applied successfully, but when I try to recompile, I obtain 
these errors (after a long list of compiled files):

...
   LD      .tmp_vmlinux1
net/built-in.o(.init.text+0x16f1): In function `ipt_ipset_init':
net/ipv4/netfilter/ipt_set.c:133: undefined reference to `xt_register_match'
net/built-in.o(.init.text+0x1700): In function `ipt_SET_init':
net/ipv4/netfilter/ipt_SET.c:151: undefined reference to 
`xt_register_target'
net/built-in.o(.exit.text+0x41): In function `ipt_ipset_fini':
net/ipv4/netfilter/ipt_set.c:138: undefined reference to 
`xt_unregister_match'
net/built-in.o(.exit.text+0x50): In function `ipt_SET_fini':
net/ipv4/netfilter/ipt_SET.c:156: undefined reference to 
`xt_unregister_target'
make: *** [.tmp_vmlinux1] Error 1

I've tried twice, using two combinations of kernel (downloaded from 
www.kernel.org) and patch-o-matic (downloaded first time from 
http://ipset.netfilter.org/, second from patch-o-matic snaptshots).

I've applied only the ipset patch (launching only the  ./runme set 
command, just as explained in the ipset site).

Maybe do I need to apply other patches from patch-o-matic?

Thanks for the help
