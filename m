From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] meta: fix pkttype name and add 'other' symbol
Date: Thu, 27 Oct 2016 19:23:03 +0200
Message-ID: <20161027172303.GA20405@salvia>
References: <1477585994-15432-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56786 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752154AbcJ0RYT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 13:24:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5ADA425D34
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:23:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A269DA91A
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:23:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F377DA91B
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 19:23:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477585994-15432-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 27, 2016 at 06:33:14PM +0200, Florian Westphal wrote:
> 'unicast' doesn't check for unicast packets; it checks for PACKET_HOST,
> i.e. a packet coming in for this host.
> 
> A unicast address to some other machine (e.g. because nic is
> in promisc mode) will have PACKET_OTHER.
> 
> So at best this is misleading, so this patch changes it
> to 'host'.  The unicast entry is retained for compat purpose.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
