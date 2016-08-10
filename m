From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: Add size check on u8 nft_exthdr
 attributes
Date: Wed, 10 Aug 2016 12:57:45 +0200
Message-ID: <20160810105745.GA4466@salvia>
References: <20160809184614.GA8947@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47916 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbcHJSFV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:05:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0A7DA186AC4
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:57:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F12EFFC61A
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:57:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0EB4FFF153
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:57:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160809184614.GA8947@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 09, 2016 at 08:46:16PM +0200, Laura Garcia Liebana wrote:
> Fix the direct assignment of offset and length attributes included in
> nft_exthdr structure from u32 data to u8.

Applied to my nf tree, I just made a minor edition on this patch.

Thanks.
