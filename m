From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH -next] netfilter: xt_IDLETIMER needs kdev_t.h
Date: Tue, 22 Jun 2010 08:14:03 +0200
Message-ID: <4C2054AB.8060800@trash.net>
References: <20100618145443.77b7f8df.sfr@canb.auug.org.au> <20100618153455.dd33948b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	netdev <netdev@vger.kernel.org>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40807 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab0FVGOE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:14:04 -0400
In-Reply-To: <20100618153455.dd33948b.randy.dunlap@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add header file to fix build error:
> net/netfilter/xt_IDLETIMER.c:276: error: implicit declaration of function 'MKDEV'
>   

Applied, thanks Randy.
