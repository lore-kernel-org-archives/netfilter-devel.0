From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2/7 [NETFILTER]: Rename ipt_recent to xt_recent
Date: Thu, 04 Sep 2008 16:45:28 +0200
Message-ID: <48BFF488.8000504@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131926010.13154@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63305 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYIDOpb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:45:31 -0400
In-Reply-To: <alpine.LNX.1.10.0808131926010.13154@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> [NETFILTER]: Rename ipt_recent to xt_recent
> 
> Like with other modules (such as ipt_state), ipt_recent.h is changed
> to forward definitions to (IOW include) xt_recent.h, and xt_recent.c
> is changed to use the new constant names.

Applied.
