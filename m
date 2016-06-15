From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: fix a wrong check to skip
 the inactive rules
Date: Wed, 15 Jun 2016 11:42:30 +0200
Message-ID: <20160615094230.GA12469@salvia>
References: <1465906384-55985-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Patrick McHardy <kaber@trash.net>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55176 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbcFOJmw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 05:42:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 83EDA10079C
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:42:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 70CCF9EBA7
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:42:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B55F6C21A2
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 11:42:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465906384-55985-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 14, 2016 at 08:13:04PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> nft_genmask_cur has already done left-shift operator on the gencursor,
> so there's no need to do left-shift operator on it again.
> 
> Fixes: ea4bd995b0f2 ("netfilter: nf_tables: add transaction helper functions")

Applied, thanks.
