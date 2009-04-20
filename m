From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack-utils needs to autoload netlink
Date: Mon, 20 Apr 2009 16:45:03 +0200
Message-ID: <49EC8A6F.6070309@trash.net>
References: <alpine.LSU.2.00.0904191307310.31907@fbirervta.pbzchgretzou.qr> <49EB0ECA.1000405@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33791 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbZDTOpH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 10:45:07 -0400
In-Reply-To: <49EB0ECA.1000405@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> I wrote a patch time ago to load nf_conntrack_netlink from user-space
> when `conntrack -E' is invoked. I don't see a way to fix this in the
> kernel code, so that's the only idea that I can find to fix this
> problem. Still, I don't like too much the idea of doing the autoload
> from user-space.

You could add a callback for multicast-binds and have that callback
load the nfnetlink-specific module.
