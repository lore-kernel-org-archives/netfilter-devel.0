From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/7] Let xt_connlimit use nf_inet_addr
Date: Mon, 17 Dec 2007 13:33:45 +0100
Message-ID: <47666CA9.9070901@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070336490.1262@fbirervta.pbzchgretzou.qr> <475E6445.4090202@trash.net> <Pine.LNX.4.64.0712151312000.22877@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56458 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbXLQMea (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:34:30 -0500
In-Reply-To: <Pine.LNX.4.64.0712151312000.22877@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Make xt_connlimit use the new union nf_inet_addr.

Applied, thanks. Could you make your subjects follow the
naming convention for netfilter patches please? That
would avoid the need to edit them every time I apply
a patch:

[NETFILTER]: xt_connlimit: use the new union nf_inet_addr

Somewhere in the email itself would also be fine.
