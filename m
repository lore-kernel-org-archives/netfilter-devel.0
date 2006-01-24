From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ipsec01-02-03-04 installation problem
Date: Tue, 24 Jan 2006 10:29:29 +0900 (JST)
Message-ID: <200601240129.k0O1TU1x016818@toshiba.co.jp>
References: <BAY103-F166820039D0DD7F961ADB2B21C0@phx.gbl>
	<00f401c61f53$6e586030$0201a8c0@gorionstable>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	pupilla@hotmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: webmaster@elnportal.it
In-Reply-To: <00f401c61f53$6e586030$0201a8c0@gorionstable>
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

You may already resolve this, but anyway,

From: "webmaster @ elnportal.it" <webmaster@elnportal.it>
Date: Sun, 22 Jan 2006 13:57:29 +0100

> Here the passages followed for installing iptables with SNAT support through 
> ipsec tunnel:
> 
> 1_ Downloaded from kernel.org 2.6.16-rc1.tar.bz2 kernel
> 2_ untarred it to /usr/src
> 3_ make mrproper
> 4_ copy an old .config file from 2.6.14 sources (Fedora Core 4)
> 5_ ln -s linux-2.6.16-rc1/ linux
> 6_ make oldconfig (hitting enter on all query)
> 7_ make menuconfig
> 8_ XFRM [IPSec] Networking Security Hooks

I think you need to re-configure netfilter related items. 

Please go to the menu "Network packet filtering (replaces ipchains)",
enable "Netfilter Xtables support (required for ip_tables)",
and enable matches/targets you want use. You may also need to re-configure
"IP: Netfilter Configuration" and "IPv6: Netfilter Configuration"
if you want to use them.

> 9_ Exit and save kernel configuration
> 10_ make all
> 11_ make modules_install
> 12_ make install
> 13_ reboot
> 
> 14_ rpm -e --nodep iptables
> 15_ untar tarball (snapshot of iptables)
> 16_ make (under src directory of iptables)
> 17_ make install
> 18_ iptables -L
> 
> iptables v1.3.4-20060121: can't initialize iptables table `filter': iptables 
> who? (do you need to insmod?)
> Perhaps iptables or your kernel needs to be upgraded.

Regards,

-- Yasuyuki Kozakai
