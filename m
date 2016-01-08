From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] nftables: byteorder: provide 64bit le/be conversion
Date: Fri, 8 Jan 2016 13:37:08 +0100
Message-ID: <20160108123708.GA4816@salvia>
References: <1452245352-2899-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34808 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbcAHMhQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 07:37:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 22DE3B5A62C
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:37:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 140E8DA803
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:37:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F086DA80C
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 13:37:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452245352-2899-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 08, 2016 at 10:29:12AM +0100, Florian Westphal wrote:
> Needed to convert the (64bit) conntrack counters to BE ordering.

Applied, thanks Florian.
