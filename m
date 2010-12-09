From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: don't need to initialize instance_table
Date: Thu, 09 Dec 2010 11:56:48 -0800 (PST)
Message-ID: <20101209.115648.104053657.davem@davemloft.net>
References: <1291889421-10794-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37223
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920Ab0LIT4U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Dec 2010 14:56:20 -0500
In-Reply-To: <1291889421-10794-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Changli Gao <xiaosuo@gmail.com>
Date: Thu,  9 Dec 2010 18:10:21 +0800

> Since instance_table is a static array, and has been zeroed already, we
> don't need to take CPU cycles to initialize it.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

Adding a dependency on the implementation of HLISTs is not a good
idea, I would not apply this patch.
