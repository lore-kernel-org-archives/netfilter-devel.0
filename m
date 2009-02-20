From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Fri, 20 Feb 2009 21:56:19 +0100
Message-ID: <499F18F3.50209@netfilter.org>
References: <20090220205041.4795.77635.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59599 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754984AbZBTU40 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 15:56:26 -0500
In-Reply-To: <20090220205041.4795.77635.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> +	return ((1 << hash) & info->node_mask) ^
> +	       !!(info->flags & XT_CLUSTER_F_INV);

Am, wait this is completely broken... this happen when one rushes...

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
