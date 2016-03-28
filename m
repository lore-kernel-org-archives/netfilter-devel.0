From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: ipv4: fix NULL dereference
Date: Mon, 28 Mar 2016 12:05:31 +0200
Message-ID: <20160328100531.GA3496@salvia>
References: <1458981177-117357-1-git-send-email-zlpwmdx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	davem@davemloft.net, kernel@kyup.com,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpwmdx@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37267 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbcC1KFk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 06:05:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A07D2842D
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 12:05:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5593FDA39D
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 12:05:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E8F50DA8F7
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 12:05:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458981177-117357-1-git-send-email-zlpwmdx@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 26, 2016 at 04:32:57PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Commit fa50d974d104 ("ipv4: Namespaceify ip_default_ttl sysctl knob")
> use sock_net(skb->sk) to get the net namespace, but we can't assume
> that sk_buff->sk is always exist, so when it is NULL, oops will happen.

Applied, thanks for following up on this.
