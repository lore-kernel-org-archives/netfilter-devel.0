From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.29-rc bug near nf_conntrack_tuple_taken
Date: Tue, 24 Feb 2009 15:14:47 +0100
Message-ID: <49A400D7.1010404@trash.net>
References: <alpine.LSU.2.00.0902240044320.8597@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-rt-users@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33365 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZBXOOt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:14:49 -0500
In-Reply-To: <alpine.LSU.2.00.0902240044320.8597@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 2.6.29-rc4-rt2 spuriously locks up after 30 min to 2 h.
> First the network dies (no ping either to or from), later it
> takes the whole machine down as file I/O is blocked too.
> 
> I have also observed this on a no-RT patched 2.6.29-rc4, though
> need to get a clean gpl trace there first.
> 
> (Note that this -rt dump has not tainted.)
> 
> Feb 23 19:15:11 yaguchi kernel: BUG: unable to handle kernel paging request at 00100100
> Feb 23 19:15:11 yaguchi kernel: IP: [<f0f305c4>] nf_conntrack_tuple_taken+0xe4/0x112 [nf_conntrack]

> Feb 23 19:15:13 yaguchi kernel: Call Trace:
> Feb 23 19:15:13 yaguchi kernel:  [<f184367b>] ? nf_nat_used_tuple+0x1f/0x26 [nf_nat]
> Feb 23 19:15:13 yaguchi kernel:  [<f1843817>] ? get_unique_tuple+0x195/0x1b6 [nf_nat]
> Feb 23 19:15:13 yaguchi kernel:  [<f184391c>] ? nf_nat_setup_info+0xe4/0x2c6 [nf_nat]
> Feb 23 19:15:13 yaguchi kernel:  [<f0efb522>] ? ipt_do_table+0x453/0x489 [ip_tables]
> Feb 23 19:15:13 yaguchi kernel:  [<f185e115>] ? alloc_null_binding+0x89/0x91 [iptable_nat]
> Feb 23 19:15:13 yaguchi kernel:  [<f185e164>] ? nf_nat_rule_find+0x47/0x4f [iptable_nat]
> Feb 23 19:15:13 yaguchi kernel:  [<f185e34c>] ? nf_nat_fn+0x13c/0x1aa [iptable_nat]
> Feb 23 19:15:13 yaguchi kernel:  [<f185e54b>] ? nf_nat_in+0x1e/0x4f [iptable_nat]

This would mean something has used the non-rcu list functions
when removing a conntrack from the hash. Which I don't see
happening anywhere. Another possibility would be that the connntrack
was already confirmed when the tuple got mangled and the list
got corrupted. The pr_debug in nf_conntrack_alter_reply should
trigger in that case.
