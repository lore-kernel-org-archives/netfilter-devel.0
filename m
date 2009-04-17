From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: nfnetlink: return ENOMEM if we fail to
 create	netlink socket
Date: Fri, 17 Apr 2009 17:50:39 +0200
Message-ID: <49E8A54F.7000704@trash.net>
References: <20090417090010.11291.31173.stgit@Decadence> <20090417090548.11291.94506.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56571 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZDQPul (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:50:41 -0400
In-Reply-To: <20090417090548.11291.94506.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> With this patch, nfnetlink returns -ENOMEM instead of -EPERM if we
> fail to create the nfnetlink netlink socket during the module
> loading. This is exactly what rtnetlink does in this case.

Also applied, thanks.

> Ideally, it would be better if we propagate the error that has
> happened in netlink_kernel_create(), however, this function still
> does not implement this yet.

Agreed, but AFAICS netlink_kernel_create() only returns an error
on memory shortage, so this is fine currently.
