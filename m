From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Patch-o-matic says "unable to find ladd slot" in Makefile
Date: Wed, 04 Oct 2006 21:54:51 +0200
Message-ID: <4524118B.4020903@netfilter.org>
References: <45235EDC.4080709@aarnet.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Glen Turner <glen.turner@aarnet.edu.au>
In-Reply-To: <45235EDC.4080709@aarnet.edu.au>
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

Glen Turner wrote:
> 
> Hi folks,
> 
> I've written a patch for the Linux kernel and for iptables
> which adds a TCPCONG netfilter target to set the TCP congestion
> control algorithm.  Now I can run a different algorithm for
> traffic using the the WLAN interface than for traffic using
> the wired interface.  Code at
>   <http://www.aarnet.edu.au/~gdt/patch/tcpcong/>
> 
> I've tried my best to follow the instructions at
>   .../patch-o-matic-ng/README.newpatches
> which I think asks that a file
>  
> .../patch-o-matic-ng/patchlets/TCPCONG/linux-2.6/net/ipv4/netfilter/Makefile.ladd
> 
> be created containing
>   obj-$(CONFIG_IP_NF_TARGET_TCPCONG) += ipt_TCPCONG.o

You have to add some context to let pom know where you want to place
that line, for example:

:~/SVN/trunk/patch-o-matic-ng/patchlets/XOR/linux-2.6/net/ipv4/netfilter$
 cat Makefile.ladd
obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
obj-$(CONFIG_IP_NF_TARGET_XOR) += ipt_XOR.o

This tells that the ipt_XOR must be after the ipt_LOG line.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
