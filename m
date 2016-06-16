From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3 libnftnl] chain: Fix bug. Check correct attribute
Date: Thu, 16 Jun 2016 14:51:17 +0200
Message-ID: <20160616125117.GA2832@salvia>
References: <20160616102012.32036-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58103 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbcFPMvZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2016 08:51:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0DA5C9BF2DD
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2016 14:51:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EFC4D9EBA1
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2016 14:51:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9BAC99EBA1
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2016 14:51:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160616102012.32036-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied, thanks for catching up this.

Please, include descriptions in your future patches.

Moreover, I'd suggest you use a title with a single sentence.

I have rewritten your patch title and description.

http://git.netfilter.org/libnftnl/commit/?id=2fee091b0dd1741a8a87cafceaa0091adadd2b46
