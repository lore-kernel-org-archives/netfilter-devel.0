From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 nf-next 0/4] netfilter: nftables: add connlabel set
 support
Date: Fri, 15 Apr 2016 13:00:20 +0200
Message-ID: <20160415110020.GA12188@salvia>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36720 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbcDOLA1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 07:00:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3A7F513C0E3
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 13:00:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 22ED39D0E0
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 13:00:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 88FA39D0F9
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 13:00:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460477666-17823-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 12, 2016 at 06:14:22PM +0200, Florian Westphal wrote:
> Hi.
> 
> This is round 5 of the connlabel set support set.
> I'm only sending the kernel patches for now.
> 
> First 4 patches are preparation changes, patch #4 adds set support.

Florian, I can push into the tree the 3 preparation patches, I don't
see many changes on them. You can follow up with the nft_ct changes
later on.
