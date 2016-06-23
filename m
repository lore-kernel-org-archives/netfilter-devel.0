From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: conntrack: align nf_conn on cacheline
 boundary
Date: Thu, 23 Jun 2016 19:38:04 +0200
Message-ID: <20160623173804.GA3515@salvia>
References: <1465590322-2174-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56406 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbcFWRiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:38:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 470EF8D051B
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 353219EBA0
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 11F269EBA0
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:05 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465590322-2174-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 10, 2016 at 10:25:22PM +0200, Florian Westphal wrote:
> increases struct size by 32 bytes (288 -> 320), but it is the right thing,
> else any attempt to (re-)arrange nf_conn members by cacheline won't work.

Applied, thanks Florian.
