From: Patrick McHardy <kaber@trash.net>
Subject: Re: resend|stable: netfilter: xt_quota: fix wrong return value (error
 case)
Date: Thu, 13 Aug 2009 15:42:47 +0200
Message-ID: <4A841857.5000803@trash.net>
References: <alpine.LSU.2.00.0908111949130.1698@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63222 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZHMNmx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2009 09:42:53 -0400
In-Reply-To: <alpine.LSU.2.00.0908111949130.1698@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> parent 244e5a09ed31c698654a7f9a2150b4c79efe46fd (v2.6.31-rc1-59-g244e5a0)
> commit 8240c9c836726615e9fb164fb7637c0156560b2e
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Jul 22 04:42:09 2009 +0200
> 
> netfilter: xt_quota: fix wrong return value (error case)
> 
> Success was indicated on a memory allocation failure, thereby causing
> a crash due to a later NULL deref.
> (Affects v2.6.30-rc1 up to here.)

Applied, thanks. I'll pass it to -stable once it hits upstream.
