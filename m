From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] statement: avoid huge rodata array
Date: Tue, 22 Oct 2013 15:15:23 +0200
Message-ID: <20131022131523.GA7062@localhost>
References: <1382445302-8050-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43259 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab3JVNP3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:15:29 -0400
Content-Disposition: inline
In-Reply-To: <1382445302-8050-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 22, 2013 at 02:35:02PM +0200, Florian Westphal wrote:
> commit b259d1a ('src: operational limit match') creates huge
> array, increasing nft binary size from ~240k to ~5m on x86_64.
> 
> Use switch statement instead.

Thanks Florian.

Applied a similar patch for libnftables:

http://git.netfilter.org/libnftables/commit/?id=cc9d2851135901d11e21b1a0332e83119124d083
