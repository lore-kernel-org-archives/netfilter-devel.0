From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3 2/4] netlink: Pass nlmsg flags from rule.c
Date: Wed, 2 Aug 2017 14:36:40 +0200
Message-ID: <20170802123640.GB16003@salvia>
References: <20170728115548.5171-1-phil@nwl.cc>
 <20170728115548.5171-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:51553 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdHBMhE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2017 08:37:04 -0400
Content-Disposition: inline
In-Reply-To: <20170728115548.5171-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 28, 2017 at 01:55:46PM +0200, Phil Sutter wrote:
> There is no point in checking value of excl in each called function.
> Just do it in a single spot and pass resulting flags.

Also applied, thanks.
