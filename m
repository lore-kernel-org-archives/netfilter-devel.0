From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 05/08: nfnetlink_log: send complete hardware header
Date: Mon, 21 Jul 2008 10:05:55 -0700 (PDT)
Message-ID: <20080721.100555.158849505.davem@davemloft.net>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
	<20080721161729.28572.71670.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58552
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYGURFz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:05:55 -0400
In-Reply-To: <20080721161729.28572.71670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 21 Jul 2008 18:17:29 +0200 (MEST)

> netfilter: nfnetlink_log: send complete hardware header
> 
> This patch adds some fields to NFLOG to be able to send the complete
> hardware header with all necessary informations.
> It sends to userspace:
>  * the type of hardware link
>  * the lenght of hardware header
>  * the hardware header
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
