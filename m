From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nftables 0/7] ct helper set support
Date: Wed, 15 Mar 2017 17:22:54 +0100
Message-ID: <20170315162254.GA29556@salvia>
References: <20170315150111.18477-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdCOQXA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 12:23:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66D55FB455
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:22:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58E3EDA793
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:22:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F19E9DA865
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 17:22:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170315150111.18477-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 15, 2017 at 04:01:04PM +0100, Florian Westphal wrote:
> v2, with updated syntax to force type and protocol keywords
> into same statement, i.e.
> 
> ct helper ftp-standard {
>   type "ftp" protocol tcp
> }
> 
> I also cleaned up the changes to bison (reuse family_spec_explicit)
> and added a test for an invalid helper (l3proto ip6 in ip table).

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
