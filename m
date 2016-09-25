From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3 0/7] Compact netfilter hooks list
Date: Sun, 25 Sep 2016 13:30:01 +0200
Message-ID: <20160925113001.GA8291@salvia>
References: <1474472107-12992-1-git-send-email-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965960AbcIYLaM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 07:30:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8CC0ED087
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC4B3DA853
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6B94DA816
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:30:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474472107-12992-1-git-send-email-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 21, 2016 at 11:35:00AM -0400, Aaron Conole wrote:
> This series makes a simple change to shrink the netfilter hook list
> from a double linked list, to a singly linked list.  Since the hooks
> are always traversed in-order, there is no need to maintain a previous
> pointer.
> 
> This was jointly developed by Florian Westphal.

Series applied, thanks.
