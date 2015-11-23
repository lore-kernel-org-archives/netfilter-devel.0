From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: simplify nf_defrag_ipv6
Date: Mon, 23 Nov 2015 17:57:41 +0100
Message-ID: <20151123165741.GA6411@salvia>
References: <1447885960-5495-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54281 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbbKWQ5q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Nov 2015 11:57:46 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EE0AEE1510
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 17:57:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DCFE6DA795
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 17:57:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E6C50DA795
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2015 17:57:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1447885960-5495-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 18, 2015 at 11:32:38PM +0100, Florian Westphal wrote:
> commit 6aafeef03b9d9ecf
> ("netfilter: push reasm skb through instead of original frag skbs")
> changed ipv6 defrag to not use the original skbs anymore.
> 
> However, we still clone fragment skbs and retain original ones
> just to free them soon after.  Since reassembled skb is newly
> allocated, we also need to recursively re-invoke the netfilter hooks
> so they can work on the reassembled skb.
> 
> This removes those clone/free operations and also avoids the
> hook reinvocation by morphing the reassembled skb into the last skb
> (i.e. the skb that completes the frag queue), just like ipv4 defrag.

Series applied, thanks for your patience Florian.
