From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V2 1/2] netfilter: introduce nf_conntrack_helper_put
 helper function
Date: Mon, 15 May 2017 18:37:01 +0200
Message-ID: <20170515163701.GB3863@salvia>
References: <20170507140156.16487-1-zlpnobody@163.com>
 <20170507140156.16487-2-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54444 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759959AbdEOQhF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:37:05 -0400
Content-Disposition: inline
In-Reply-To: <20170507140156.16487-2-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 07, 2017 at 10:01:55PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> And convert module_put invocation to nf_conntrack_helper_put, this is
> prepared for the followup patch, which will add a refcnt for cthelper,
> so we can reject the deleting request when cthelper is in use.

Applied, thanks.
