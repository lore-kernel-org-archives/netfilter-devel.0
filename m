From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] src: consolidate XML/JSON exportation
Date: Mon, 10 Nov 2014 12:25:04 +0100
Message-ID: <20141110112504.GA20864@salvia>
References: <1415614927-5465-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: arturo.borrero.glez@gmail.com, alvaroneay@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39735 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaKJLXW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:23:22 -0500
Content-Disposition: inline
In-Reply-To: <1415614927-5465-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 10, 2014 at 11:22:07AM +0100, Pablo Neira Ayuso wrote:
> Add new buffer class to consolidate the existing code to export objects
> in XML/JSON and use it. We save ~700 LOC with this change.
> 
> The rule and set objects are not yet consolidated. It seems this would
> require some specific glue code per representation type since lists are
> arranged differently.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Arturo, @Alvaro: It seems to me that the XML and JSON are currently not
> round-trippable due to (at least) this difference:
> 
> <expr type="meta">...</expr>
> "expr":[{"type":"meta",...
> 
> Two choices:
> 
> * XML uses <expr><type>meta</type>...</expr>.
> * JSON uses "expr":[{"-type":"meta",...
> 
> in any case, I think we'll have to break the representation for one of
> them to fix this.

I accidentally sent an old version of this patch. This change has
spotted and fixed many inconsistencies in the output of expressions.
I'll resend the newer patch again.
