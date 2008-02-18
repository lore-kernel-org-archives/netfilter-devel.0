From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][NETFILTER]: Drop the actually unused variable from u32_match_it.
Date: Mon, 18 Feb 2008 16:44:35 +0100
Message-ID: <47B9A7E3.2020400@trash.net>
References: <47B9A46E.5090608@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pavel Emelyanov <xemul@openvz.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:7790 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756523AbYBRPoo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2008 10:44:44 -0500
In-Reply-To: <47B9A46E.5090608@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pavel Emelyanov wrote:
> The int ret variable is used only to trigger the BUG_ON() after 
> the skb_copy_bits() call, so check the call failure directly 
> and drop the variable.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Applied, thanks.
