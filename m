From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfqueue & bridge netfilter considered broken
Date: Fri, 2 Sep 2016 12:00:21 +0200
Message-ID: <20160902100021.GA5627@salvia>
References: <20160902090848.GA506@breakpoint.cc>
 <20160902095853.GA5577@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45342 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753033AbcIBKAa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 06:00:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB59C11E5A6
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 12:00:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDA7A11BDAD
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 12:00:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17E131153FB
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 12:00:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160902095853.GA5577@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 11:58:53AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 02, 2016 at 11:08:48AM +0200, Florian Westphal wrote:
> > I - discard extra nfct entry when cloning.  Works, but obviously not
> >  compatible in any way (the clones are INVALID).
> 
> This approach is simple and it would only break when packets are
> flooded to all ports, actually this is not working anyway because of
> clashes at confirm, right?

Hm, what about attaching the notrack conntrack for this case?
