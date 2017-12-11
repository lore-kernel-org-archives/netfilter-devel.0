From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] netlink_linearize: exthdr op must be u32
Date: Mon, 11 Dec 2017 13:48:02 +0100
Message-ID: <20171211124802.GA2010@salvia>
References: <20171211091933.28916-1-fw@strlen.de>
 <20171211124729.GB1550@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751347AbdLKMsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Dec 2017 07:48:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3E9B469268
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2017 13:48:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30A38DA840
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Dec 2017 13:48:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171211124729.GB1550@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 11, 2017 at 01:47:29PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 11, 2017 at 10:19:33AM +0100, Florian Westphal wrote:
> > libnftnl casts this to u32. Broke exthdr expressions on bigendian.
> 
> Applied, thanks.

Push it out yourself as usual.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
