From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix accepting invalid RST segments
Date: Mon, 25 May 2009 17:24:09 +0200
Message-ID: <4A1AB819.6000503@trash.net>
References: <alpine.DEB.2.00.0905251204300.19770@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61241 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbZEYPYK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2009 11:24:10 -0400
In-Reply-To: <alpine.DEB.2.00.0905251204300.19770@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Patrick,
> 
> Robert L Mathews discovered that some clients send evil TCP RST segments, 
> which are accepted by netfilter conntrack but discarded by the 
> destination. Thus the conntrack entry is destroyed but the destination 
> retransmits data until timeout.
> 
> The same technique, i.e. sending properly crafted RST segments, can easily 
> be used to bypass connlimit/connbytes based restrictions (the sample 
> script written by Robert can be found in the netfilter mailing list 
> archives).
> 
> The patch below adds a new flag and new field to struct ip_ct_tcp_state so 
> that checking RST segments can be made more strict and thus TCP conntrack 
> can catch the invalid ones: the RST segment is accepted only if its 
> sequence number higher than or equal to the highest ack we seen from the 
> other direction. (The last_ack field cannot be reused because it is used 
> to catch resent packets.)


Applied, thanks.

