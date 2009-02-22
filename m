From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Re: [PATCH 2/2 v5] New netfilter target to trigger LED devices
Date: Mon, 23 Feb 2009 00:16:28 +1000
Message-ID: <49A15E3C.3090809@shikadi.net>
References: <49934702.9060909@shikadi.net> <4993B34C.1020307@trash.net>	 <49940D58.3040404@shikadi.net>  <49998E6C.2030504@trash.net> <1234878654.5312.34.camel@dax.rpnet.com> <499C17C2.9020502@trash.net> <499C899F.5010002@shikadi.net> <499E7E92.7030607@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:2271 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbZBVOQg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Feb 2009 09:16:36 -0500
In-Reply-To: <499E7E92.7030607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Applied, thanks. I've made some minor cosmetic changes, like removal
> of /* noconst */ annotations and fixing indentation in one spot.
> 
> You can look at the final commit at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git

Thanks Patrick, looks fine.  Did you fix the compile errors in your other 
post, or do you still want me to look at them?  It looks like it was compiled 
with LED support disabled, which I thought the kernel should take care of (not 
allowing the file to be compiled if LED support was not present.)

Did the other companion patch (1/2, the one to netfilter) also get committed? 
  Without that the new kernel module won't ever be used.

Cheers,
Adam.

