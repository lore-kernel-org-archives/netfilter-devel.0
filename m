From: Patrick McHardy <kaber@trash.net>
Subject: Re: queuing pkts using nf_queue_handler in bridge (PF_BRIDGE) mode
 not 	working in 2.6 kernel
Date: Wed, 18 Feb 2009 11:26:08 +0100
Message-ID: <499BE240.6050204@trash.net>
References: <c6c752b20902171954k4439c1dsc7c311c4863deaef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ratnaraj Mirgal <ratnaraj20@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48456 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZBRK0L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:26:11 -0500
In-Reply-To: <c6c752b20902171954k4439c1dsc7c311c4863deaef@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ratnaraj Mirgal wrote:
> Hi,
> 
> i'm trying a simple lkm tht register a hook in PF_BRIDGE protocol,
> also registers a queue_handler for the same.
> the hook function simply returns NF_QUEUE for all IP pakcets.
> 
> i'm trying this out in 2.6.18-8.el5 (centos 5.0)
> 
> it seems like pkts are queuing up, but the _problem_ is queue_handler
> is not getting invoked.
> plz refer to the code below.
> 
> (NOTE: the same program worked fine in my rh9 (ie 2.4 kernel), of
> course with minor nf API modification)

The bridge netfilter code doesn't register an afinfo with the
netfilter core, so queueing drops the packets. Its actually
not needed since bridge netfilter doesn't need to reroute anyways.
So you basically need to change the __nf_queue function to only
invoke the af-specific functions if an afinfo is available.

Patches welcome btw :)


