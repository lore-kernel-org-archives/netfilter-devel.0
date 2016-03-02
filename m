From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 00/10] nft: exthdr fixes and improvements
Date: Wed, 2 Mar 2016 13:00:14 +0100
Message-ID: <20160302120014.GA4737@salvia>
References: <1456846670-28179-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57023 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbcCBMAT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 07:00:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2CB3D6DFCC
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:00:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 15948DA395
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:00:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 846F1DA39E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 13:00:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456846670-28179-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, Mar 01, 2016 at 04:37:40PM +0100, Florian Westphal wrote:
> This adds following enhancements and fixes for the exthdr
> expression.
> 
> #1.  Treat exthdr as if user asked for an ip6 protocol header field,
> i.e. add ipv6 dependency for bridge/netdev/inet family.
> 
> #2.  Add scaling and masking to handle protocol headers that have
> non-byte divisible sizes.
> 
> Tested briefly with following dummy rules (nf_defrag_ipv6 module not loaded):
> 
> frag frag-off 0 counter packets 40 bytes 59840
> frag frag-off 131 counter packets 0 bytes 0
> frag frag-off 1448 counter packets 0 bytes 0
> frag frag-off 181 counter packets 40 bytes 59840
> frag frag-off > 0 counter packets 120 bytes 148160
> 
> Note that the offsets are *NOT* scaled, i.e. we match the raw values
> contained in the packet.  To match offset of 1448 one thus needs to
> ask for 181.
> 
> This is same behaviour as ip hdrlength, where 5 matches a value of 20 bytes.

This looks good to me.

I still think we should move part of this to the evaluation phase so
we catch other corner cases, but we can revisit that later on. Willing
to have a look at this at some point.

Thanks.
