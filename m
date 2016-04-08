From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] nfct: documentation updates and corrections.
Date: Fri, 8 Apr 2016 12:36:43 +0200
Message-ID: <20160408103643.GE2142@salvia>
References: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41564 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757915AbcDHKgx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 06:36:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F17D11E11CC
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:36:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E29B2DA391
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:36:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D6BEFDA38B
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:36:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460096324-17426-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 08, 2016 at 08:18:40AM +0200, Mart Frauenlob wrote:
> 
> Good day,
> 
> this series includes some documentation updates and corrections for nfct.

Series applied.

> For the first patch: add missing commands to usage output,
> 
> I was not able to trigger the usage output. I think the parser is broken.

Yes, this is broken.

It would be good to add getopt_long to disable the help and version
via -h and -v. Similar what we have in nft.
