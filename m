From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Fri, 19 Mar 2010 17:19:54 +0100
Message-ID: <201003191719.54550.thomas.jarosch@intra2net.com>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <201003191604.45719.thomas.jarosch@intra2net.com> <4BA39B3D.4070509@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:50684 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab0CSQT6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:19:58 -0400
In-Reply-To: <4BA39B3D.4070509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday, 19. March 2010 16:41:49 you wrote:
> > Maybe this is related to the xt_recent
> > proc interface creating the entry
> > (with a zero hit count)?
> 
> Mhh, looking at that patch again, I think it should actually do:
> 
> if (!info->hit_count || ++hits >= info->hit_count)
>     ...
> 
> since a hit_count of 0 implies that the user just wants to check for the
> presence of the entry. Thomas, could you give that a try?

The new code works. Isn't that almost the same as reverting
the original patch? info->hit_count == 0 will match again.

So we could just go back to

"if (++hits >= info->hit_count)"

Or am I missing something?

Clearly your new version is more readable about the intent.

Cheers,
Thomas
