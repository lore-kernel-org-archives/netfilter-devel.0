From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix memory leak if expr init
 fails
Date: Thu, 23 Jun 2016 13:03:04 +0200
Message-ID: <20160623110304.GA2312@salvia>
References: <1466428305-58285-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55069 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbcFWLDX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:03:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AA98210078E
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:03:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 99129FAB59
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:03:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E470A9EBB2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:03:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466428305-58285-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 20, 2016 at 09:11:45PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> If expr init fails then we need to free it.
> 
> So when the user add a nft rule as follows:
>   # nft add rule filter input tcp dport 22 flow table ssh \
>     { ip saddr limit rate 0/second }
> memory leak will happen.

Applied to nf, thanks!
