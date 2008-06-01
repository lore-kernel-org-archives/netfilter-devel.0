From: Patrick McHardy <kaber@trash.net>
Subject: Re: Number of concurrent connections?
Date: Sun, 01 Jun 2008 23:15:53 +0200
Message-ID: <48431189.60604@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A315@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46397 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYFAVP6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:15:58 -0400
In-Reply-To: <925A849792280C4E80C5461017A4B8A226A315@mail733.InfraSupportEtc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Scott wrote:
> Hello - 
>  
> How fast has anyone pushed netfilter?  Assuming I can put together a
> beefy enough hardware platform, what are the possibilities of supporting
> 1 million concurrent connections with at least 2gb per second stateful
> packet filtering throughput? 

I've heard of a lot bigger setups with multiple (IIRC 10) million
concurrent connection.

> Let's say I can get my hands on 10gb NICs - how fast can netfilter push
> them?

I don't know, but I'd be interested in that too :)
