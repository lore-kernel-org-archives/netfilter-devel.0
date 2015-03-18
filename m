From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] rule: delete extra space in rule indentation
Date: Wed, 18 Mar 2015 18:16:37 +0100
Message-ID: <20150318171637.GA5346@salvia>
References: <20150318104252.25344.59683.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54092 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756383AbbCRRMt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 13:12:49 -0400
Content-Disposition: inline
In-Reply-To: <20150318104252.25344.59683.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 18, 2015 at 11:43:24AM +0100, Arturo Borrero Gonzalez wrote:
> Annoying extra space in rule indentation:
> 
> Example before this patch:
> 
> table ip6 test_table {
> 	chain test_chain {
> 		 counter tcp dport { 22, 80, 443} accept # handle 1
> 		^
> 	}
> }
> 
> Example after this patch:
> 
> table ip6 test_table {
> 	chain test_chain {
> 		counter tcp dport { 22, 80, 443} accept # handle 1
> 	}
> }

Applied, thanks.
