From: "Chad Goss" <chgoss@nortel.com>
Subject: RE: Having trouble building a new connection tracker helper modul e
Date: Wed, 9 Mar 2005 13:08:55 -0500
Message-ID: <8B888AAAAB0FD31189590008C791844326448CF1@zbl6c002.corpeast.baynetworks.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@lists.netfilter.org
To: Sven Schuster <schuster.sven@gmx.de>
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

Thanks for the quick response!

But, after changing the $KERNEL_DIR/net/ipv4/netfilter/Kconfig
File as suggested, and running "make menuconfig" from $KERNEL_DIR, I don't
see where the option "IP_NF_CFTP" is...

For that matter, I don't see where (in menuconfig GUI, or xconfig GUI) any
of the options listed in $KERNEL_DIR/net/ipv4/netfilter/Kconfig
Are available for setting...


Looking in  $KERNEL_DIR/arch/i386/Kconfig  file, I don't see where it
sources $KERNEL_DIR/net/ipv4/netfilter/Kconfig, or alternatively, sources
$KERNEL_DIR/net/Kconfig (which does source /net/ipv4/netfilter/Kconfig)

So I added the line "source "net/Kconfig"" in $KERNEL_DIR/arch/i386/Kconfig
But got the following error when I tried to "make xconfig" in $KERNEL_DIR


[root@chgoss3 linux-2.6.10]# make xconfig scripts/kconfig/qconf
arch/i386/Kconfig Session management error: Authentication Rejected, reason
: None of the authentication protocols specified are supported and
host-based authentication failed 
file net/Kconfig already scanned? 
make[1]: *** [xconfig] Error 1 
make: *** [xconfig] Error 2 
[root@chgoss3 linux-2.6.10]#  


Appreciate your time
-chad


-----Original Message-----
From: Sven Schuster [mailto:schuster.sven@gmx.de] 
Sent: Tuesday, March 08, 2005 6:02 PM
To: Goss, Chad [BL60:437:EXCH]
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Having trouble building a new connection tracker helper module



Hi Chad,

On Tue, Mar 08, 2005 at 05:38:39PM -0500, Chad Goss told us:
> Hi folks,
> 
> I am trying to compile a new connection tracker helper module, I have
> 1) downloaded 2.6.10 kernel source
> 
> 2) built a fresh kernel from that source
> 
> 3) created a new file "ip_conntrack_cftp.c" in 
> $KERNEL_DIR/net/ipv4/netfilter/
>   (basically just copied the file ip_conntrack_tftp.c and changed all 
> of "tftp" text to "cftp", "TFTP" to "CFTP"
> 
> 4) created a new file "ip_conntrack_cftp.h" in 
> $KERNEL_DIR/include/linux/netfilter_ipv4,
>   (copied ip_conntrack_tftp.h to ip_conntrack_cftp.h and made the 
> adjustments to the text strings)
> 
> 5) updated the $KERNEL_DIR/net/ipv4/netfilter/Makefile adding a line
> 	# connection tracking helpers
> 	obj-$(CONFIG_IP_NF_CFTP) += ip_conntrack_cftp.o
> 	

probably missing:

5a) copy the config IP_NF_TFTP entry and the lines following it in file
    $KERNEL_DIR/net/ipv4/netfilter/Kconfig
    and adjust TFTP to CFTP in the copy

5b) make menuconfig in $KERNEL_DIR, select the new CFTP entry

> 
> 6) attempted to make that directory "make -C $KERNEL_DIR  M=`pwd`
> 	(executed from $KERNEL_DIR/net/ipv4/netfilter/ )

don't know if it might be better just to call make from $KERNELDIR


HTH

Sven

> 
> 
> But, I don't see any .ko, or .o or .mod.c files getting created... 
> What step am I missing?
> 
> Thanks in advance
> -chad
> 
> 
> 
> 

-- 
Linux zion 2.6.11-mm1 #1 Sat Mar 5 13:54:40 CET 2005 i686 athlon i386
GNU/Linux  23:57:01 up 3 days,  3:02,  2 users,  load average: 0.01, 0.05,
0.06
