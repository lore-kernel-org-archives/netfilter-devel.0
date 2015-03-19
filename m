From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH v2] rule: delete extra space in rule indentation
Date: Thu, 19 Mar 2015 12:16:09 +0000
Message-ID: <20150319121608.GI6892@acer.localdomain>
References: <20150318104252.25344.59683.stgit@nfdev.cica.es>
 <20150318171637.GA5346@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59776 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbbCSMQN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2015 08:16:13 -0400
Content-Disposition: inline
In-Reply-To: <20150318171637.GA5346@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18.03, Pablo Neira Ayuso wrote:
> On Wed, Mar 18, 2015 at 11:43:24AM +0100, Arturo Borrero Gonzalez wrote:
> > Annoying extra space in rule indentation:
> > 
> > Example before this patch:
> > 
> > table ip6 test_table {
> > 	chain test_chain {
> > 		 counter tcp dport { 22, 80, 443} accept # handle 1
> > 		^
> > 	}
> > }
> > 
> > Example after this patch:
> > 
> > table ip6 test_table {
> > 	chain test_chain {
> > 		counter tcp dport { 22, 80, 443} accept # handle 1
> > 	}
> > }
> 
> Applied, thanks.

We now have misaligned output, f.i.

         type filter hook output priority 0; policy accept;
        ip daddr @test counter packets 14 bytes 1176

Arturo, please check the remaining print functions and adjust them
accordingly.
