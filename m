From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables rules not matching after upgrading from 0.7 to 0.8
Date: Tue, 7 Nov 2017 01:58:37 +0100
Message-ID: <20171107005837.GA22918@salvia>
References: <1508949114.1154.14.camel@cohaesio.com>
 <20171025175725.GJ19457@breakpoint.cc>
 <1508955630.25035.13.camel@cohaesio.com>
 <1508970133.25035.24.camel@cohaesio.com>
 <20171025224536.GK19457@breakpoint.cc>
 <1509000429.25035.28.camel@cohaesio.com>
 <1509986942.1169.3.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "fw@strlen.de" <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932628AbdKGA6r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 19:58:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D73F1F4B6C
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:58:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5E38EDA81E
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:58:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1509986942.1169.3.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 06, 2017 at 04:49:04PM +0000, Anders K. Pedersen | Cohaesio wrote:
[...]
> Since this patch was applied, I've not had any further problems with
> nftables 0.8. Does it make sense that nftables 0.7 worked fine without
> the patch, or was this just random luck?

Yes. nftables 0.7 doesn't not provide indications to the kernel on the
number of elements in the set descriptions, hence it selects the
slowier hashtable representation, which was not buggy :-)
