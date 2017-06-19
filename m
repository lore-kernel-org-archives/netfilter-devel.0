From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: move table iteration out of netns
 exit paths
Date: Mon, 19 Jun 2017 19:10:00 +0200
Message-ID: <20170619171000.GA4975@salvia>
References: <20170530093106.10138-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55800 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750757AbdFSRKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:10:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 61E352E7842
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:09:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5215F6DAC4
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:09:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B1DA1021A8
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:09:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170530093106.10138-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 30, 2017 at 11:31:06AM +0200, Florian Westphal wrote:
> We only need to iterate & remove in case of module removal;
> for netns destruction all conntracks will be removed anyway.

Applied, thanks Florian.
