From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_dynset: fix element timeout for HZ !=
 1000
Date: Mon, 17 Oct 2016 17:29:58 +0200
Message-ID: <20161017152958.GA9045@salvia>
References: <1476020942.992.20.camel@cohaesio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "kaber@trash.net" <kaber@trash.net>
To: "Anders K. Pedersen | Cohaesio" <akp@cohaesio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753104AbcJQPaH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 11:30:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA3CF9B7E3
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:30:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D90EDDA81F
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:30:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B154BDA847
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2016 17:30:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476020942.992.20.camel@cohaesio.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 09, 2016 at 01:49:02PM +0000, Anders K. Pedersen | Cohaesio wrote:
> From: Anders K. Pedersen <akp@cohaesio.com>
> 
> With HZ=100 element timeout in dynamic sets (i.e. flow tables) is 10 times
> higher than configured.
> 
> Add proper conversion to/from jiffies, when interacting with userspace.
> 
> I tested this on Linux 4.8.1, and it applies cleanly to current nf and
> nf-next trees.

Applied, thanks Anders.
