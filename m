From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfqueue & bridge netfilter considered broken
Date: Fri, 2 Sep 2016 11:58:53 +0200
Message-ID: <20160902095853.GA5577@salvia>
References: <20160902090848.GA506@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44582 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751858AbcIBJ7R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 05:59:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87D9E1022BB
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 11:59:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65BE0FF2D5
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 11:59:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A63F6114D69
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Sep 2016 11:58:54 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160902090848.GA506@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 11:08:48AM +0200, Florian Westphal wrote:
> I - discard extra nfct entry when cloning.  Works, but obviously not
>  compatible in any way (the clones are INVALID).

This approach is simple and it would only break when packets are
flooded to all ports, actually this is not working anyway because of
clashes at confirm, right?
