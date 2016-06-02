From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH] extensions: libip6t_hbh: Add translation to nft
Date: Thu, 2 Jun 2016 17:31:32 +0200
Message-ID: <20160602153131.GB11408@sonyv>
References: <20160601220804.GA3515@sonyv>
 <20160602110847.GA3428@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36316 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbcFBPbg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 11:31:36 -0400
Received: by mail-wm0-f45.google.com with SMTP id n184so85736187wmn.1
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jun 2016 08:31:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160602110847.GA3428@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 01:08:47PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 02, 2016 at 12:08:08AM +0200, Laura Garcia Liebana wrote:
> > Add translation for Hop-By-Hop header to nftables. Hbh options are not
> > supported yet in nft.
> 
> It would be good to document this in the wiki, as Shivani did already.
> It would be also good if you can document what is missing to be
> capable of matching these hbh options there.
>

It seems that is already documented in the official wiki.

 ip6

     hbh 

     [Waiting for support of options] (partial translations available) 

