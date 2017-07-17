From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nat: fix src map lookup
Date: Mon, 17 Jul 2017 17:07:51 +0200
Message-ID: <20170717150751.GB9791@salvia>
References: <20170707110717.4746-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, jaco@uls.co.za
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdGQPIA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:08:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 640FA249D0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:07:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57BC11B3D52
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:07:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F5F01B3D52
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:07:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170707110717.4746-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 07, 2017 at 01:07:17PM +0200, Florian Westphal wrote:
> When doing initial conversion to rhashtable I replaced the bucket
> walk with a single rhashtable_lookup_fast().
> 
> When moving to rhlist I failed to properly walk the list of identical
> tuples, but that is what is needed for this to work correctly.
> The table contains the original tuples, so the reply tuples are all
> distinct.
> 
> We currently decide that mapping is (not) in range only based on the
> first entry, but in case its not we need to try the reply tuple of the
> next entry until we either find an in-range mapping or we checked
> all the entries.
> 
> This bug makes nat core attempt collision resolution while it might be
> able to use the mapping as-is.

Also applied, thanks.
