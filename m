From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3 1/4] mnl: Consolidate mnl_batch_talk() parameters
Date: Wed, 2 Aug 2017 14:36:30 +0200
Message-ID: <20170802123630.GA16003@salvia>
References: <20170728115548.5171-1-phil@nwl.cc>
 <20170728115548.5171-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:51544 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751112AbdHBMgz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 08:36:55 -0400
Content-Disposition: inline
In-Reply-To: <20170728115548.5171-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 28, 2017 at 01:55:45PM +0200, Phil Sutter wrote:
> The single caller of this function passes struct netlink_ctx fields as
> the first two parameters. This can be simplified by passing the context
> object itself and having mnl_batch_talk() access it's fields instead.

Applied, thanks.
