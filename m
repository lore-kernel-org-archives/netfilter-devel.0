From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [LIBNL]: Fix nfnl_queue_msg_get_packetid() return type
Date: Thu, 7 Feb 2008 13:19:49 +0100
Message-ID: <20080207121949.GC11220@postel.suug.ch>
References: <47988458.4020209@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from postel.suug.ch ([194.88.212.233]:46920 "EHLO postel.suug.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbYBGMT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:19:29 -0500
Content-Disposition: inline
In-Reply-To: <47988458.4020209@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* Patrick McHardy <kaber@trash.net> 2008-01-24 13:28
>     [LIBNL]: Fix nfnl_queue_msg_get_packetid() return type
>     
>     The packet-ID is a 32 bit value, but nfnl_queue_msg_get_packetid() returns
>     an uint16_t. Makes queueing fail after 2^16 packets.
>     
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied, thanks Patrick.
