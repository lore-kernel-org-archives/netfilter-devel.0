From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] netfilter: nfnetlink_log: fix NLA_PUT macro
 removal bug
Date: Mon, 20 Aug 2012 16:52:06 +0200
Message-ID: <20120820145206.GB18676@1984>
References: <1345407370-30009-1-git-send-email-kaber@trash.net>
 <1345407370-30009-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52810 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756928Ab2HTOwJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:52:09 -0400
Content-Disposition: inline
In-Reply-To: <1345407370-30009-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 19, 2012 at 10:16:08PM +0200, Patrick McHardy wrote:
> Commit 1db20a52 (nfnetlink_log: Stop using NLA_PUT*().) incorrectly
> converted a NLA_PUT_BE16 macro to nla_put_be32() in nfnetlink_log:
> 
> -               NLA_PUT_BE16(inst->skb, NFULA_HWTYPE, htons(skb->dev->type));
> +               if (nla_put_be32(inst->skb, NFULA_HWTYPE, htons(skb->dev->type))

queued for net tree. Thanks Patrick.
