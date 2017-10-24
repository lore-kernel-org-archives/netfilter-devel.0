From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/3] netfilter: remove pf argument from conntrack
 l4 packet function
Date: Tue, 24 Oct 2017 18:03:27 +0200
Message-ID: <20171024160327.GA12108@salvia>
References: <20171011084742.25989-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbdJXQDe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:03:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C4A2E9772
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:03:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76FA7DA873
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2017 18:03:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171011084742.25989-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 11, 2017 at 10:47:39AM +0200, Florian Westphal wrote:
> We currently pass pf to the packet() function of the l4 trackers,
> but this isn't needed -- its only required for the 'log invalid' check
> and the l4 protocol is also available in the nf_conn entry.

Series applied, thanks.
