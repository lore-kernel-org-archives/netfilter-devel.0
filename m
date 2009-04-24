From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_recent compat code supposedly broken
Date: Fri, 24 Apr 2009 17:06:05 +0200
Message-ID: <49F1D55D.9000804@trash.net>
References: <alpine.LSU.2.00.0904241032310.20106@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0904241050030.22023@fbirervta.pbzchgretzou.qr> <49F1A362.6020109@open.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Josef Drexler <joe-lk@ttdpatch.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Roman Hoog Antink <rha@open.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47106 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbZDXPGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:06:11 -0400
In-Reply-To: <49F1A362.6020109@open.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Roman Hoog Antink wrote:
> Thank you!
> 
> Find attached the slightly adapted patch (nf_inet_addr is a union, not 
> struct). I tested it successfully with kernel 2.6.29 and it fixed the 
> compat path issue.

Applied, thanks everyone.
