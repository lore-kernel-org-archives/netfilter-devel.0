From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: fix nf_log_trace based
 tracing
Date: Thu, 10 Dec 2015 18:22:29 +0100
Message-ID: <20151210172229.GA4237@salvia>
References: <1449675081-29519-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37682 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbbLJRWf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2015 12:22:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 117FDB6BB1
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 18:22:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DD4FADA7FF
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 18:22:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C76E5DA243
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 18:22:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449675081-29519-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 09, 2015 at 04:31:21PM +0100, Florian Westphal wrote:
> nf_log_trace() outputs bogus 'TRACE:' strings because I forgot to update
> the comments array.
> 
> Fixes: 33d5a7b14bfd0 ("netfilter: nf_tables: extend tracing infrastructure")

Applied to nf-next, thanks Florian.
