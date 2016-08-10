From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reject verdict request
 from different portid
Date: Wed, 10 Aug 2016 10:36:41 +0200
Message-ID: <20160810083641.GB31312@salvia>
References: <1470665247-20570-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47766 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbcHJSFP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D9013A4173
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:36:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C9E8EFF6FB
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:36:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1E1E3FAB5D
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 10:36:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470665247-20570-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 10:07:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Like NFQNL_MSG_VERDICT_BATCH do, we should also reject the verdict
> request when the portid is not same with the initial portid(maybe
> from another process).

Applied, thanks.
