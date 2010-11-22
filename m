From: Patrick McHardy <kaber@trash.net>
Subject: Re: xtables-addons - problem including nf_nat.h in userspace plugin
Date: Mon, 22 Nov 2010 16:11:37 +0100
Message-ID: <4CEA8829.1080106@trash.net>
References: <20101121224731.22fced2b@catus> <alpine.LNX.2.01.1011221447001.18089@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Marek Kierdelewicz <marek@piasta.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55494 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab0KVPLj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Nov 2010 10:11:39 -0500
In-Reply-To: <alpine.LNX.2.01.1011221447001.18089@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22.11.2010 14:52, Jan Engelhardt wrote:
> 
> On Sunday 2010-11-21 22:47, Marek Kierdelewicz wrote:
>>
>> I'm writing a new netfilter module and I'm using xtables-addons[...]
>> Iptables userspace plugin for the module needs definition of "struct
>> nf_nat_multi_range", so I added following line to libxt_xxxx.c:
>> #include <net/netfilter/nf_nat.h>
>> Unfortunately I get following message during make: 
>> warning: net/netfilter/nf_nat.h: No such file or directory
>> ... and compilation fails.
>> I was able to make it work by copying nf_nat.h and nf_conntrack_tuple.h
>> to extension directory in xtables-addons tree and by modifying include
>> in libxt_xxxx.c to "nf_nat.h", but this doesn't seem to be the proper
>> way of doing things.
> 
> Well, iptables also copies them rather than properly relying on
> something from <linux/*>. Yes, it's not proper. Patrick should know
> the details about the what and why.

Mainly to allow to compile new extensions before the kernel headers
are updated. Including files from include/net is wrong though, they
should be moved to include/linux instead.
