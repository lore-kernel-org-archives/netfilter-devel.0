From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] meta: add short-hand mnemonic for probalistic
 matching
Date: Thu, 14 Jul 2016 12:41:08 +0200
Message-ID: <20160714104108.GA2250@salvia>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
 <1467704135-9154-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45933 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbcGNKlO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jul 2016 06:41:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4B339172F7C
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 12:41:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3BCFFFAB54
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 12:41:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 52E7E9EBB9
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Jul 2016 12:41:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467704135-9154-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 09:35:34AM +0200, Florian Westphal wrote:
> Allow users to use a simpler way to specify probalistic matching, e. g.:
> 
> meta probability 0.5		(match approx. every 2nd packet)
> meta probability 0.001		(match approx. once every 1000 packets)
> 
> nft list will still show
> meta random <= 2147483647
> meta random <= 4294967

I don't like this asymmetry.

What is the usecase for 'meta random' out of this probability case that
maps to what xt_statistics offers?
