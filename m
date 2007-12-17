From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/7] Let xt_connlimit use nf_inet_addr
Date: Mon, 17 Dec 2007 13:52:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712171351510.32270@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0712070336490.1262@fbirervta.pbzchgretzou.qr>
 <475E6445.4090202@trash.net> <Pine.LNX.4.64.0712151312000.22877@fbirervta.pbzchgretzou.qr>
 <47666CA9.9070901@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50248 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbXLQMwn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:52:43 -0500
In-Reply-To: <47666CA9.9070901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 17 2007 13:33, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Make xt_connlimit use the new union nf_inet_addr.
>
> Applied, thanks. Could you make your subjects follow the
> naming convention for netfilter patches please? That
> would avoid the need to edit them every time I apply
> a patch:
>
> [NETFILTER]: xt_connlimit: use the new union nf_inet_addr

Ok!

> Somewhere in the email itself would also be fine.
>
That generally does not work :P  - the git changelog then
has the same line twice. (Look at `git log
67b4af297033f5f65999885542f95ba7b562848a` - there is twice
"Fix forgotten module release")
