From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: conntrack: add missing role attributes
 for DCCP
Date: Fri, 24 Apr 2009 16:59:24 +0200
Message-ID: <49F1D3CC.6060307@trash.net>
References: <20090424102534.30250.37215.stgit@Decadence> <20090424103009.30250.99268.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46932 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323AbZDXO7b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:59:31 -0400
In-Reply-To: <20090424103009.30250.99268.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch adds missing role attribute to the DCCP type, otherwise
> the creation of entries is not of any use.
> 
> The attribute added is CTA_PROTOINFO_DCCP_ROLE which contains the
> role of the conntrack original tuple.

Applied, thanks Pablo.
