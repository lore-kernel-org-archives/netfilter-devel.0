From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/4] proto_find_num: Avoid potential null pointer
 dereference
Date: Wed, 17 Aug 2016 16:47:27 +0200
Message-ID: <20160817144727.GC10362@salvia>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
 <1471017610-3473-4-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58680 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcHQOrc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 10:47:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EA6CED1636
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:47:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DAFEFA827A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:47:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B209CDA7E5
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:47:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471017610-3473-4-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 06:00:09PM +0200, Phil Sutter wrote:
> When being called from stmt_evaluate_reset(), it seems that 'base' might
> actually be NULL, so better make sure it is not in proto_find_num().

I would suggest you address this from stmt_evaluate_reset().
