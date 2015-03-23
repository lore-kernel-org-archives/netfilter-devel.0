From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] src: restore static array with expression
 operations
Date: Mon, 23 Mar 2015 13:34:00 +0100
Message-ID: <20150323123400.GA6511@salvia>
References: <1427111052-5510-1-git-send-email-pablo@netfilter.org>
 <20150323114411.GH603@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, ska-devel@skarnet.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57673 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbbCWMaM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2015 08:30:12 -0400
Content-Disposition: inline
In-Reply-To: <20150323114411.GH603@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 23, 2015 at 11:44:11AM +0000, Patrick McHardy wrote:
> On 23.03, Pablo Neira Ayuso wrote:
> > We cannot use __attribute__((constructor)) to register the supported
> > expressions in runtime when the library is statically linked. This lead
> > us to some explicit libnftnl_init() function that needs to be called
> > from the main() function of the client program.
> 
> Just wondering, why not? They should still be invoked, right?

This seems to run when the shared library is loaded. When the build is
static, that never happens.

In iptables, we're resolving this with an init_extensions() function
that is called from main() so these are registered in run-time. I
would like to skip such explicit call from the client programs.

If you have any better solution, let me know. I actually liked that
the expression class, including its registration was self-contained
:-(.

> > This patch reverts 4dd0772 ("expr: use __attribute__((constructor)) to
> > register expression").
> > 
> > Reported-by: Laurent Bercot <ska-devel@skarnet.org>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
