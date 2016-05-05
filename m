From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_acct: validate NFACCT_QUOTA
 parameter
Date: Thu, 5 May 2016 15:43:42 +0200
Message-ID: <20160505134342.GA15827@salvia>
References: <1462307959-3553-1-git-send-email-phil.turnbull@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	coreteam@netfilter.org
To: Phil Turnbull <phil.turnbull@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56837 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbcEENns (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 May 2016 09:43:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9B38B4B0F7
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 15:43:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8C58DA90C
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 15:43:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 84499ADE9
	for <netfilter-devel@vger.kernel.org>; Thu,  5 May 2016 15:43:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1462307959-3553-1-git-send-email-phil.turnbull@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 03, 2016 at 04:39:19PM -0400, Phil Turnbull wrote:
> If a quota bit is set in NFACCT_FLAGS but the NFACCT_QUOTA parameter is
> missing then a NULL pointer dereference is triggered. CAP_NET_ADMIN is
> required to trigger the bug.

Applied, thanks.
