From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 01/06: Move linux/in.h and linux/in6.h inclusions
 outside of
Date: Mon, 18 Aug 2008 21:21:48 -0700 (PDT)
Message-ID: <20080818.212148.243561880.davem@davemloft.net>
References: <20080818165149.18978.80469.sendpatchset@localhost.localdomain>
	<alpine.LNX.1.10.0808181253010.3180@fbirervta.pbzchgretzou.qr>
	<48A9AAD8.9050104@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59370
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751125AbYHSEVs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:21:48 -0400
In-Reply-To: <48A9AAD8.9050104@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 18 Aug 2008 19:01:12 +0200

> Jan Engelhardt wrote:
> > On Monday 2008-08-18 12:51, Patrick McHardy wrote:
> > 
> >> netfilter: Move linux/in.h and linux/in6.h inclusions outside of #ifdef __KERNEL__
> >>
> >> netfilter.h can't be used in userspace without including linux/in.h
> >> and linux/in6.h first. netfilter.h includes its own linux/in.h and
> >> linux/in6.h include statements, these are stripped by make
> >> headers-install because they are inside #ifdef __KERNEL__ however.
> >> Move them out to fix this.
> > 
> > Humm - no, I do not think this is right.
> > 
> > 
> > $ cat test2.c 
> > #include <netinet/in.h>
> > 
> > /* simulate netfilter.h as proposed */
> > #include <linux/in.h>
> 
> Hmm good point. Dave, please drop this patch.

Ok.
