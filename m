From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_cgroup: add unit test
Date: Sun, 3 Jan 2016 21:00:49 +0100
Message-ID: <20160103200049.GA13876@salvia>
References: <20151222185626.GC5003@mtj.duckdns.org>
 <20151222185707.GD5003@mtj.duckdns.org>
 <20151225121822.GB7273@salvia>
 <20151225121914.GA7306@salvia>
 <20151228214120.GC30165@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42304 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbcACUA5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2016 15:00:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 123D61022A1
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:00:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 051DBDA7E0
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:00:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 40409DA801
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:00:51 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151228214120.GC30165@mtj.duckdns.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 28, 2015 at 04:41:20PM -0500, Tejun Heo wrote:
> Add basic tests which depend only on the root cgroup.

Applied, thanks.
