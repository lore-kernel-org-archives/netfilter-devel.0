From: Patrick McHardy <kaber@trash.net>
Subject: Re: How about issueing conntrack event in init_conntrack()?
Date: Thu, 15 Nov 2007 14:57:05 +0100
Message-ID: <473C5031.3040504@trash.net>
References: <200711151738170572772@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Daniel <zyzhou1@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45508 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbXKON5H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:57:07 -0500
In-Reply-To: <200711151738170572772@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Daniel wrote:
> hi, all
> 
> We all know event IPCT_NEW is issued whenever conntrack is confirmed,
> then how about issueing a IPCT_INIT event in init_conntrack()? 
> IPCT_INIT indicates that one IP is trying to create a connection, maybe 
> we can catch these kind of events, do some analyzation work, and block 
> the evil *attempting* packet(this will prevent conntrack being confirmed). 
> 
> Is this make any sense?


That wouldn't work since the connection is going to be confirmed
before you get a chance to do something. On SMP it might work,
but would be racy. In general ctnetlink events relate to the
conntrack table, so we don't want to send events for connections
that are not confirmed.

