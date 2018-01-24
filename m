From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: x_tables: avoid out-of-bounds reads in
 xt_request_find_match()
Date: Thu, 25 Jan 2018 00:49:16 +0100
Message-ID: <20180124234916.knidvxyyxznyzkko@salvia>
References: <1516834188.3715.35.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42058 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932072AbeAXXtV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jan 2018 18:49:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 216F71BFA85
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 00:49:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B761DA3A5
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 00:49:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1516834188.3715.35.camel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 24, 2018 at 02:49:48PM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> It looks like syzbot found its way into netfilter territory.
> 
> Issue here is that @name comes from user space and might
> not be null terminated.
> 
> Out-of-bound reads happen, KASAN is not happy.

Applied, thanks Eric.
