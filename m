From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 1/6 v5] netfilter: nf_tables: refactor rule
 deletion helper
Date: Wed, 3 Sep 2014 11:46:08 +0200
Message-ID: <20140903094608.GA14063@salvia>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34245 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbaICJpZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:45:25 -0400
Content-Disposition: inline
In-Reply-To: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:42:21PM +0200, Arturo Borrero Gonzalez wrote:
> This helper function always schedule the rule to be removed in the following
> transaction.
> In follow-up patches, it is interesting to handle separately the logic of rule
> activation/disactivation from the transaction mechanism.
> 
> So, this patch simply splits the original nf_tables_delrule_one() in two
> functions, allowing further control.
> 
> While at it, for the sake of homigeneize the function naming scheme, let's
> rename nf_tables_delrule_one() to nft_delrule().

Applied, thanks.

