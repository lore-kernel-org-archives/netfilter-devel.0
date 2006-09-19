From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: netfilter problem
Date: Tue, 19 Sep 2006 13:47:33 +0900 (JST)
Message-ID: <200609190447.k8J4lYZI002909@toshiba.co.jp>
References: <BAY114-F28742995E28F10CCFFB17AE22D0@phx.gbl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: saravanan_sprt@hotmail.com
In-Reply-To: <BAY114-F28742995E28F10CCFFB17AE22D0@phx.gbl>
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

From: "saravanan chanemouganandam" <saravanan_sprt@hotmail.com>
Date: Mon, 18 Sep 2006 17:46:59 +0530

> Hi,
> 
> I have a problem in compiling "netfilter" for Iptables support into the 
> linux 2.6.12 kernel version. I have manually enabled the config option 
> "CONFIG_NETFILTER=y" and all netfilter configuration CONFIG_IP_NF_* manually 
> in to the "mainstone_defconfig" file for my target arm board.
> 
> Now, the problem is that, on "make vmlinux", the files under the 
> "linux/2.6.12/net/ipv4/netfilter" directory doesn't gets compiled leaving 
> built-in.o and this annoys me a lot.
> 
> Could any one please precise me, what are the options I need to check or 
> enable in the config, Kconfig or in Makefile to get the "netfilter" compiled 
> into my kernel?

If you run 'make menuconfig' on the other machine, you will see that some
CONFIG_IP_NF_* are moved to CONFIG_NETFILTER_XT_* and NETFILTER_XTABLES is
added.

-- Yasuyuki Kozakai
