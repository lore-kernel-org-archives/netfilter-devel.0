From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: conntrack: move event cache to conntrack
 extension infrastructure
Date: Thu, 04 Jun 2009 14:16:14 +0200
Message-ID: <4A27BB0E.3070908@netfilter.org>
References: <20090604110307.6702.10147.stgit@Decadence> <20090604110818.6702.51833.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43067 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbZFDMQV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:16:21 -0400
In-Reply-To: <20090604110818.6702.51833.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
>  #ifdef CONFIG_NF_CONNTRACK_EVENTS
>  struct nf_conntrack_ecache {
> -	struct nf_conn *ct;
> -	unsigned int events;
> +	unsigned long cache;	/* bitops want long */
> +};

Sorry, I noticed that this should out of the #ifdef, otherwise it breaks
compilation of configurations with no events enabled. I'm going to
review this.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
