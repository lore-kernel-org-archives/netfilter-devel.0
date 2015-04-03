From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH] parser: add kludges for "param-problem" and "redirect"
Date: Fri, 03 Apr 2015 20:06:14 +0200
Message-ID: <551ED696.4070001@ahsoftware.de>
References: <551BEF7F.3050908@ahsoftware.de> <1428083429-7042-1-git-send-email-holler@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:56501 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbbDCSGU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Apr 2015 14:06:20 -0400
Received: from wandq.ahsoftware (p4FC37D76.dip0.t-ipconnect.de [79.195.125.118])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id D48D82C9C1C8
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2015 20:06:18 +0200 (CEST)
In-Reply-To: <1428083429-7042-1-git-send-email-holler@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 03.04.2015 um 19:50 schrieb Alexander Holler:
> Context sensitive handling of "param-problem" and "redirect" is necessary
> to allow usage of them as token or as string for icmp types.
>
> Without this patch, e.g. the following fails:
>
> nft add rule filter input icmp type redirect accept
> nft add rule filter input icmpv6 type param-problem accept
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---

Just in case of, I have not tested this extensively.

So please be careful with that patch and review it.

E.g. I'm not sure if I might have forgotten to set icmp_flag = 0 in 
another desctructor than those two I've added it too because I haven't 
tested rules which are using "redirect" or param-problem as token and 
not just as string to describe an icmp type as in the above two statements.

Regards,

Alexander Holler
