From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] libxt_cgroup: prepare for multi revisions
Date: Fri, 25 Dec 2015 13:18:12 +0100
Message-ID: <20151225121812.GA7273@salvia>
References: <20151222185626.GC5003@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48223 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbbLYMo5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:44:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 957DC7B556
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:44:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7A744DA809
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:44:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0BD5FDA246
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:44:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222185626.GC5003@mtj.duckdns.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 01:56:26PM -0500, Tejun Heo wrote:
> libxt_cgroup will grow cgroup2 path based match.  Postfix existing
> symbols with _v0 and prepare for multi revision registration.  While
> at it, rename O_CGROUP to O_CLASSID and fwid to classid.

Applied, thanks Tejun.
