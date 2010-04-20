From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] bridge-netfilter: fix refragmenting IP traffic encapsulated
 in PPPoE traffic
Date: Tue, 20 Apr 2010 16:22:44 +0200
Message-ID: <4BCDB8B4.30702@trash.net>
References: <4BC5BFB4.4080101@pandora.be> <4BC6EA8D.2030602@trash.net> <4BCDAD3D.80604@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49687 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab0DTOWp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:22:45 -0400
In-Reply-To: <4BCDAD3D.80604@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE traffic
>  
> The MTU for IP traffic encapsulated inside PPPoE traffic is smaller
> than the MTU of the Ethernet device (1500). Connection tracking
> gathers all IP packets and sometimes will refragment them in
> ip_fragment(). We then need to subtract the length of the
> encapsulating header from the mtu used in ip_fragment(). The check in
> br_nf_dev_queue_xmit() which determines if ip_fragment() has to be
> called is also updated for the PPPoE-encapsulated packets.
> nf_bridge_copy_header() is also updated to make sure the PPPoE data
> length field has the correct value.
> 

Applied, thanks Bart.
