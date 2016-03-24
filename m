From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] netfilter: x_tables: make sure e->next_offset covers
 remaining blob size
Date: Thu, 24 Mar 2016 21:18:08 +0100
Message-ID: <20160324201808.GB1937@salvia>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
 <1458666173-24318-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57558 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcCXUSN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 16:18:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DAA6C80B0F
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 88560A89A
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AE4C911E3F5
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458666173-24318-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 06:02:50PM +0100, Florian Westphal wrote:
> Otherwise this function may read data beyond the ruleset blob.

Also applied, thanks.
