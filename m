From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] libxt_cgroup2: add support for cgroup2 path matching
Date: Fri, 25 Dec 2015 13:19:14 +0100
Message-ID: <20151225121914.GA7306@salvia>
References: <20151222185626.GC5003@mtj.duckdns.org>
 <20151222185707.GD5003@mtj.duckdns.org>
 <20151225121822.GB7273@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbbLYMp5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:45:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D92777B556
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:45:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C9384DA85C
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:45:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 03D31DA85C
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:45:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151225121822.GB7273@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 01:18:22PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Dec 22, 2015 at 01:57:07PM -0500, Tejun Heo wrote:
> > This patch updates xt_cgroup so that it supports revision 1 interface
> > which includes cgroup2 path based matching.
> 
> Also applied, thanks.

BTW, we have a regression test infrastructure for iptables. Have a
look at our .t files under extensions.

Would you add tests for the cgroup match for us?

Thanks!
