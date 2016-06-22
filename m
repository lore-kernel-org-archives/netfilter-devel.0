From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v4] netfilter: nf_tables: add support for
 inverted logic in nft_lookup
Date: Wed, 22 Jun 2016 20:22:30 +0200
Message-ID: <20160622182230.GD8772@salvia>
References: <146479452764.7621.9693339197925845407.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49180 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbcFVSWj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 14:22:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 447D0E8E84
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:22:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 34F989EBA9
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:22:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3023F266755
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 20:22:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <146479452764.7621.9693339197925845407.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 05:23:02PM +0200, Arturo Borrero Gonzalez wrote:
> Introduce a new configuration option for this expression, which allows users
> to invert the logic of set lookups.

Any plan to add the missing nftables bits? Let me know, I would like
to have all the pieces in places so we can also add automated tests
for this.

Thanks!
