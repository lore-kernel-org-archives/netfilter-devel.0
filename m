From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] libxt_cgroup2: add support for cgroup2 path matching
Date: Mon, 28 Dec 2015 11:20:21 -0500
Message-ID: <20151228162021.GU5003@mtj.duckdns.org>
References: <20151222185626.GC5003@mtj.duckdns.org>
 <20151222185707.GD5003@mtj.duckdns.org>
 <20151225121822.GB7273@salvia>
 <20151225121914.GA7306@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:34127 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbbL1QUW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 11:20:22 -0500
Received: by mail-yk0-f181.google.com with SMTP id a85so30259084ykb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 08:20:22 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151225121914.GA7306@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 01:19:14PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 25, 2015 at 01:18:22PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Dec 22, 2015 at 01:57:07PM -0500, Tejun Heo wrote:
> > > This patch updates xt_cgroup so that it supports revision 1 interface
> > > which includes cgroup2 path based matching.
> > 
> > Also applied, thanks.
> 
> BTW, we have a regression test infrastructure for iptables. Have a
> look at our .t files under extensions.
> 
> Would you add tests for the cgroup match for us?

Sure, will look into it.

Thanks.

-- 
tejun
