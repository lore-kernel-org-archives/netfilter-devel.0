From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: decnet: only register hooks in init
 namespace
Date: Mon, 24 Apr 2017 10:37:33 +0200
Message-ID: <20170424083733.GA3395@salvia>
References: <20170419224207.3219-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51454 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1166764AbdDXIhn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 04:37:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C71DF523C8
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:37:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8222FF2C5
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:37:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A454FF124
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 10:37:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170419224207.3219-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 12:42:07AM +0200, Florian Westphal wrote:
> looks like decnet isn't namespacified in first place, so restrict hook
> registration to the initial namespace.
> 
> Prepares for eventual removal of legacy nf_register_hook() api.

Applied, thanks.
