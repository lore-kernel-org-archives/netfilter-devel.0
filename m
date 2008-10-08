From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TEE for IPv6
Date: Tue, 7 Oct 2008 21:09:06 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810072057470.5686@fbirervta.pbzchgretzou.qr>
References: <48D93817.40909@critical.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: sebastian.classen@freenet.ag,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Mike Wileczka <mike.wileczka@critical.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60589 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHBJJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 21:09:09 -0400
In-Reply-To: <48D93817.40909@critical.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-09-23 14:40, Mike Wileczka wrote:

> Hello, It appears that the TEE target is not supported under IPv6. 
> Is that true?  Is there any quick way to get it working?

It is true that there is currently no code for handling IPv6.

There might be a quick way, but I do not know what functions to
use. There are so many related to routing.
ip6_dst_lookup or ip6_route_output, to be or not to be, etc.
