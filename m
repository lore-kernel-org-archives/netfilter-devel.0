From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: fix memory leak when
 attach expectation successfully
Date: Wed, 10 Aug 2016 10:36:24 +0200
Message-ID: <20160810083624.GA31312@salvia>
References: <1470665020-19882-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47764 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbcHJSFM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ECC96A4177
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:36:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DF555FF2D5
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:36:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C2EC5FAB5F
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:36:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470665020-19882-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 10:03:40PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> User can use NFQA_EXP to attach expectations to conntracks, but we
> forget to put back nf_conntrack_expect when it is inserted successfully,
> i.e. in this normal case, expect's use refcnt will be 3. So even we
> unlink it and put it back later, the use refcnt is still 1, then the
> memory will be leaked forever.

Applied, thanks.
