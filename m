From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/9] netfilter: nft_ct: add zone id get support
Date: Wed, 8 Feb 2017 10:28:34 +0100
Message-ID: <20170208092834.GA28205@salvia>
References: <20170203123556.17357-1-fw@strlen.de>
 <20170203123556.17357-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58584 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753957AbdBHJ3h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 04:29:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E2261373A5
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:28:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81CDCBAAB7
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:28:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CCE3BAAAE
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:28:50 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170203123556.17357-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 03, 2017 at 01:35:48PM +0100, Florian Westphal wrote:
> Just like with counters the direction attribute is optional.
> We set priv->dir to MAX unconditionally to avoid duplicating the assignment
> for all keys with optional direction.
> 
> For keys where direction is mandatory, existing code already returns
> an error.

Applied, thanks Florian.
