From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4] evaluate: Fix datalen checks in
 expr_evaluate_string()
Date: Wed, 17 Aug 2016 16:41:25 +0200
Message-ID: <20160817144125.GA10362@salvia>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
 <1471017610-3473-2-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57514 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcHQOla (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 10:41:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 36416D1636
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:41:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2514E96600
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:41:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 102E4A827A
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 16:41:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471017610-3473-2-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 06:00:07PM +0200, Phil Sutter wrote:
> This part of the code is pretty weird due to suboptimal variable name
> choice: 'data', 'len', 'datalen', 'data_len'.
> 
> But even without understanding all of it, the code checking 'datalen - 1
> >= 0' assumes 'datalen - 1' may actually become negative, which is not
> true since it is unsigned. So make 'datalen' a signed integer instead.
> 
> Another issue is the check for "data[datalen] != '*'" which will access
> unallocated memory if 'strlen(data) == 0'. So make sure 'datalen >= 0'
> before using it as array index.

We don't allow empty strings from our flex scanner as string, so we
assume the string is at least 1.

You can probably add an assert() here instead.
