From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] evaluate: reject set references in set elements
Date: Tue, 1 Mar 2016 20:08:25 +0100
Message-ID: <20160301190825.GA2068@salvia>
References: <1456764639-28299-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752405AbcCATIb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2016 14:08:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 61EDD12A681
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:08:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4B409DA380
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:08:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6C5E0DA3A8
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Mar 2016 20:08:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456764639-28299-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 29, 2016 at 05:50:39PM +0100, Florian Westphal wrote:
> given
> 
> table filter {
>   set local {
>     type iface_index
>     elements = { lo }
>   }
>   chain input {
>     type filter hook input priority 0;
>     iif { @lan, } accept;
>   }
> }
> 
> nft BUG()s.  I don't see how we could support sets-in-set; add a sanity
> check and error out instead.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

