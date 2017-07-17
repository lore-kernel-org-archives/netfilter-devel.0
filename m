From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nftables: onlly allow in/output for arp
 packets
Date: Mon, 17 Jul 2017 17:08:04 +0200
Message-ID: <20170717150804.GC9791@salvia>
References: <20170707112903.9545-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbdGQPIQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:08:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BAE7A249C8
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:08:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC3C01B3D59
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:08:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C2D21B3358
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:08:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170707112903.9545-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 07, 2017 at 01:29:03PM +0200, Florian Westphal wrote:
> arp packets cannot be forwarded.
> 
> They can be bridged, but then they can be filtered using
> either ebtables or nftables bridge family.
> 
> The bridge netfilter exposes a "call-arptables" switch which
> pushes packets into arptables, but lets not expose this for nftables, so better
> close this asap.

Applied, thanks.
