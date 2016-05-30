From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: set again FLOWI_FLAG_KNOWN_NH at
 flowi6_flags
Date: Mon, 30 May 2016 11:33:15 +0200
Message-ID: <20160530093315.GA27963@salvia>
References: <57f1193ae2ca44c7a901cab0b0f53d603afdca04.1464262477.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37268 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbcE3JdT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:33:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 337991C0964
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:33:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1FFF815D635
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:33:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2402915D636
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:33:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <57f1193ae2ca44c7a901cab0b0f53d603afdca04.1464262477.git.pabeni@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 26, 2016 at 07:08:10PM +0200, Paolo Abeni wrote:
> With the commit 48e8aa6e3137 ("ipv6: Set FLOWI_FLAG_KNOWN_NH at
> flowi6_flags") ip6_pol_route() callers were asked to to set the
> FLOWI_FLAG_KNOWN_NH properly and xt_TEE was updated accordingly,
> but with the later refactor in commit bbde9fc1824a ("netfilter:
> factor out packet duplication for IPv4/IPv6") the flowi6_flags
> update was lost.
> This commit re-add it just before the routing decision.

Applied, thanks.
