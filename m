From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] libnftables: Make output_fp default to /dev/null
Date: Mon, 20 Nov 2017 13:47:16 +0100
Message-ID: <20171120124716.GA17684@salvia>
References: <20171116143224.GA17329@salvia>
 <20171116191415.19404-1-phil@nwl.cc>
 <20171120123204.GA17403@salvia>
 <20171120123313.GB17403@salvia>
 <20171120123851.GT32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdKTMrU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 07:47:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 87FA454D5F2
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:47:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 707C677DA4
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 13:47:19 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171120123851.GT32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 20, 2017 at 01:38:51PM +0100, Phil Sutter wrote:
> On Mon, Nov 20, 2017 at 01:33:13PM +0100, Pablo Neira Ayuso wrote:
> > On Mon, Nov 20, 2017 at 01:32:04PM +0100, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Thu, Nov 16, 2017 at 08:14:15PM +0100, Phil Sutter wrote:
> > > > Ensure output_fp is never NULL which allows to drop all respective
> > > > checks.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > > Hi Pablo,
> > > > 
> > > > This is how I understood your suggestion to use /dev/null. While
> > > > implementing it though, I had an idea for a much simpler solution,
> > > > namely just rejecting NULL in nft_set_output() and therefore forcing the
> > > > application to deal with opening /dev/null if no output is desired. What
> > > > do you think about that?
> > > 
> > > I like your idea of rejecting NULL.
> 
> OK, cool.
> 
> > BTW, why does nft_set_output() return FILE *? Is there any usecase for
> > this?
> 
> It's a quick way to change output_fp and store its old value. Current
> users are nft_run_cmd_from_*().

Oh, I see.

> I could introduce nft_get_output() to make the return value a dedicated
> success/fail indicator if you prefer that, otherwise I'd just make
> nft_set_output() return NULL in error case.

As you prefer. For my usecase, the existing call is just fine.
