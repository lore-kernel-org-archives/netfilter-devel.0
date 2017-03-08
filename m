From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: bridge: remove unneeded rcu_read_lock
Date: Wed, 8 Mar 2017 19:02:50 +0100
Message-ID: <20170308180250.GA30928@salvia>
References: <20170307114504.2507-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35216 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753857AbdCHStw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 13:49:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 40E5324711
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 19:02:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3380DDA80C
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 19:02:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 142ECDA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 19:02:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170307114504.2507-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 07, 2017 at 12:45:04PM +0100, Florian Westphal wrote:
> as comment says, the function is always called with rcu read lock held.

Applied, thanks Florian.
