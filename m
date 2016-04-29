From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: IDLETIMER: fix race condition when destroy
 the target
Date: Fri, 29 Apr 2016 12:10:35 +0200
Message-ID: <20160429101035.GA15788@salvia>
References: <1461224828-3274-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44537 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbcD2KKl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Apr 2016 06:10:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DFE6E1AC751
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 12:10:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CC8D9100A5D
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 12:10:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B1EBA100A5D
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2016 12:10:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461224828-3274-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 21, 2016 at 12:47:08AM -0700, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Workqueue maybe still in running while we destroy the IDLETIMER target,
> thus cause a use after free error, add cancel_work_sync() to avoid such
> situation.

Applied, thanks.
