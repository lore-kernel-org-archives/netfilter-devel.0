From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 10:31:15 +0100
Message-ID: <49993263.5050702@netfilter.org>
References: <20090216092317.6855.7403.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58650 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752845AbZBPJbY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:31:24 -0500
In-Reply-To: <20090216092317.6855.7403.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:

> +static int xt_cluster_seq_show(struct seq_file *s, void *v)
> +{
> +	unsigned long *mask = v;
> +	seq_printf(s, "0x%8lx\n", *mask);
                         ^^^
Damn, this needs the dot before the 8 to fill with zero the empty
spaces. Jan's suggestion was wrong and I forgot to check this. I'll send
the patch again.

pablo@debian:~$ sudo cat /proc/net/netfilter/cluster/eth2
0x       1

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
