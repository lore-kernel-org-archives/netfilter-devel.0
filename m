From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] netfilter: x_tables: validate e->target_offset early
Date: Thu, 24 Mar 2016 21:17:54 +0100
Message-ID: <20160324201754.GA1937@salvia>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
 <1458666173-24318-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57544 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcCXUSD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Mar 2016 16:18:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2BA0080B13
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CDAE0A736
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0116CAD8B
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2016 21:18:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458666173-24318-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 06:02:49PM +0100, Florian Westphal wrote:
> We should check that e->target_offset is sane before
> mark_source_chains gets called since it will fetch the target entry
> for loop detection.

Applied, thanks Florian.
