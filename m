From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 01/01: netns ct: walk netns list under RTNL
Date: Wed, 05 Nov 2008 03:03:29 -0800 (PST)
Message-ID: <20081105.030329.262482544.davem@davemloft.net>
References: <49117BC8.3010000@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51815
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbYKELDy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2008 06:03:54 -0500
In-Reply-To: <49117BC8.3010000@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 05 Nov 2008 11:56:08 +0100

> following is a single netfilter fix from Alexey Dobriyan,
> fixing an oops caused by a race between netfilter module
> unloading and namespace exit.
> 
> Please apply, thanks.

Applied, thanks Patrick.
