From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH:RFC 1/5] bridge-netfilter: cleanup br_netfilter.c
Date: Tue, 13 Apr 2010 11:41:21 +0200
Message-ID: <4BC43C41.9030305@trash.net>
References: <4BB20790.6050300@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45684 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0DMJlY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:41:24 -0400
In-Reply-To: <4BB20790.6050300@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> bridge-netfilter: cleanup br_netfilter.c
> 
> - remove some of the graffiti at the head of br_netfilter.c
> - remove __br_dnat_complain()
> - remove KERN_INFO messages when CONFIG_NETFILTER_DEBUG is defined

I've already applied this patch so you don't need to resend.
Thanks Bart.

