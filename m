From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] ebtables printing of ipv6 masks
Date: Mon, 14 Apr 2014 22:14:44 +0200
Message-ID: <534C41B4.7020003@pandora.be>
References: <201404111528.42153.mmazur@axeos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Mariusz Mazur <mmazur@axeos.com>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:37850 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaDNUOs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:14:48 -0400
In-Reply-To: <201404111528.42153.mmazur@axeos.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mariusz Mazur schreef op 11/04/2014 15:28:
> Currently ebtables is smart enough to not print /255.255.255.255 for ipv4
> addresses, not so however for ipv6 addresses. The attached patch fixes that.
>
> (Not sure my kmail won't mangle it, so here it is uploaded:
> http://u.42.pl/2T8O )
>
> --mmazur
>

Your patch introduces a bug when printing the IPv6 destination mask. 
I've applied a fixed version.

cheers,
Bart

