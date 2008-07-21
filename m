From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH] selinux: use nf_register_hooks()
Date: Tue, 22 Jul 2008 07:27:57 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0807220726460.25813@us.intercode.com.au>
References: <20080721162503.GB13264@martell.zuzino.mipt.ru> <4884B992.1040100@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov,
	eparis@parisplace.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from namei.org ([69.55.235.186]:36738 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751027AbYGUV2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 17:28:10 -0400
In-Reply-To: <4884B992.1040100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 21 Jul 2008, Patrick McHardy wrote:

> Alexey Dobriyan wrote:
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  security/selinux/hooks.c |   27 ++++++++-------------------
> >  1 file changed, 8 insertions(+), 19 deletions(-)
> 
> I can pick this up or it can go through the SELinux tree.
> Stephen, James?

Probably simplest for you to take it while I'm travelling.

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
