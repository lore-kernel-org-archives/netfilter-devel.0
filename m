From: Patrick McHardy <kaber@trash.net>
Subject: Re: Kernel Panic when using iptables NAT rules with kernel 2.6.16.9
Date: Sat, 22 Apr 2006 00:01:34 +0200
Message-ID: <4449563E.9000504@trash.net>
References: <20060421133139.32090.qmail@webhost66.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964789AbWDUWEY@vger.kernel.org>
To: noip <noip@webhost66.com>
In-Reply-To: <20060421133139.32090.qmail@webhost66.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

noip wrote:
> Hello,
>   
> After the upgrade to kernel 2.6.16.9 i'm receiving a kernel panic almost immediately when I enter my iptables REDIRECT rules. If I don't enter these rules, the machine works fine.
> I've observed this behavior on all of my machines that are running Broadcom Gbit Ethernet cards using tg3 driver.
> On my office machine with the same kernel and the same iptables rules there is no such problem - I have an Intel 10/100 Ethernet card.
> My kernel is patched with the Grsecurity patch and with the connlimit patch.
> I've tried the same setup without Gresecurity but the problem was still there.

Which kernel version did you run before that?

> My iptables version is 1.3.5.
>  
> My kernel config - http://server260.com/panic/kerncfg
> A screenshot with the panic - http://server260.com/panic/panic.gif

The interesting part scrolled off the screen, please set
CONFIG_STACK_BACKTRACE_COLS=2 and try again. The last thing I
can see is ipt_do_table, if you are using connlimit in LOCAL_IN
its most likely that, the version in patch-o-matic is not
compatible with current kernels.
