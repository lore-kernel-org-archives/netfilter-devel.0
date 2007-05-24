From: Andrea <andang76@gmail.com>
Subject: Re: problems applying ipset patch
Date: Thu, 24 May 2007 11:39:40 +0200
Message-ID: <46555D5C.7030406@gmail.com>
References: <4653F176.4040604@gmail.com>	
	<1179908784.18674.39.camel@henriknordstrom.net>	
	<4654006D.9050704@gmail.com>	
	<1179910939.18674.46.camel@henriknordstrom.net>	
	<4654051E.8060508@gmail.com>
	<1179914093.18674.65.camel@henriknordstrom.net>
	<46543EDD.8040009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46543EDD.8040009@gmail.com>
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

Andrea ha scritto:
> Henrik Nordstrom ha scritto:
>> ons 2007-05-23 klockan 11:10 +0200 skrev Andrea:
>>
>>> 2.6.16.51 has been released in 09 May 2007, as stated in 
>>> http://www.kernel.org/pub/linux/kernel/v2.6/?C=M;O=A
>>
>> Well, it's mostly 2.6.16 which is more than a year old.
> 

Tried again with   linux-2.6.21.1 kernel. It seems that kernet has been 
compiled, but I've these warnings and errors:

make all


....
Root device is (253, 0)
Boot sector 512 bytes.
Setup is 7354 bytes.
System is 1559 kB
Kernel: arch/i386/boot/bzImage is ready  (#1)
   Building modules, stage 2.
   MODPOST 758 modules
WARNING: drivers/atm/lanai.o - Section mismatch: reference to 
.init.text: from . 
                        text between 'sram_test_pass' (at offset 0x171) 
and 'sram_test_and_clear'
WARNING: drivers/net/sis900.o - Section mismatch: reference to 
.init.text:sis900 
                       _mii_probe from .text between 'sis900_probe' (at 
offset 0x4ce) and 'sis900_defau 
                                     lt_phy'
WARNING: drivers/net/sunhme.o - Section mismatch: reference to 
.init.text: from 
                       .text between 'happy_meal_pci_probe' (at offset 
0x289c) and 'happy_meal_pci_remo 
                                      ve'
WARNING: drivers/net/tokenring/3c359.o - Section mismatch: reference to 
.init.te 
              xt:xl_init from .text between 'xl_probe' (at offset 0x203) 
and 'xl_hw_reset'
WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_set.ko] undefined!
WARNING: "ipt_unregister_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
WARNING: "ipt_register_target" [net/ipv4/netfilter/ipt_SET.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


Maybe because I've iptables just installed, before kernel recompilation?
are these warnings important?
