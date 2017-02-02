From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v4 0/7] netfilter: skbuff: merge nfctinfo bits
 and nfct pointer
Date: Thu, 2 Feb 2017 14:24:45 +0100
Message-ID: <20170202132445.GA4142@salvia>
References: <1485192119-6144-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34056 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbdBBNY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Feb 2017 08:24:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27BCF131CC1
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:24:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7DB0DA845
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:24:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78539DA845
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Feb 2017 14:24:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1485192119-6144-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 23, 2017 at 06:21:52PM +0100, Florian Westphal wrote:
> Whenever we fetch skb conntrack info, we need to access two
> distinct cache lines in sk_buff, #2 (nfct pointer) and #3
> (nfctinfo bits).  This series removes nfctinfo and joins it
> with the data pointer in a single ulong.
> 
> We have 3 nfctinfo bits, the slab cache used for nf_conn objects
> guarantees at least 8 byte alignment so there is no overlap.
> 
> For the conntrack templates most arches also guarantee an
> 8 byte minalign, but not all.
> 
> Patch #6 adds manual alignment of the templates if
> ARCH_KMALLOC_MINALIGN isn't sufficient.
> 
> A followup series to this one will resurrect an old patch from
> Pablo that adds an 'untracked' ctinfo status, this then allows
> to get rid of the conntrack template object (which in turn avoids
> get/put atomic ops for untracked skbs).

Series applied, thanks Florian.
