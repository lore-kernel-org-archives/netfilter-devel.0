From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 13:13:29 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902161312230.12536@fbirervta.pbzchgretzou.qr>
References: <20090216092317.6855.7403.stgit@Decadence> <49993263.5050702@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57634 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbZBPMNa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:13:30 -0500
In-Reply-To: <49993263.5050702@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-16 10:31, Pablo Neira Ayuso wrote:

>Pablo Neira Ayuso wrote:
>
>> +static int xt_cluster_seq_show(struct seq_file *s, void *v)
>> +{
>> +	unsigned long *mask = v;
>> +	seq_printf(s, "0x%8lx\n", *mask);
>                         ^^^
>Damn, this needs the dot before the 8 to fill with zero the empty
>spaces. Jan's suggestion was wrong and I forgot to check this. I'll send
>the patch again.

Wait wait, let me requote myself:

>'.' does not make sense with non-string,non-floating point numbers 
>(though it is a stdc feature it seems). I'd say "0x%08lx", for clarity.

The second '0' in "0x%08lx" is missing.
