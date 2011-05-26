From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Fix several warnings in compat_mtw_from_user().
Date: Thu, 26 May 2011 18:44:05 +0200
Message-ID: <4DDE8355.1060604@netfilter.org>
References: <20110519.181439.385337593682366302.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50401 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab1EZQoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2011 12:44:09 -0400
In-Reply-To: <20110519.181439.385337593682366302.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/05/11 00:14, David Miller wrote:
> 
> Kill set but not used 'entry_offset'.
> 
> Add a default case to the switch statement so the compiler
> can see that we always initialize off and size_kern before
> using them.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

applied to my nf-2.6 tree, thanks.

http://1984.lsi.us.es/git/?p=net-2.6/.git;a=shortlog;h=refs/heads/pablo/nf-2.6-updates
