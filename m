From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 2.6.25 1/1]: ipt_CLUSTERIP: fix race between
 clusterip_config_find_get and _entry_put
Date: Mon, 14 Apr 2008 00:45:11 -0700 (PDT)
Message-ID: <20080414.004511.73598990.davem@davemloft.net>
References: <48026B67.1040706@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34960
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756025AbYDNHpK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:45:10 -0400
In-Reply-To: <48026B67.1040706@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 13 Apr 2008 22:21:59 +0200

> [NETFILTER]: ipt_CLUSTERIP: fix race between clusterip_config_find_get and _entry_put

Applied, thanks.
