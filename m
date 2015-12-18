From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_ct: include direction when dumping
 NFT_CT_L3PROTOCOL key
Date: Fri, 18 Dec 2015 14:46:50 +0100
Message-ID: <20151218134650.GA7396@salvia>
References: <1450445527-13225-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47921 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbbLRNq5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 08:46:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C13BA131785
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 14:46:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9858CDA804
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 14:46:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AC48CDA814
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 14:46:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1450445527-13225-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 18, 2015 at 02:32:07PM +0100, Florian Westphal wrote:
> one nft userspace test case fails with
> 
> 'ct l3proto original ipv4' mismatches 'ct l3proto ipv4'
> 
> ... because NFTA_CT_DIRECTION attr is missing.

Applied, thanks Florian.
