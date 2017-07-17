From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: remove old pre-netns era hook api
Date: Mon, 17 Jul 2017 17:07:42 +0200
Message-ID: <20170717150742.GA9791@salvia>
References: <20170706211744.17683-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55558 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdGQPHr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:07:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C3735249C2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:07:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B67E31B3D59
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:07:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B10591B3D5A
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:07:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170706211744.17683-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 06, 2017 at 11:17:44PM +0200, Florian Westphal wrote:
> no more users in the tree, remove this.
> 
> The old api is racy wrt. module removal, all users have been converted
> to the netns-aware api.
> 
> The old api pretended we still have global hooks but that has not been
> true for a long time.

Applied, thanks.
