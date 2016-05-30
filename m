From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: remove leftover binary sysctl define
Date: Mon, 30 May 2016 11:30:12 +0200
Message-ID: <20160530093012.GA27880@salvia>
References: <1463172531-15429-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36498 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbcE3JaS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:30:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 096391C0968
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:30:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ED85911FE80
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E2BCF15D634
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:30:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463172531-15429-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 13, 2016 at 10:48:51PM +0200, Florian Westphal wrote:
> Users got removed in f8572d8f2a2ba ("sysctl net: Remove unused binary
> sysctl code").

This is very small, related to changes from the previous release cycle
and non-intrusive. So I'm placing this in the nf tree.

Applied, thanks.
