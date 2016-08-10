From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: reject new conntrack request
 with different l4proto
Date: Wed, 10 Aug 2016 10:36:57 +0200
Message-ID: <20160810083657.GC31312@salvia>
References: <1470665426-20973-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47910 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbcHJSFU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 31D72A416B
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:37:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 17C41FF2D4
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:37:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0B385FAB5F
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:37:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470665426-20973-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 10:10:26PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Currently, user can add a conntrack with different l4proto via nfnetlink.
> For example, original tuple is TCP while reply tuple is SCTP. This is
> invalid combination, we should report EINVAL to userspace.

Also applied, thanks.
