From: Chris Wilson <chris-netfilter-110904@aptivate.org>
Subject: Re: SNAT before IPSEC - why?
Date: Sat, 8 Oct 2011 09:06:52 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1110080902550.3657@lap-x201>
References: <4E8FB084.6030807@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from one-mail.aptivate.org ([87.106.150.205]:60342 "EHLO
	one-mail.aptivate.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1JHJRB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Oct 2011 05:17:01 -0400
In-Reply-To: <4E8FB084.6030807@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Stephen,

On Fri, 7 Oct 2011, Stephen Clark wrote:

> What is the reasoning for having SNAT happen before ipsec encryption?

You might well want to SNAT or MASQUERADE packets going through the 
tunnel, to have them fit within the tunnel's subnet, for example if you 
add a new local subnet and you don't want to reconfigure thousands of 
clients.

> It forces one to add special rules in the NAT table to keep this from 
> happening

You mean "iptables -t nat -A POSTROUTING -m policy --pol ipsec -j ACCEPT"? 
Doesn't seem very onerous to me.

Cheers, Chris.
-- 
Aptivate | http://www.aptivate.org | Phone: +44 1223 760887
The Humanitarian Centre, Fenner's, Gresham Road, Cambridge CB1 2ES

Aptivate is a not-for-profit company registered in England and Wales
with company number 04980791.

