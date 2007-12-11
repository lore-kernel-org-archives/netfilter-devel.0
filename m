From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] Introduce nf_inet_address
Date: Tue, 11 Dec 2007 11:16:58 +0100
Message-ID: <475E639A.9040501@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43514 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbXLKKRA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:17:00 -0500
In-Reply-To: <Pine.LNX.4.64.0712070336010.1262@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> A few netfilter modules provide their own union of IPv4 and IPv6
> address storage. Will unify that in this patch series.
> 
> (1/4): Rename union nf_conntrack_address to union nf_inet_addr and
> move it to x_tables.h.

netfilter.h seems more appropriate for this than x_tables.h,
so I'll move it unless there are good reasons not to.
