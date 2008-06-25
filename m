From: Patrick McHardy <kaber@trash.net>
Subject: Re: Remove libipq from source tree
Date: Wed, 25 Jun 2008 12:18:00 +0200
Message-ID: <48621B58.5010905@trash.net>
References: <alpine.LNX.1.10.0806251032540.31898@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48639 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbYFYKSG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:18:06 -0400
In-Reply-To: <alpine.LNX.1.10.0806251032540.31898@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Suggestive patch.
> 
> ====
> commit cf230b83b5df3e9c74e434b6feecbb13ea641d7f
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Jun 25 10:29:50 2008 +0200
> 
> Remove libipq
>     
> libipq has been obsoleted by libnetfilter_queue, which also
> provides a compat layer, should the need arise.

I don't want to apply this for the same reason why I un-scheduled
ip_queue of removal:

- the compat layer doesn't work (look at the code, it simply
   does nothing)

- the old library is statically linked, so its not a drop-in
   replacement

- the compat library only works (theoretically) with
   nfnetlink_queue, so you can't write an application
   that works on both old and new kernels

