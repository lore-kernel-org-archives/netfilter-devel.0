From: Marek Kierdelewicz <marek@piasta.pl>
Subject: Re: new netfilter target - DNETMAP
Date: Sun, 9 Jan 2011 10:26:34 +0100
Message-ID: <20110109102634.16b0a3c1@kuguar>
References: <20110107000259.775ba310@kuguar>
	<alpine.LNX.2.01.1101070008590.19521@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from psyche.piasta.pl ([83.175.144.5]:58806 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1AIJ0f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Jan 2011 04:26:35 -0500
In-Reply-To: <alpine.LNX.2.01.1101070008590.19521@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

>It would be nice if you could
> * resolve the inconsistencies in indentation. Specifically, use tabs
>   to indent statements. If in doubt, use scripts/Lindent 
>and scripts/checkpatch.pl from linux.

Done. Patch passes checkpatch.pl except for:
- nf_conntrack_tuple.h and nf_nat.h in include/net/netfilter/;
  these two files are copied frome kernel tree;
- lack of signed-off which AFAIK is used for kernel patches only;

I hope it's ok.

> * wrap lines at 80 cols in xt_DNETMAP.man 

Done.

Updated versions are located here:
http://cat.piasta.pl/dnetmap/xtables-addons-1.31-dnetmap-1.0.tar.bz2
http://cat.piasta.pl/dnetmap/xtables-addons-1.31-dnetmap-1.0.patch.bz2

>Things I have noticed while spending a quick look:
>The manpage mentions "If host 192.168.0.10 generates some traffic, it 
>gets bound to first free IP in subnet - 20.0.0.0.". However,
>20.0.0.0 can be a network address and thus lead to problems.
>Is there a way for the user to specify that the range to use
>should be 20.0.0.1-20.255.255.254 rather than 20.0.0.0-20.255.255.255?

To address your concerns I've added new module parameter:

whole_prefix: use network and broadcast addresses of specified prefix
for bindings (default: 1) (uint)

Implementing this as target parameter would be messy because data
structures for a given prefix are created on addition of the first
rule for a given prefix.

best regards,
Marek Kierdelewicz
