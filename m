From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nft: Remove memory-leak
Date: Tue, 15 Mar 2016 01:26:26 +0100
Message-ID: <20160315002626.GA9628@salvia>
References: <20160314084153.GA4064@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57839 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbcCOA0b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2016 20:26:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 60626114F47
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:26:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 502CFDA385
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:26:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EA669DA8F8
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 01:26:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160314084153.GA4064@fate>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 14, 2016 at 02:11:53PM +0530, Piyush Pangtey wrote:
> Added matching xfree calls in chain_free(), for the chain members 'type' and
> 'dev'.

Please, reintroduce the valgrind message for the record.

It would be good too if you add to the descriptions the nft command you
use to trigger the valgrind leak reports.

Thanks.
