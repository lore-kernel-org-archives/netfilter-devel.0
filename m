From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf_conntrack.acct has no effect
Date: Mon, 16 Mar 2009 19:01:40 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903161901270.21226@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39361 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761998AbZCPSBo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:01:44 -0400
In-Reply-To: <49BE84D4.7050804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-03-16 17:56, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> A forum made me (re)aware of
>>
>> Mar 15 18:20:25 wild-thing kernel: nf_conntrack version 0.5.0 (16384 buckets,
>> 65536 max)
>> Mar 15 18:20:25 wild-thing kernel: CONFIG_NF_CT_ACCT is deprecated and will be
>> removed soon. Plase use
>> Mar 15 18:20:25 wild-thing kernel: nf_conntrack.acct=1 kernel paramater,
>> acct=1 nf_conntrack module option or
>> Mar 15 18:20:25 wild-thing kernel: sysctl net.netfilter.nf_conntrack_acct=1 to
>> enable it.
>>
>> which prompted me to look into this a bit in detail. I was wondering
>> which functionality I would lose on not setting nf_conntrack.acct. To
>> my surprise, there is no loss of functionality, as the "nf_ct_acct"
>> in nf_conntrack_acct.c nor /proc/sys/net/netfilter/nf_conntrack_acct
>> which is the accompanied sysctl file cause the packet or byte
>> counters to disappear from `conntrack -L` or /proc/net/nf_conntrack.
>>
>> Should the message be removed? Should the missing check for
>> nf_ct_acct be included?
>
> Currently the default is set based on the old config option.
> When unset, no acct-extend is allocated for *new* conntracks.
> The old ones that do have an acct-extend are still displayed.
> Does that explain your observation?

Absolutely, thanks for the clarification.
