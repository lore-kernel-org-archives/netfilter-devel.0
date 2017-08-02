From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v3 2/4] netlink: Pass nlmsg flags from rule.c
Date: Wed, 2 Aug 2017 15:38:41 +0200
Message-ID: <20170802133841.GG16375@orbyte.nwl.cc>
References: <20170728115548.5171-1-phil@nwl.cc>
 <20170728115548.5171-3-phil@nwl.cc>
 <20170802123640.GB16003@salvia>
 <20170802125857.GA8908@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:52313 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751895AbdHBNim (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 09:38:42 -0400
Content-Disposition: inline
In-Reply-To: <20170802125857.GA8908@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 02, 2017 at 02:58:57PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 02, 2017 at 02:36:40PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 28, 2017 at 01:55:46PM +0200, Phil Sutter wrote:
> > > There is no point in checking value of excl in each called function.
> > > Just do it in a single spot and pass resulting flags.
> > 
> > Also applied, thanks.
> 
> Oops. I have to keep this back, sorry.
> 
> It breaks testcases/rule_management/0003insert_0.

Oh, it breaks insert command for rules.

> Please run tests before submitting, thanks!

Will do, sorry!

Thanks, Phil
