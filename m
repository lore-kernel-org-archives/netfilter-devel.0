From: David Miller <davem@davemloft.net>
Subject: Re: netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule
 insertion
Date: Wed, 24 Sep 2008 15:53:46 -0700 (PDT)
Message-ID: <20080924.155346.120205553.davem@davemloft.net>
References: <48DA65BB.6080605@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42031
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbYIXWx6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2008 18:53:58 -0400
In-Reply-To: <48DA65BB.6080605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 24 Sep 2008 18:07:23 +0200

> Hi Dave,
> 
> the following netfilter patch is intended for 2.6.27. According to
> Yasuyuki, it fixes a potential security problem that is currently
> not an issue because userspace is sufficiently broken so the feature
> can't be used, but once we fix userspace it might be used on old
> kernels and the problem will be an issue. So I agree with Yasuyuki
> that this should go in 2.6.27 (and -stable afterwards).
> 
> Please apply, thanks.

Applied, thanks Patrick.
