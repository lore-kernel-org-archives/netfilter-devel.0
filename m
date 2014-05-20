From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: function for getting the source ip defined in the routing
 table
Date: Tue, 20 May 2014 16:03:25 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
References: <20140520124634.GM10939@kvmbude>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:36017 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaETOD1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2014 10:03:27 -0400
In-Reply-To: <20140520124634.GM10939@kvmbude>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2014-05-20 14:46, Andreas Herz wrote:

>i was looking for a function to get the source ip that is defined in the
>routing table. I looked into the MASQUERADE module but the
>"inet_select_addr" function returns the source ip from the interface
>(the first one, in most use cases).
>
>See the following routing table entry:
>
>10.0.13.0/24 dev eth1  proto kernel  scope link  src 10.0.13.4
>
>while the interface has multiple IPs:
>
>    inet 10.0.12.1/24 scope global eth0
>    inet 10.0.13.2/24 scope global eth0
>    inet 10.0.13.4/24 scope global secondary eth0
>
>So what i want is the value of the src part in the routing table (for 
>connections to the related network).

RTM_GETROUTE in netlink, `ip route get` on sh, and 
ip6_route_output/ip_route_output_key in C.
