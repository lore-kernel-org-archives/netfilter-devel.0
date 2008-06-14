From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: arptables issue with user-defined chains and -j RETURN
Date: Sat, 14 Jun 2008 20:02:20 +0200
Message-ID: <1213466540.2945.13.camel@localhost.localdomain>
References: <484EAE6E.30206@somanetworks.com>  <484F6D62.8020602@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ben Gamsa <ben@somanetworks.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:42336 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbYFNSC4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jun 2008 14:02:56 -0400
Received: from winston.telenet-ops.be (winston.telenet-ops.be [195.130.137.75])
	by yorgi.telenet-ops.be (Postfix) with ESMTP id 13BEB6009DA
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Jun 2008 20:02:55 +0200 (CEST)
In-Reply-To: <484F6D62.8020602@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op wo, 11-06-2008 te 08:14 +0200, schreef Patrick McHardy:
> Ben Gamsa wrote:
> > I'm using version 0.0.3-3 of arptables (curently with a 2.6.20 kernel, soon
> > to be upgraded) and it seems like explicit and implicit RETURNs are not 
> > working.
> > What I believe is happening is that arptables includes its own version of
> > arp_tables.h (actually, two identical copies), with a definition for 
> > ARPT_RETURN.
> > Specifically, it defines it as:
> > 
> > #define ARPT_RETURN (-NF_MAX_VERDICT - 1)
> > 
> > while the kernel defines it as XT_RETURN, which in turn defines it as
> > 
> > #define XT_RETURN (-NF_REPEAT - 1)
> > 
> > The end result seems to be that rules that explicitly or implicitly use the
> > target RETURN actually end up with the target STOP, and so returns from
> > chains don't work.  Changing the definition of ARPT_RETURN in arptables to
> > match the definition of XT_RETURN appears to fix the problem.
> 
> 
> I think the error is in userspace, it shouldn't define the value
> dependant on a non-fixed value. If the kernel did this as well
> before the intoduction of x_tables (which defined ARPT_RETURN
> to XT_RETURN), compatibility was already broken by the introduction
> of NF_STOP a long time ago. So I think the correct fix is to
> resync the arp_tables userspace header files with the kernel.

Things compile fine from CVS using the KERNEL_DIR directive with your
favorite kernel source.
I'm having more trouble than I like getting things to compile by just
also including x_tables.h in the local arptables directory (__be16 isn't
defined). I guess my /usr/include/linux directory isn't up-to-date. Is
there any directive about this? How does iptables cope with this?

cheers,
Bart


