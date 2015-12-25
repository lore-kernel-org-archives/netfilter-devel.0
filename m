From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] libxt_cgroup2: add support for cgroup2 path matching
Date: Fri, 25 Dec 2015 13:18:22 +0100
Message-ID: <20151225121822.GB7273@salvia>
References: <20151222185626.GC5003@mtj.duckdns.org>
 <20151222185707.GD5003@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48263 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbbLYMpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:45:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6B10A7B544
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:45:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5DB51DA865
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:45:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A83B3DA807
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:45:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222185707.GD5003@mtj.duckdns.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 01:57:07PM -0500, Tejun Heo wrote:
> This patch updates xt_cgroup so that it supports revision 1 interface
> which includes cgroup2 path based matching.

Also applied, thanks.
