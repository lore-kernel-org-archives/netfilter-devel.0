From: "George Spelvin" <linux@horizon.com>
Subject: Re: v3.10-rc7 oops soon after boot
Date: 24 Jun 2013 18:17:08 -0400
Message-ID: <20130624221708.15489.qmail@science.horizon.com>
References: <20130624161305.GC26766@pd.tnic>
Cc: gaofeng@cn.fujitsu.com, kaber@trash.net,
	linux-kernel@vger.kernel.org, linux@horizon.com,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: bp@alien8.de, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:24619 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751076Ab3FXWRL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:17:11 -0400
In-Reply-To: <20130624161305.GC26766@pd.tnic>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Reported-by: Borislav Petkov <bp@alien8.de>

> This should be:
>
> Reported-by: George Spelvin <linux@horizon.com>
>
> I only connected the dots...

Well, you did a whole lot more than me!  I just lobbed a "d'oh, it
crashes" into the seething ocean of lkml.  (Admittedly, I had reason
to act fast: we're very close to release.)

You figured out what subsystem was at fault and got the right people
involved.  Definitely a valuable contribution.

Me, personally, I don't give a flying f*** about such credit; I had
an itch and was trolling for someone to scratch it.

So feel free to take Reported-by (you are the one who reported it *to
someone who could fix it*), Triaged-by, or whatever.
