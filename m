From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: xtables: add missing const qualifier to xt_tgchk_param
Date: Wed, 19 Nov 2008 13:47:50 +0100
Message-ID: <49240AF6.1080307@trash.net>
References: <alpine.LNX.1.10.0811181229370.17946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62868 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYKSMr4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2008 07:47:56 -0500
In-Reply-To: <alpine.LNX.1.10.0811181229370.17946@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> netfilter: xtables: add missing const qualifier to xt_tgchk_param
> 
> When entryinfo was a standalone parameter to functions, it used to be
> "const void *". Put the const back in.

Applied, thanks.

