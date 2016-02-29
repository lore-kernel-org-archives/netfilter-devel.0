From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_acct: validate NFACCT_FILTER
 parameters
Date: Mon, 29 Feb 2016 13:35:25 +0100
Message-ID: <20160229123525.GA12142@salvia>
References: <1456346083-15562-1-git-send-email-phil.turnbull@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	coreteam@netfilter.org
To: Phil Turnbull <phil.turnbull@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55450 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbcB2Mfb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 07:35:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1DE564B9E5
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:35:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0D037DA38A
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:35:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 10150DA8F8
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:35:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456346083-15562-1-git-send-email-phil.turnbull@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 24, 2016 at 03:34:43PM -0500, Phil Turnbull wrote:
> nfacct_filter_alloc doesn't validate the NFACCT_FILTER_MASK and
> NFACCT_FILTER_VALUE parameters which can trigger a NULL pointer
> dereference. CAP_NET_ADMIN is required to trigger the bug.

Applied, thanks.

I have enqueued this to -stable: 3.18, 4.1 and 4.4
