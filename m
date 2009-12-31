From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [xtables-addons][PATCH 0/2] Misc ipset issues
Date: Thu, 31 Dec 2009 16:18:18 +0100 (CET)
Message-ID: <alpine.LSU.2.01.0912311617520.17265@obet.zrqbmnf.qr>
References: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kevin Locke <kevin@kevinlocke.name>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48144 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZLaPSU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:18:20 -0500
In-Reply-To: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-12-19 21:50, Kevin Locke wrote:
>
>I just wanted to express my thanks for writing/maintaining ipset and
>xtables-addons.  I have found them to be very useful.
>
>I ran across a few issues getting ipset to work on my system and
>wanted to bring them up here for consideration.
>
>The first is that in 2.6.33-rc1, sk_buff->iff was renamed to
>sk_buff->skb_iif, which breaks compilation on kernels going forward.
>
>The second issue is that the setlist module is currently not being
>built which results in "ipset v4.1: Unknown set type" when attempting
>to create a set of this type (as documented in the man page).  I'm not
>sure if this is intentional (if it is, feel free to ignore that
>patch), but in my experience it has worked quite well with the
>exception of -T not working as expected (or at all AFAICT).

Thanks for the two patches, I applied them.
