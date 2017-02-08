From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/9] netfilter: nft_ct: prepare for key-dependent
 error unwind
Date: Wed, 8 Feb 2017 10:29:06 +0100
Message-ID: <20170208092906.GB28205@salvia>
References: <20170203123556.17357-1-fw@strlen.de>
 <20170203123556.17357-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754020AbdBHJ3h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 04:29:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1C2D1373A8
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:29:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93715BAAA3
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:29:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88230BAAAF
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:29:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170203123556.17357-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 03, 2017 at 01:35:49PM +0100, Florian Westphal wrote:
> Next patch will add ZONE_ID set support which will need similar
> error unwind (put operation) as conntrack labels.
> 
> Prepare for this: remove the 'label_got' boolean in favor
> of a switch statement that can be extended in next patch.
> 
> As we already have that in the set_destroy function place that in
> a separate function and call it from the set init function.

Also applied, thanks.
