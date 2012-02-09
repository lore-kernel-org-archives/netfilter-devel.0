From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: alignment problem with ebt_among on ppc
Date: Thu, 09 Feb 2012 20:22:54 +0100
Message-ID: <4F341D0E.3020209@pandora.be>
References: <Pine.LNX.4.64.1202030819151.17732@brian.int.clnt.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: joe@clnt.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:60878 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab2BITXB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Feb 2012 14:23:01 -0500
In-Reply-To: <Pine.LNX.4.64.1202030819151.17732@brian.int.clnt.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 3/02/2012 8:21, joe@clnt.de schreef:
> What I've seen is that ebt_among extension of ebtables uses
> __alignof__(_xt_align) while the corresponding kernel module uses
> __alignof__(ebt_replace) to determin the alignment in EBT_ALIGN().
>
> These are the results of these values on different platforms:
>
> x86 x86_64 ppc
> __alignof__(_xt_align) 4 8 8
> __alignof__(ebt_replace) 4 8 4
>
> So I assume here we can see why ebtales fails to add rules which use the
> among extension.
>
> I'm using kernel 2.6.33 and ebtables 2.0.10-4
>
> Is this a known issue or are there any suggestions how to circumvent this
> problem?
> Thankyou very much.

The userspace alignment was changed to _xt_align to fix an alignment 
issue on a userspace32-kernel64 system (I think it was for an ARM 
device). So userspace must be right. The kernel alignment macro needs to 
change so it also uses _xt_align instead of ebt_replace. The userspace 
changes date back from June 29, 2009.
Can you do these changes and provide a patch?

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
