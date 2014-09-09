From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH 5/6 v5] netfilter: nf_tables: extend
 NFT_MSG_DELTABLE to support flushing the ruleset
Date: Tue, 9 Sep 2014 17:03:32 +0200
Message-ID: <20140909150332.GA10222@salvia>
References: <1409668946-8168-1-git-send-email-arturo.borrero.glez@gmail.com>
 <1409668946-8168-6-git-send-email-arturo.borrero.glez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35125 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbaIIPCq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:02:46 -0400
Content-Disposition: inline
In-Reply-To: <1409668946-8168-6-git-send-email-arturo.borrero.glez@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 02, 2014 at 04:42:26PM +0200, Arturo Borrero Gonzalez wrote:
> This patch extend the NFT_MSG_DELTABLE call to support flushing the entire
> ruleset.
> 
> The options now are:
>  * No family speficied, no table specified: flush all the ruleset.
>  * Family specified, no table specified: flush all tables in the AF.
>  * Family specified, table specified: flush the given table.

Also applied, thanks Arturo.

