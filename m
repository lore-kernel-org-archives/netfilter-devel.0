From: Patrick McHardy <kaber@trash.net>
Subject: Re: arptables issue with user-defined chains and -j RETURN
Date: Wed, 11 Jun 2008 08:14:58 +0200
Message-ID: <484F6D62.8020602@trash.net>
References: <484EAE6E.30206@somanetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Ben Gamsa <ben@somanetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62086 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYFKGPB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:15:01 -0400
In-Reply-To: <484EAE6E.30206@somanetworks.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Gamsa wrote:
> I'm using version 0.0.3-3 of arptables (curently with a 2.6.20 kernel, soon
> to be upgraded) and it seems like explicit and implicit RETURNs are not 
> working.
> What I believe is happening is that arptables includes its own version of
> arp_tables.h (actually, two identical copies), with a definition for 
> ARPT_RETURN.
> Specifically, it defines it as:
> 
> #define ARPT_RETURN (-NF_MAX_VERDICT - 1)
> 
> while the kernel defines it as XT_RETURN, which in turn defines it as
> 
> #define XT_RETURN (-NF_REPEAT - 1)
> 
> The end result seems to be that rules that explicitly or implicitly use the
> target RETURN actually end up with the target STOP, and so returns from
> chains don't work.  Changing the definition of ARPT_RETURN in arptables to
> match the definition of XT_RETURN appears to fix the problem.


I think the error is in userspace, it shouldn't define the value
dependant on a non-fixed value. If the kernel did this as well
before the intoduction of x_tables (which defined ARPT_RETURN
to XT_RETURN), compatibility was already broken by the introduction
of NF_STOP a long time ago. So I think the correct fix is to
resync the arp_tables userspace header files with the kernel.
