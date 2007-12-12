From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/02]: ctnetlink: set expected bit for related
 conntracks
Date: Wed, 12 Dec 2007 10:34:38 -0800 (PST)
Message-ID: <20071212.103438.79506811.davem@davemloft.net>
References: <20071211174205.1042.29518.sendpatchset@localhost.localdomain>
	<20071211174206.1042.7817.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39503
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751714AbXLLSek (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:34:40 -0500
In-Reply-To: <20071211174206.1042.7817.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 11 Dec 2007 18:42:09 +0100 (MET)

> [NETFILTER]: ctnetlink: set expected bit for related conntracks
> 
> This patch is a fix. It sets IPS_EXPECTED for related conntracks.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied to net-2.6
