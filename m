From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Accessing packet marking functions
Date: Sat, 19 Jun 2010 22:01:01 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
References: <1276965739.1476.35.camel@andybev>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Andrew Beverley <andy@andybev.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44245 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab0FSUBD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Jun 2010 16:01:03 -0400
In-Reply-To: <1276965739.1476.35.camel@andybev>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-06-19 18:42, Andrew Beverley wrote:

>I am considering patching Squid proxy so that it retains a packet's mark
>value if it could not be fetched from the cache. Squid already has
>similar functionality for the TOS field, but I would like to extend this
>to netfilter's mark feature.
>
>Can somebody point me in the right direction for the correct way of
>setting and accessing the mark value of a packet? The TOS feature in
>Squid uses setsockopt(). Is there an equivalent for mark? Should I be
>using libnetfilter_queue?

setsockopt(fd, SOL_SOCKET, SO_MARK, ...)
