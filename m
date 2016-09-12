From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_hash: Add hash offset value
Date: Mon, 12 Sep 2016 18:57:43 +0200
Message-ID: <20160912165741.GA18041@sonyv>
References: <20160906064416.GA32396@sonyv>
 <20160912163459.GA11062@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:34095 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbcILQ5r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 12:57:47 -0400
Received: by mail-wm0-f41.google.com with SMTP id a6so6202279wmc.1
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 09:57:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160912163459.GA11062@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2016 at 06:34:59PM +0200, Pablo Neira Ayuso wrote:
> Hi Laura,
> 
> On Tue, Sep 06, 2016 at 08:44:19AM +0200, Laura Garcia Liebana wrote:
> > Add support to pass through an offset to the hash value. With this
> > feature, the sysadmin is able to generate a hash with a given
> > offset value.
> 
> We've been using 'offset' to refer to this for a while, to I'm
> renaming this to NFTA_HASH_OFFSET.
> 

Ok, I'll send a new patch to change this for libnftnl.

Thank you!

