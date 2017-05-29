From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: clusterip: switch to
 nf_register_net_hook
Date: Mon, 29 May 2017 11:34:09 +0200
Message-ID: <20170529093409.GA9964@salvia>
References: <20170517092531.3219-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58034 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750893AbdE2JeO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 05:34:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C1F81DA084
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:34:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7807F100A43
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:34:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8ABA5100A63
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 11:34:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170517092531.3219-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 17, 2017 at 11:25:31AM +0200, Florian Westphal wrote:
> one of the last remaining users of the old api, hopefully followup commit
> can remove it soon.

Applied to nf-next, thanks.
