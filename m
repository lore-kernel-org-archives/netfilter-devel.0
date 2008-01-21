From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] check nfct_get_attr()!=NULL
Date: Mon, 21 Jan 2008 14:07:24 +0100
Message-ID: <4794990C.5050505@netfilter.org>
References: <20080121082752.27612.82519.stgit@rabbit.intern.cm-ag> <20080121082958.27612.50164.stgit@rabbit.intern.cm-ag> <479495C7.2010903@netfilter.org> <20080121125824.GA29741@swift.blarg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39840 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbYAUNHs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:07:48 -0500
In-Reply-To: <20080121125824.GA29741@swift.blarg.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> On 2008/01/21 13:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Max Kellermann wrote:
>>> from time to time, conntrackd segfaults in cache.c, function hash(),
>>> because it does not check the return value of nfct_get_attr().  For
>>> some reason (which I have not investigated), there is no
>>> ATTR_ORIG_IPV4_SRC.  A gdb dump of *ct after the segfault says the
>>> following:
>> I cannot reproduce this problem in my testbed. Are you running
>> conntrackd with IPv6 connections?
> 
> This machine uses IPv6 and IPv6 CT.  I have no idea what conntrackd
> does with these.

I started IPv6 support months ago but it's still incomplete. This is
probably the reason of this crash. We can fix the IPv6 code or
preventively disable it until we finish it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
