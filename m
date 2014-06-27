From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: sockopts
Date: Fri, 27 Jun 2014 19:11:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1406271909340.14571@nerf08.vanv.qr>
References: <Pine.LNX.4.64.1406271607001.4915@fedex.thefeds.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: netfilter@tsaunders.co.uk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:56269 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaF0RLs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:11:48 -0400
In-Reply-To: <Pine.LNX.4.64.1406271607001.4915@fedex.thefeds.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2014-06-27 17:13, netfilter@tsaunders.co.uk wrote:

> I am maintaining a proprietary netfilter module. The module fails to load when
> ip_set is loaded and ip_set won't load when it is loaded. I think this may be
> because the sockopt number the original developer chose clashes with the number
> ip_set uses. Would this clash cause such a problem?
>
> I have read the netfilter hacking howto and searched, but I cannot find any
> details of how to choose a sockopt number. Is there any documentation?

There are no provisions for external software to select subsystem 
numbers (either sockopt or netlink numbers). The closest thing that is 
friendly to external modules is genetlink which uses a string that is 
rather clash-free.
