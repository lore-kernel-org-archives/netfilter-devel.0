From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] netlink: do binop postprocessing also for map
 lookups
Date: Tue, 26 Jan 2016 14:38:39 +0100
Message-ID: <20160126133839.GC4168@salvia>
References: <1453658307-7177-1-git-send-email-fw@strlen.de>
 <1453658307-7177-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41353 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965129AbcAZNin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jan 2016 08:38:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 979E7303D00
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 888CDDA808
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A839BDA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Jan 2016 14:38:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1453658307-7177-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 24, 2016 at 06:58:27PM +0100, Florian Westphal wrote:
> nft list before patch:
> mark set unknown unknown & 0xfff [invalid type] map { 3 : 0x00000017, 1 : 0x0000002a}
> now:
> mark set vlan id map { 3 : 0x00000017, 1 : 0x0000002a}

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
