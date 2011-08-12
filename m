From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Mark ESP packets
Date: Fri, 12 Aug 2011 16:04:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1108121603320.18290@frira.zrqbmnf.qr>
References: <4E453298.7040304@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46642 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1HLOE3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2011 10:04:29 -0400
In-Reply-To: <4E453298.7040304@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-08-12 16:03, Stephen Clark wrote:

> Hello,
>
> Is it possible to mark esp packets so they can be identified when the
> re-traverse netfilter as unencrypted packets?

It should be, as the skb remains the same.
Or you could also use -m policy --dir in --proto esp on unencrypted 
packets.
