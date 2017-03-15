From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 5/9] ct: add conntrack event mask support
Date: Wed, 15 Mar 2017 10:53:57 +0100
Message-ID: <20170315095357.GA2360@salvia>
References: <20170314195816.1721-1-fw@strlen.de>
 <20170314195816.1721-6-fw@strlen.de>
 <20170314200011.GA24366@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39536 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752985AbdCOJyI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 05:54:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C8EF249C4
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 10:54:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A7FDDA865
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 10:54:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8ECA9DA870
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 10:54:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170314200011.GA24366@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 09:00:11PM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> 
> [ nft .. ct eventmask set ...]
> 
> ahem.  I did not mean to submit this yet as the kernel
> patch assumes that the untracked object doesn't exist anymore (which
> is why I haven't submitted it yet).
> 
> I will not push this patch until the kernel patch is in nf-next.

Thanks Florian.
