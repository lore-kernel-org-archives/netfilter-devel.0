From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] use NF_BR_PRI_BRNF in NF_HOOK_THRESH
Date: Wed, 19 Nov 2014 14:35:18 +0100
Message-ID: <20141119133518.GA12197@salvia>
References: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1416366453-12090-2-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45514 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbaKSNdP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:33:15 -0500
Content-Disposition: inline
In-Reply-To: <1416366453-12090-2-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 19, 2014 at 11:07:33AM +0800, Gao feng wrote:
> packets jump to ip/ipv6/arp netfilter from bridge
> netfilter hooks whose priority are NF_BR_PRI_BRNF,
> so when packets return to bridge netfilter, the
> thresh is NF_BR_PRI_BRNF + 1.
> 
> this patch use marco NF_BR_PRI_BRNF + 1 to replace
> the number 1.

This code has been using this for long long time. It would be great if
you can include in the description what was broken before this patch
or if this is a simple cleanup. Thanks Feng.
