From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] chain: Don't print unset policy value in
 netlink debug
Date: Fri, 8 Sep 2017 14:58:27 +0200
Message-ID: <20170908125827.GA28157@salvia>
References: <20170907174127.1909-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35039 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755217AbdIHM6v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2017 08:58:51 -0400
Content-Disposition: inline
In-Reply-To: <20170907174127.1909-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 07, 2017 at 07:41:27PM +0200, Phil Sutter wrote:
> The policy field was printed unconditionally, but if it wasn't set the
> default value 0 was printed as 'policy drop' which is not correct.

Applied, thanks Phil.
