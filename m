From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/1] Netfilter fixes for 2.6.37 (round 3)
Date: Thu, 13 Jan 2011 12:34:34 -0800 (PST)
Message-ID: <20110113.123434.158425746.davem@davemloft.net>
References: <1294935558-4106-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42663
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430Ab1AMUeC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:34:02 -0500
In-Reply-To: <1294935558-4106-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: pablo@netfilter.org
Date: Thu, 13 Jan 2011 17:19:18 +0100

> Still another bugfix pending. I'm sorry, this one was incorporated
> to Patrick's tree before Dec 16th and I thought that it followed
> its patch to your tree.
> 
> Holger reported that it didn't. You can pull it from:
> 
> git://1984.lsi.us.es/net-2.6 master
> 
> Pablo Neira Ayuso (1):
>   netfilter: ctnetlink: fix loop in ctnetlink_get_conntrack()

Pulled, thanks!
