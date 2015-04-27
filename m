From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: nf_tables: fix wrong length for
 jump/goto verdicts
Date: Mon, 27 Apr 2015 13:27:09 +0200
Message-ID: <20150427112709.GB3684@salvia>
References: <1429022654-24585-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38931 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbbD0LWx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2015 07:22:53 -0400
Content-Disposition: inline
In-Reply-To: <1429022654-24585-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 14, 2015 at 04:44:14PM +0200, Florian Westphal wrote:
> NFT_JUMP/GOTO erronously sets length to sizeof(void *).
> 
> We then allocate insufficient memory when such element is added to a vmap.

Applied, thanks Florian.
