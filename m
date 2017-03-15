From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl 0/2] add backend support to define ct helpers
Date: Wed, 15 Mar 2017 17:30:29 +0100
Message-ID: <20170315163029.GA29756@salvia>
References: <20170314195401.1334-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50790 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752033AbdCOQam (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 12:30:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 894D9FEFA0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:30:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B5FEDA725
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:30:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D7CEDA725
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:30:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170314195401.1334-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 08:53:59PM +0100, Florian Westphal wrote:
> This adds libnftnl support to define connection tracking helpers.
> Frontend (nft) support will follow soon.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
