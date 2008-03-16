From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: figuring out the udp port number (in linux >= 2.6.22)
Date: Mon, 17 Mar 2008 00:58:57 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803170057590.14822@fbirervta.pbzchgretzou.qr>
References: <200803170043.m2H0h2Xi016908@dell2.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Marty Leisner <leisner@rochester.rr.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56093 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYCPX67 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 19:58:59 -0400
In-Reply-To: <200803170043.m2H0h2Xi016908@dell2.home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 16 2008 19:43, Marty Leisner wrote:
>
>Obviously I'm doing something wrong...My UDP port 
>numbers look all wrong (I took at them raw and ran them 
>through ntohs to see if anything looked right)
>*They're a type __be16 -- which is network byte order?)

__be16 is an annotated tag. It is still unsigned short
internally, but is there to indicate big-endian encoding is used.

>BTW, the IP addresses look fine, I wrote my own inet_ntoa_r...

But what for?

printk("Addr: " NIP_FMT "\n", NIPQUAD(some struct in_addr));
