From: David Miller <davem@davemloft.net>
Subject: Re: [net-next PATCH 04/16] Make inet_sock.h independent of route.h
Date: Wed, 01 Oct 2008 07:34:17 -0700 (PDT)
Message-ID: <20081001.073417.133905351.davem@davemloft.net>
References: <20081001142431.4893.48078.stgit@este>
	<20081001142431.4893.41703.stgit@este>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: hidden@sch.bme.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50395
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbYJAOe3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:34:29 -0400
In-Reply-To: <20081001142431.4893.41703.stgit@este>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: KOVACS Krisztian <hidden@sch.bme.hu>
Date: Wed, 01 Oct 2008 16:24:31 +0200

> inet_iif() in inet_sock.h requires route.h. Since users of inet_iif()
> usually require other route.h functionality anyway this patch moves
> inet_iif() to route.h.
> 
> Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>

Applied to net-next-2.6

This may create some build fallout for some configurations
on some architectures, because some files may have been
depending upon that implicit inclusion of net/route.h

We'll have to fix them up, so this is just a heads up.
