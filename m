From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: fix timestamp attribute
Date: Thu, 12 May 2016 17:07:32 +0200
Message-ID: <20160512150732.GA16949@salvia>
References: <1463057034-27694-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40506 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbcELPHn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2016 11:07:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0AA8913C0E0
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 17:07:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EF0352687FC
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 17:07:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 83F5D2687CB
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 17:07:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463057034-27694-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 12, 2016 at 02:43:54PM +0200, Florian Westphal wrote:
> Since 4.4 we erronously use timestamp of the netlink skb (which is zero).
> 
> Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1066
> Fixes: b28b1e826f818c30ea7 ("netfilter: nfnetlink_queue: use y2038 safe timestamp")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Argh, my fault. Thanks for fixing up this, applied.
