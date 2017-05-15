From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: can't assume lock is acquired
 when dumping set elems
Date: Mon, 15 May 2017 18:58:29 +0200
Message-ID: <20170515165829.GA4277@salvia>
References: <20170514133522.20980-1-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:54712 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752280AbdEOQ6f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 12:58:35 -0400
Content-Disposition: inline
In-Reply-To: <20170514133522.20980-1-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 14, 2017 at 09:35:22PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When dumping the elements related to a specified set, we may invoke the
> nf_tables_dump_set with the NFNL_SUBSYS_NFTABLES lock not acquired. So
> we should use the proper rcu operation to avoid race condition, just
> like other nft dump operations.

Applied, thanks.
