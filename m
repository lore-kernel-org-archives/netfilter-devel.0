From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_route_me_harder question
Date: Mon, 12 Jan 2009 06:18:03 +0100
Message-ID: <496AD28B.5070300@trash.net>
References: <417f50830901070919u7c90ac16x5771bece809568e4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giant Sand Fan's <rampxxxx@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55668 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZALFST (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:18:19 -0500
In-Reply-To: <417f50830901070919u7c90ac16x5771bece809568e4@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Giant Sand Fan's wrote:
> Hi,
> 
> I have a netfilter module that needs to reroute a packet after
> unpacking it (minimal encap) in NF_IP_PRE_ROUTING, because the dst
> changes. But even when a ip_route_me_harder with RTN_LOCAL works
> (ret==0) the packet disappears.
> 
> The question is , do i need to use ip_route_me_harder? because when
> the dst of encapsulated packet is the local machine it works.

You don't need rerouting in *PRE*ROUTING, regular routing will
take care of this.
