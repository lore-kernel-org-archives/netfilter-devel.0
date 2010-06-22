From: Patrick McHardy <kaber@trash.net>
Subject: Re: multi-path route can't keep long time connections
Date: Tue, 22 Jun 2010 08:16:17 +0200
Message-ID: <4C205531.2010402@trash.net>
References: <AANLkTimeYhY-lgY2c5dfYQRDZ2oDLpB1U7TzkvyFQh_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: tingwei liu <tingw.liu@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40853 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab0FVGQS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:16:18 -0400
In-Reply-To: <AANLkTimeYhY-lgY2c5dfYQRDZ2oDLpB1U7TzkvyFQh_A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

tingwei liu wrote:
> Because route circularly flush route cache
> (/proc/net/sys/ipv4/route/secret_timeval),the multi-path route can't
> keep long time connections. The long time connections maybe interrupt
> every "secret_timeval" seconds.
> Such as:
> default nexthop via 192.168.0.1 weight 1
>                        via 192.168.1.1 weight 1
>                        via 192.168.2.1 weight 1
>
> With a connection cross 192.168.0.1 in the first time."secret_timeval"
> seconds later,this connection maybe cross 192.168.1.1,then this
> connection will be reconnect.
>
> Anyone can help me?

Use CONNMARK to mark new connections, than use that mark
to bind them to a specific route.
