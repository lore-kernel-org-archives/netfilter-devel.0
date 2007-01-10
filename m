From: Patrick McHardy <kaber@trash.net>
Subject: Re: Iptable loop during kernel startup
Date: Wed, 10 Jan 2007 11:57:44 +0100
Message-ID: <45A4C6A8.10401@trash.net>
References: <BFECAF9E178F144FAEF2BF4CE739C668030B5903@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: 'Linux Kernel Mailing List' <linux-kernel@vger.kernel.org>,
	Edgar Iglesias <edgar.iglesias@axis.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964834AbXAJK5s@vger.kernel.org>
To: Mikael Starvik <mikael.starvik@axis.com>
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668030B5903@exmail1.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mikael Starvik wrote:
> I have a kernel with
> 
> CONFIG_IP_NF_TABLES=y
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_LOG=y
> 
> all other NF options are off.

Which iptables/kernel versions are you using?

> During kernel startup I get
> iptables: loop hook 1 pos 00000022
> 
> when filter tries to register at module_init.
> 
> Any ideas why I get this loop?

Please post your ruleset and the kernel config.
