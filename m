From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] tests: add two map test cases
Date: Tue, 26 Jan 2016 14:38:27 +0100
Message-ID: <20160126133827.GB4168@salvia>
References: <1453658307-7177-1-git-send-email-fw@strlen.de>
 <1453658307-7177-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41327 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbcAZNii (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jan 2016 08:38:38 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D3521303D03
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C4211DA795
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 32775DA809
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453658307-7177-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 24, 2016 at 06:58:26PM +0100, Florian Westphal wrote:
> One normal map lookup, one with an explicit binop.
> The latter is supposed to also work with the followup patch applied.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
