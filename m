From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 5/7] common: Avoid integer overflow in
 nftnl_batch_is_supported()
Date: Fri, 12 Aug 2016 01:48:29 +0200
Message-ID: <20160811234829.GA5659@salvia>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
 <1470958419-32602-6-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52524 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbcHKXsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:48:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1004D1878C1
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:48:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 003F5FF153
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:48:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA3D9DA7FA
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 01:48:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470958419-32602-6-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 01:33:37AM +0200, Phil Sutter wrote:
> time() may return -1 which is then assigned to an unsigned integer type
> and used as sequence number. The following code increments that number
> multiple times, so it may overflow and get libmnl confused. To avoid
> this, fall back to a starting sequence number of zero in case the call
> to time() failed.

(uint32_t)-1 should be fine for netlink as sequence number.
