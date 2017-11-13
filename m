From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/4] netfilter: reduce hook sizes in struct net
Date: Mon, 13 Nov 2017 17:53:14 +0100
Message-ID: <20171113165314.GA14267@salvia>
References: <20171113164107.11259-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753649AbdKMQxU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2017 11:53:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC10BDA4C0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 17:53:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F674DA7B9
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2017 17:53:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171113164107.11259-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 13, 2017 at 05:41:03PM +0100, Florian Westphal wrote:
> struct net contains:
> 
> struct nf_hook_entries __rcu *hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
> 
> which store the hook entry point locations for the various protocol
> families and the hooks.
> This can be compacted a lot by only storing the families and hooks
> that are actually implemented.
> 
> struct net before:
> /* size: 5184, cachelines: 81, members: 46 */
> after:
> /* size: 4544, cachelines: 71, members: 46 */
> 
> In case this is too late just ignore this thing, I will resubmit
> once next opens again.

It's already closed, no problem, I'll let this sit into nf-next with
other remaining patches I've been collecting today.
