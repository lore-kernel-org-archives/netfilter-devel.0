From: Glen Turner <glen.turner@aarnet.edu.au>
Subject: Patch-o-matic says "unable to find ladd slot" in Makefile
Date: Wed, 04 Oct 2006 16:42:28 +0930
Message-ID: <45235EDC.4080709@aarnet.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


Hi folks,

I've written a patch for the Linux kernel and for iptables
which adds a TCPCONG netfilter target to set the TCP congestion
control algorithm.  Now I can run a different algorithm for
traffic using the the WLAN interface than for traffic using
the wired interface.  Code at
   <http://www.aarnet.edu.au/~gdt/patch/tcpcong/>

I've tried my best to follow the instructions at
   .../patch-o-matic-ng/README.newpatches
which I think asks that a file
   .../patch-o-matic-ng/patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Makefile.ladd
be created containing
   obj-$(CONFIG_IP_NF_TARGET_TCPCONG) += ipt_TCPCONG.o
rather than this being left in the
   .../patch-o-matic-ng/patchlets/TCPCONG/linux-2.6.patch
file.

Unfortunately when I run patch-o-matic
   KERNEL_DIR=~/linux-2.6.18  \
   IPTABLES_DIR=~/iptables-1.3.6  \
   ./runme base
I get this error

> Testing TCPCONG... not applied
> The TCPCONG patch:
>    Author: Glen Turner, <glen d turner a aarnet d edu d au>
>    Status: Beta
> This target sets the TCP congestion control algorithm.
> -----------------------------------------------------------------
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
> unable to find ladd slot in src /home/gdt/linux-2.6.18/net/ipv4/netfilter/Makefile (./patchlets/TCPCONG/linux-2.6/./net/ipv4/netfilter/Makefile.ladd)
> -----------------------------------------------------------------

Should I have left the change to net/ipv4/netfilter/Makefile
in the file linux-2.6.patch? Or is some other magic required?

Thanks muchly,
Glen

-- 
  Glen Turner         Tel: (08) 8303 3936 or +61 8 8303 3936
  Australia's Academic & Research Network  www.aarnet.edu.au
