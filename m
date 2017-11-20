From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] libnftables: Make output_fp default to /dev/null
Date: Mon, 20 Nov 2017 13:33:13 +0100
Message-ID: <20171120123313.GB17403@salvia>
References: <20171116143224.GA17329@salvia>
 <20171116191415.19404-1-phil@nwl.cc>
 <20171120123204.GA17403@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdKTMdR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 07:33:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6033A54D5F7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:33:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50D1B78436
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:33:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171120123204.GA17403@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 20, 2017 at 01:32:04PM +0100, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Thu, Nov 16, 2017 at 08:14:15PM +0100, Phil Sutter wrote:
> > Ensure output_fp is never NULL which allows to drop all respective
> > checks.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Hi Pablo,
> > 
> > This is how I understood your suggestion to use /dev/null. While
> > implementing it though, I had an idea for a much simpler solution,
> > namely just rejecting NULL in nft_set_output() and therefore forcing the
> > application to deal with opening /dev/null if no output is desired. What
> > do you think about that?
> 
> I like your idea of rejecting NULL.

BTW, why does nft_set_output() return FILE *? Is there any usecase for
this?

Thanks!
