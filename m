From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] xtables-addons: build against 3.8.y
Date: Tue, 12 Mar 2013 13:42:02 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303121341500.31935@nerf07.vanv.qr>
References: <20130312081812.GB11508@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:57133 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653Ab3CLMmE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:42:04 -0400
In-Reply-To: <20130312081812.GB11508@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-03-12 09:18, Holger Eitzenberger wrote:

>Hi Jan,
>
>I see that xtables-addons 1.47.1 do not build against kernel 3.8.2,
>because of ipv6_find_hdr() having moved to <net/ipv6.h>.  And this
>include is missing from xt_SYSREQ.c:

Support for 3.8 is available in xt-a 2.1.
