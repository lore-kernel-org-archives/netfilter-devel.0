From: Michael Farrell <micolous+nf@gmail.com>
Subject: Re: xtables-addons: patch for addition of "no-change" option for
	xt_quota2
Date: Sun, 3 Jan 2010 18:22:07 +1100
Message-ID: <cdd9a51a1001022322k3ba3d224ne4837eaa454281c7@mail.gmail.com>
References: <1262013837.19823.48.camel@milliways>
	 <alpine.LSU.2.01.0912311629560.17265@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:63934 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0ACHWI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2010 02:22:08 -0500
Received: by ywh6 with SMTP id 6so14504316ywh.4
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Jan 2010 23:22:07 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.0912311629560.17265@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2010/1/1 Jan Engelhardt <jengelh@medozas.de>:
> On Monday 2009-12-28 16:23, Michael Farrell wrote:
>>
>>I've written a patch to add an option to xt_quota2 called "no-change".
>>The effect of this option, while it is enabled, is that it will skip
>>incrementing or decrementing the quota counter.
>
> I applied the patch, with a number of changes.
>
> [snip]

Okay, thanks for those changes, I wasn't entirely sure of the procedure.

--Michael Farrell
