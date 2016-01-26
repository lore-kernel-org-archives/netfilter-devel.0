From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] netlink: move binop postprocess to extra function
Date: Tue, 26 Jan 2016 14:38:20 +0100
Message-ID: <20160126133820.GA4168@salvia>
References: <1453658307-7177-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41289 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbcAZNiZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jan 2016 08:38:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6C806303D03
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5C9ECDA862
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 82996DA80C
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453658307-7177-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 24, 2016 at 06:58:25PM +0100, Florian Westphal wrote:
> Just move the payload trim part to a separate function.
> Next patch will add a second call site to deal with map ops
> that use a lookup based on a binop result.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
