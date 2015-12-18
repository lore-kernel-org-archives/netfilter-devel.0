From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf-next 09/12] nfnetlink: add
 nfnl_dereference_protected helper
Date: Fri, 18 Dec 2015 11:39:54 +0100
Message-ID: <20151218103954.GA2091@salvia>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
 <1449136185-4165-10-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46530 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbLRKkA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 05:40:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C15DD13178B
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 11:39:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A221ADA843
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 11:39:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EBC50DA80D
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 11:39:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449136185-4165-10-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 03, 2015 at 10:49:42AM +0100, Florian Westphal wrote:
> to avoid overly long line in followup patch.

I like this cleanup, applied, thanks Florian.
