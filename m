From: Andreas Herz <andi@geekosphere.org>
Subject: Re: function for getting the source ip defined in the routing table
Date: Tue, 3 Jun 2014 09:55:35 +0200
Message-ID: <20140603075535.GY10939@kvmbude>
References: <20140520124634.GM10939@kvmbude>
 <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.geekosphere.org ([78.47.150.211]:34966 "EHLO
	mail.geekosphere.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaFCHzh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:55:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405201602100.9387@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/05/14 at 16:03, Jan Engelhardt wrote:
> On Tuesday 2014-05-20 14:46, Andreas Herz wrote:
> 
> >i was looking for a function to get the source ip that is defined in the
> >routing table. I looked into the MASQUERADE module but the
> >"inet_select_addr" function returns the source ip from the interface
> >(the first one, in most use cases).
> >
> >See the following routing table entry:
> >
> >10.0.13.0/24 dev eth1  proto kernel  scope link  src 10.0.13.4
> >
> >while the interface has multiple IPs:
> >
> >    inet 10.0.12.1/24 scope global eth0
> >    inet 10.0.13.2/24 scope global eth0
> >    inet 10.0.13.4/24 scope global secondary eth0
> >
> >So what i want is the value of the src part in the routing table (for 
> >connections to the related network).
> 
> RTM_GETROUTE in netlink, `ip route get` on sh, and 
> ip6_route_output/ip_route_output_key in C.

I had some time to test around with "ip_route_output_key" but now i'm
stuck. Kernel used is 2.6.32.62.

If i call it with flowi fl set with daddr _and_ with saddr i come into
"ip_route_output_slow". Since i have a saddr set i ran into the part
with "if (oldflp->fl4_src)" which results in the "dev_out =
ip_dev_find(net, oldflp->fl4_src);" call.

But there the table lookup always uses the local table "local_table =
fib_get_table(net, RT_TABLE_LOCAL);" but since i have some packets that
are forwarded, there is no suitable entry in the local table but in some
self defined table.

In my described scenario i also have eth1 with 10.0.20.0/24 net and when
the packet comes from 10.0.20.2 there is no rule in the local table on
the forwarding linux system just in the $USERDEFINED table.

Is there a way to call "ip_route_output_key" with the daddr for this
packet and the saddr 10.0.20.2 to receive the information from the
$USERDEFINED table instead of parsing just the local table?

Or what is the reason that it's just looking into the local table?
Or did i miss some other way to parse other tables then the local one?

thanks so far!

-- 
Andreas Herz
