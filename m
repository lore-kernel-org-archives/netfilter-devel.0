From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: fix wrong check of
 NFT_SET_MAP in nf_tables_bind_set
Date: Wed, 15 Jun 2016 11:38:32 +0200
Message-ID: <20160615093832.GA2533@salvia>
References: <1465618828-22162-1-git-send-email-zlpnobody@163.com>
 <1465618828-22162-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53709 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbcFOJin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 05:38:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2065710078D
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:38:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DE489EBA7
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:38:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 210639EBAD
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:38:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465618828-22162-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 11, 2016 at 12:20:26PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We should check "i" is used as a dictionary or not, "binding" is already
> checked before.

I've applied this to nf, I qualify this as a fix, thanks.
