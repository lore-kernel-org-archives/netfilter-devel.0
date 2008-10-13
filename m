From: David Miller <davem@davemloft.net>
Subject: Re: netfilter: remove unused #include <version.h>
Date: Sun, 12 Oct 2008 21:08:42 -0700 (PDT)
Message-ID: <20081012.210842.148758498.davem@davemloft.net>
References: <20081012231045.E7EC.WEIYI.HUANG@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: weiyi.huang@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55510
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752215AbYJMEJG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 00:09:06 -0400
In-Reply-To: <20081012231045.E7EC.WEIYI.HUANG@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Huang Weiyi <weiyi.huang@gmail.com>
Date: Sun, 12 Oct 2008 23:12:51 +0800

> The file(s) below do not use LINUX_VERSION_CODE nor KERNEL_VERSION.
>   net/netfilter/nf_tproxy_core.c
> 
> This patch removes the said #include <version.h>.
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Applied, thank you.
