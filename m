From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ipvs: fix incorrect conflict
 resolution
Date: Wed, 19 Apr 2017 17:56:56 +0200
Message-ID: <20170419155656.GC8531@salvia>
References: <20170418154956.22233-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937865AbdDSP5C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 11:57:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FFF02E7873
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51BB8FC5EC
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A39EFC5F3
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170418154956.22233-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 18, 2017 at 05:49:56PM +0200, Florian Westphal wrote:
> The commit ab8bc7ed864b9c4f1fcb00a22bbe4e0f66ce8003
> ("netfilter: remove nf_ct_is_untracked")
> changed the line
>    if (ct && !nf_ct_is_untracked(ct) && nfct_nat(ct)) {
> 	   to
>    if (ct && nfct_nat(ct)) {
> 
> meanwhile, the commit 41390895e50bc4f28abe384c6b35ac27464a20ec
> ("netfilter: ipvs: don't check for presence of nat extension")
> from ipvs-next had changed the same line to
> 
>   if (ct && !nf_ct_is_untracked(ct) && (ct->status & IPS_NAT_MASK)) {
> 
> When ipvs-next got merged into nf-next, the merge resolution took
> the first version, dropping the conversion of nfct_nat().
> 
> While this doesn't cause a problem at the moment, it will once we stop
> adding the nat extension by default.

Also applied, thanks.
