From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] nefilter: use pr_devel instead of pr_debug
Date: Thu, 22 Apr 2010 04:01:13 -0700 (PDT)
Message-ID: <20100422.040113.179187181.davem@davemloft.net>
References: <4BD02914.9030100@trash.net>
	<alpine.LSU.2.01.1004221248010.31972@obet.zrqbmnf.qr>
	<4BD02C48.6060904@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49772
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab0DVLBI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:01:08 -0400
In-Reply-To: <4BD02C48.6060904@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 22 Apr 2010 13:00:24 +0200

> I've noticed you already included a few pr_devel() statements in a
> recent submission. I'd rather convert those to pr_debug()

Agreed, don't start going down this silly pr_devel() road.
