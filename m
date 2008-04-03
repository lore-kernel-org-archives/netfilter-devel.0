From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH 08/24] [NETFILTER]: rename NF_ARP to AF_ARP and assign
 a non-clashing value
Date: Thu, 03 Apr 2008 23:05:53 +0900 (JST)
Message-ID: <20080403.230553.122103252.yoshfuji@linux-ipv6.org>
References: <47F4D8F3.70606@trash.net>
	<20080403.225450.17235422.yoshfuji@linux-ipv6.org>
	<47F4E28E.4050606@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@vger.kernel.org,
	yoshfuji@linux-ipv6.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yue.linux-ipv6.org ([203.178.140.15]:60293 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757200AbYDCOER (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 10:04:17 -0400
In-Reply-To: <47F4E28E.4050606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In article <47F4E28E.4050606@trash.net> (at Thu, 03 Apr 2008 15:58:38 +0200), Patrick McHardy <kaber@trash.net> says:

> It sets a bad example to add new non-families there as well.
> We're dimensioning lots of things using AF_MAX, so its better
> to avoid misuse.

Assuming large values do not harm, I totally agree. 

--yoshfuji
