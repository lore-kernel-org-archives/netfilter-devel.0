From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue] src: make nfq_open_nfnl thread-safe
Date: Mon, 20 Jun 2016 14:42:59 +0200
Message-ID: <20160620124259.GA15177@salvia>
References: <1466421592-9164-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59156 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbcFTMnW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 08:43:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C6B9D2B50E7
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 14:43:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B74D59EBBA
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 14:43:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6DAD79EBCC
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 14:43:00 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466421592-9164-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 20, 2016 at 01:19:52PM +0200, Florian Westphal wrote:
> nfq_open_nfnl uses an intermediate static object, so when
> it is invoked by distinct threads at the same time there is a small
> chance that some threads end up with another threads nfq_handle pointer
> stored in ->data.
> 
> Tested-by: Michal Tesar <mtesar@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
