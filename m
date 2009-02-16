From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 13:17:14 +0100
Message-ID: <4999594A.9030601@trash.net>
References: <20090216092317.6855.7403.stgit@Decadence> <49993263.5050702@netfilter.org> <alpine.LSU.2.00.0902161312230.12536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55262 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbZBPMRR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:17:17 -0500
In-Reply-To: <alpine.LSU.2.00.0902161312230.12536@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-02-16 10:31, Pablo Neira Ayuso wrote:
> 
>> Pablo Neira Ayuso wrote:
>>
>>> +static int xt_cluster_seq_show(struct seq_file *s, void *v)
>>> +{
>>> +	unsigned long *mask = v;
>>> +	seq_printf(s, "0x%8lx\n", *mask);
>>                         ^^^
>> Damn, this needs the dot before the 8 to fill with zero the empty
>> spaces. Jan's suggestion was wrong and I forgot to check this. I'll send
>> the patch again.
> 
> Wait wait, let me requote myself:
> 
>> '.' does not make sense with non-string,non-floating point numbers 
>> (though it is a stdc feature it seems). I'd say "0x%08lx", for clarity.
> 
> The second '0' in "0x%08lx" is missing.

Lets discuss the need for this interface first before fixing it :)
It looks like a way to get around using (potentially slow) rule
replacement, which doesn't make sense to add on a per-module base.
