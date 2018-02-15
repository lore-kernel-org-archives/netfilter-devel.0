From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 0/6] rework dependency removal (v2)
Date: Thu, 15 Feb 2018 16:31:19 +0100
Message-ID: <20180215153119.3zfnfku64naig2gk@salvia>
References: <20180214152229.11830-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164403AbeBOPbY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Feb 2018 10:31:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D694820A523
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 16:31:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3DB9DA3AD
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 16:31:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCEF9DA3AD
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 16:31:20 +0100 (CET)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9C8104265A2F
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Feb 2018 16:31:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180214152229.11830-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 14, 2018 at 04:22:23PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset aims to address what Florian reported time ago [1]. This
> is skipping removal of protocol key payload expressions at network base
> for the netdev, bridge and inet.
> 
> It would better to annotate all redundant expressions and add a later
> stage, where we can do smarter simplifications by looking globally at
> what we have, instead of just looking at current protocol key expression
> and last one that we have annotated in the context structure to perform
> removals. But I would prefer to have a fix now upstream then look at
> this larger rework later on since it would require to review a bit of
> the postprocess code.
> 
> The initial 4 patches in this batch are just cleanup/preparation patches
> for patches 5/6 and 6/6.
> 
> There is still a few warning in the tests/py/ infrastructure, some of
> them I think need to be fixed, and at least one can remain there to
> remind us that we can do better.

I'm going to push out this so we start giving it some testing.
