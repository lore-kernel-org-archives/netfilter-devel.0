From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next,resend] netfilter: bridge: remove
 BRNF_STATE_BRIDGED flag
Date: Mon, 16 Mar 2015 23:52:24 +0100
Message-ID: <20150316225224.GB4435@salvia>
References: <1425980208-9939-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54972 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbbCPWsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 18:48:33 -0400
Content-Disposition: inline
In-Reply-To: <1425980208-9939-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 10, 2015 at 10:36:48AM +0100, Florian Westphal wrote:
> Its not needed anymore since 2bf540b73ed5b
> ([NETFILTER]: bridge-netfilter: remove deferred hooks).
> Before this it was possible to have physoutdev set for locally generated
> packets -- this isn't the case anymore:
> 
> BRNF_STATE_BRIDGED flag is set when we assign nf_bridge->physoutdev,
> so physoutdev != NULL means BRNF_STATE_BRIDGED is set.
> If physoutdev is NULL, then we are looking at locally-delivered and
> routed packet.

Also applied, thanks.
