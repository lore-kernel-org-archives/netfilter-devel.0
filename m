From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf-next] netfilter: nft_ct: allow to set ctnetlink
 event types of a connection
Date: Wed, 19 Apr 2017 17:56:37 +0200
Message-ID: <20170419155637.GB8531@salvia>
References: <20170415172610.5807-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937815AbdDSP4v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 11:56:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A9452E786C
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B780FC5E8
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F37CFC5EB
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170415172610.5807-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 07:26:10PM +0200, Florian Westphal wrote:
> By default the kernel emits all ctnetlink events for a connection.
> This allows to select the types of events to generate.
> 
> This can be used to e.g. only send DESTROY events but no NEW/UPDATE ones
> and will work even if sysctl net.netfilter.nf_conntrack_events is set to 0.
> 
> This was already possible via iptables' CT target, but the nft version has
> the advantage that it can also be used with already-established conntracks.
> 
> The added nf_ct_is_template() check isn't a bug fix as we only support
> mark and labels (and unlike ecache the conntrack core doesn't copy those).

applied, thanks.
