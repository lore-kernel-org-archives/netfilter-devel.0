From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] rule: don't reorder protocol payload expressions
 when merging
Date: Fri, 6 Nov 2015 14:35:48 +0100
Message-ID: <20151106133548.GB6142@salvia>
References: <1443237243-4571-1-git-send-email-fw@strlen.de>
 <1443237243-4571-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47908 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033190AbbKFN2d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 08:28:33 -0500
Content-Disposition: inline
In-Reply-To: <1443237243-4571-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 26, 2015 at 05:14:03AM +0200, Florian Westphal wrote:
> An instruction like
> 
>  bridge filter input ip saddr 1.2.3.4 ether saddr a:b:c:d:e:f
> 
> is displayed as
> 
> unknown unknown 0x1020304 [invalid type] ether saddr 00:0f:54:0c:11:04 ether type ip
> 
> .. because the (implicit) 'ether type ip' that is injected before the
> network header match gets merged into the ether saddr instruction.
> 
> This inverts the merge in case the merge candidate contains
> a next header protocol field.
> 
> After this change, the rule will be displayed as
> 
> bridge filter input ether saddr a:b:c:d:e:f ip saddr 1.2.3.4
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
