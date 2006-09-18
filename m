From: "saravanan chanemouganandam" <saravanan_sprt@hotmail.com>
Subject: netfilter problem
Date: Mon, 18 Sep 2006 17:46:59 +0530
Message-ID: <BAY114-F28742995E28F10CCFFB17AE22D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I have a problem in compiling "netfilter" for Iptables support into the 
linux 2.6.12 kernel version. I have manually enabled the config option 
"CONFIG_NETFILTER=y" and all netfilter configuration CONFIG_IP_NF_* manually 
in to the "mainstone_defconfig" file for my target arm board.

Now, the problem is that, on "make vmlinux", the files under the 
"linux/2.6.12/net/ipv4/netfilter" directory doesn't gets compiled leaving 
built-in.o and this annoys me a lot.

Could any one please precise me, what are the options I need to check or 
enable in the config, Kconfig or in Makefile to get the "netfilter" compiled 
into my kernel?

Thanks.

Regards,
Sara
