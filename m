From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: helper set support
Date: Wed, 8 Mar 2017 17:22:38 +0100
Message-ID: <20170308162238.GA3713@salvia>
References: <20170308154844.18065-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751657AbdCHQpY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:45:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 853D21862B7
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:22:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76FE0DA809
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:22:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46714DA814
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:22:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170308154844.18065-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 04:48:42PM +0100, Florian Westphal wrote:
> This adds support to set the conntrack helper from nftables, using
> nft set ct helper "foo" syntax.
> 
> Helpers are defined through the objref infrastructure.
> 
> Open question: should NFT_MSG_GETOBJ_RESET get rejected for this new type?

Yes. This is a stateless object, but that can be done in a follow up
patch, no problem.

Thanks Florian.
