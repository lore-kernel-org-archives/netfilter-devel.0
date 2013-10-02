From: "Arend van Spriel" <arend@broadcom.com>
Subject: Re: [PATCH net-next] net:drivers/net: Miscellaneous conversions
 to ETH_ALEN
Date: Wed, 2 Oct 2013 09:27:00 +0200
Message-ID: <524BCAC4.6060209@broadcom.com>
References: <1380679480.2081.24.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	e1000-devel@lists.sourceforge.net, linux-usb@vger.kernel.org,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, bridge@lists.linux-foundation.org,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: "Joe Perches" <joe@perches.com>, netdev <netdev@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4510 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3JBH1N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:27:13 -0400
In-Reply-To: <1380679480.2081.24.camel@joe-AO722>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/02/2013 04:04 AM, Joe Perches wrote:
> Convert the memset/memcpy uses of 6 to ETH_ALEN
> where appropriate.
>
> Also convert some struct definitions and u8 array
> declarations of [6] to ETH_ALEN.
>
For brcmsmac

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/net/wireless/brcm80211/brcmsmac/main.c     |  6 +-


