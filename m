From: Thomas Graf <tgraf@infradead.org>
Subject: Re: XT_CONTINUE/EBT_CONTINUE for universal modules
Date: Wed, 9 Mar 2011 06:07:04 -0500
Message-ID: <20110309110704.GB28673@canuck.infradead.org>
References: <20110308120815.GA28673@canuck.infradead.org>
 <alpine.LNX.2.01.1103081443350.32577@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1CILHJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 06:07:09 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1103081443350.32577@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2011 at 02:53:14PM +0100, Jan Engelhardt wrote:
> On Tuesday 2011-03-08 13:08, Thomas Graf wrote:
> >
> >xt_AUDIT.c currently returns XT_CONTINUE. The module is universal and would
> >be useable from ebtables if it wasn't for ebtables to expect EBT_CONTINUE.
> >
> >Is the only way around this cloning xt_AUDIT.c to ebt_audit.c?
> 
> You could make all ebt targets ust XT_* values, provided that they are 
> translated from/to EBT_* when reading/writing the table from/to 
> userspace.

I guess it's not worth it considering that Xtables2 is around the corner.

I'll just clone xt_AUDIT.

> >I've seen some patches from Jan converting ebtables to use xtables 
> >infrastucture but they haven't been merged.
> 
> >From what I remember, they have become
> v2.6.28-rc1~717^2~109^2~29..v2.6.28-rc1~717^2~109^2~18 .
> If not, which patches would you be referring to?

I was referring to:

11/13 [NETFILTER]: Make Ebtables use Xtables infrastructure
