From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: initial (im)port of ipt_ACCOUNT, ipt_pknock and ipt_stealth to xtables-addons-1.17
Date: Mon, 31 Aug 2009 17:27:26 +0200
Message-ID: <200908311727.26512.thomas.jarosch@intra2net.com>
References: <alpine.LNX.2.00.0908262011580.20390@cedric.unob.cz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Jan Engelhardt / xtables-addons" <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:36252 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZHaP10 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:27:26 -0400
In-Reply-To: <alpine.LNX.2.00.0908262011580.20390@cedric.unob.cz>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jan Rafaj,

On Thursday, 27. August 2009 17:53:33 Jan Rafaj wrote:
> - files have all been renamed from {lib,}ipt_* to {lib,}xt_*
>    (I know, they are still IPv4-only projects, but thats the policy
>    of Xt-a)

Thanks for your effort.

ipt_ACCOUNT is IPv4 only. Giving it a name of xt_ACCOUNT
will give the impression it works for IPv6, right?

> By releasing this, I only strongly (and selfishly, I admit) hope the
> authors of these projects will eventually see advantages of being part of
> xtables-addons, and will hopefully start to maintain these projects in
> xtables-addons tree from now on.

Well, I don't use xtables-addons myself :o)

ipt_ACCOUNT is maintained in it's own git tree here: 
http://www.intra2net.com/en/developer/ipt_ACCOUNT/repository.php

As development is currently in maintenance mode only,
it shouldn't hurt to have a copy in Xtables-addons, too.

Though I'm not sure if having two versions with different names
(xt_ACCOUNT, ipt_ACCOUNT) is a good idea.

Best regards,
Thomas Jarosch

