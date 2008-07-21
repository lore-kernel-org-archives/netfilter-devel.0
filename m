From: Patrick McHardy <kaber@trash.net>
Subject: Re: Conntrack Events Performance - Multipart Messages?
Date: Mon, 21 Jul 2008 17:59:44 +0200
Message-ID: <4884B270.5010104@trash.net>
References: <487E24FC.60700@gmx.ch> <487F18DA.7030208@netfilter.org> <487FFBEE.90409@trash.net> <4884B068.4050306@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41174 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYGUP7s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:59:48 -0400
In-Reply-To: <4884B068.4050306@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> It took me some time to set up profiling on the router. I am using 
> oprofile. nf_conntrack and nfnetlink are built into the kernel. Most of 
> the time is probably spent in nfnetlink.
> 
> If you need other data than the one provided here, just let me know. I'm 
> not very familiar with oprofile, so providing the needed arguments would 
> be helpful.

Thanks.

> opreport --symbols (first 20, full file attached):
> CPU: ARM/XScale PMU2, speed 0 MHz (estimated)
> Counted CPU_CYCLES events (clock cycles counter) with a unit mask of 
> 0x00 (No unit mask) count 100000
> samples  %        app name                 symbol name
> 20018     9.6520  vmlinux                  memcpy

Callgraph information would be useful since its unclear whether
this is the memcpy triggered by netlink message trimming in
af_netlink.c or something different. Unfortunately according
to the documentation this is only supported on x86. I think
selecting the netfilter options as modules should provide
slightly more detail though.

> 19493     9.3988  ath_pci.ko               ath_sysctl_register

This looks odd. I couldn't find this function in the current
kernel tree, which version are you using?

> 6676      3.2189  vmlinux                  __nf_conntrack_find
> 6098      2.9402  vmlinux                  ipt_do_table
> 5858      2.8245  wlan.ko                  ieee80211_input
> 5383      2.5955  nf_conntrack_netlink.ko  .text
> 4567      2.2020  vmlinux                  __memzero
> 4225      2.0371  vmlinux                  __kmalloc
> 4091      1.9725  vmlinux                  csum_partial

You can disable conntrack checksumming by executing:

echo 0 >/proc/sys/net/netfilter/nf_conntrack_checksum

> 3469      1.6726  vmlinux                  nf_nat_setup_info
> 3468      1.6721  vmlinux                  netlink_broadcast
> 3376      1.6278  vmlinux                  __hash_conntrack
> 3304      1.5931  vmlinux                  nla_put
> 2992      1.4426  vmlinux                  __nla_reserve
> 2933      1.4142  vmlinux                  __nf_conntrack_confirm
> 2926      1.4108  oprofiled                /jffs/usr/bin/oprofiled
> 2847      1.3727  ath_pci.ko               ath_intr
> 2698      1.3009  vmlinux                  kfree
> 2655      1.2801  vmlinux                  __nla_put
> 2563      1.2358  vmlinux                  nf_conntrack_in
> 

