From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] nftables: byteorder: avoid uneeded le/be
 conversion steps
Date: Wed, 13 Jan 2016 14:01:41 +0100
Message-ID: <20160113130141.GA19369@salvia>
References: <1452548972-24454-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36929 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbcAMNBu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 08:01:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E5F0EE3A2E
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 14:01:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D425ADA87A
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 14:01:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BEABFDA807
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 14:01:46 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452548972-24454-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 11, 2016 at 10:49:32PM +0100, Florian Westphal wrote:
> David points out that we to three le/be conversions instead
> of just one.  Doesn't matter on x86_64 w. gcc, but other
> architectures might be less lucky.
> 
> Since it also simplifies code just follow his advice.

Applied, thanks Florian.
