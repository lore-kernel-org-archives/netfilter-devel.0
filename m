From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nf_tables: remove unused struct members
Date: Wed, 25 Nov 2015 13:51:42 +0100
Message-ID: <20151125125142.GA21799@salvia>
References: <1448319808-9532-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36770 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbbKYMvr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 07:51:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 03EB81324CC
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:51:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E9B82DA807
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:51:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04A86DA801
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2015 13:51:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448319808-9532-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 24, 2015 at 12:03:28AM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> thoff and nhoff are not used anywhere,
> payload expression uses skb_network_header() and xt.thoff as base offset.

Applied, thanks Florian.
