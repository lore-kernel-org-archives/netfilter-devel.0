From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: sctp chunk mapping doesn't work
Date: Mon, 09 Feb 2009 15:36:00 +0100
Message-ID: <49903F50.6010803@trash.net>
References: <498AB0E2.50507@dev.6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: nicolas.dichtel@dev.6wind.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56208 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZBIOgE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 09:36:04 -0500
In-Reply-To: <498AB0E2.50507@dev.6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nicolas Dichtel wrote:
> When user tries to map all chunks given in argument, kernel works on a 
> copy of the chunkmap, but at the end it doesn't check the copy, but the 
> orginal one.

Applied, thanks Nicolas.
