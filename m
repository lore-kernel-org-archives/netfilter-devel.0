From: Patrick McHardy <kaber@trash.net>
Subject: Re: Rejecting non-CIDR conformant masks?
Date: Mon, 19 Jan 2009 19:24:45 +0100
Message-ID: <4974C56D.7020903@trash.net>
References: <alpine.LSU.2.00.0901191917001.7294@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44492 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbZASSYs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:24:48 -0500
In-Reply-To: <alpine.LSU.2.00.0901191917001.7294@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> once again, with that lovely IRC channel that is out there, I noticed a 
> software that produces odd rules, and indeed, the latest iptables 
> (and ip6tables) seem to allow a match that has no equivalent CIDR
> number, such as:
> 
> 	-A test -d 0.0.0.123/0.0.0.255
> 
> It absolutely works, but if iptables is supposed to support that (is 
> it?), I should be adding it to the manpage.
> Comments?

Its supposed to work, apparently people have been using masks like
/0.0.0.1 for load-balancing with better distribution than /1 :)
