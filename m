From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: reduce netns create/delete cost
Date: Wed, 6 Dec 2017 09:19:35 +0100
Message-ID: <20171206081935.GA4076@salvia>
References: <20171130232104.541-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gscrivan@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33262 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750989AbdLFITj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Dec 2017 03:19:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4697C0B26
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:19:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D6560DA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2017 09:19:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171130232104.541-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 01, 2017 at 12:21:01AM +0100, Florian Westphal wrote:
> This patch series removes all synchronize_net() calls from netfilter core
> to speed up net namespace create/delete rate.
> 
> Freeing of hooks is moved to call_rcu at the cost of additional 24 bytes
> at the end of each rule blob.

Series applied, thanks Florian.
