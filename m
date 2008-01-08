From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 22/27] Rename ipt_iprange to xt_iprange
Date: Tue, 08 Jan 2008 17:25:10 +0100
Message-ID: <4783A3E6.7080503@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022131230.14900@fbirervta.pbzchgretzou.qr> <47839CFA.9090005@trash.net> <Pine.LNX.4.64.0801081714430.3032@fbirervta.pbzchgretzou.qr> <4783A34D.9070606@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63974 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbYAHQ3I (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:29:08 -0500
In-Reply-To: <4783A34D.9070606@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit febc0e221181b2c370ee9cdd313fd2bc145cb30a
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Wed Jan 2 18:49:22 2008 +0100
>>
>>     [NETFILTER]: Rename ipt_iprange to xt_iprange
>>         This patch moves ipt_iprange to xt_iprange, in preparation for 
>> adding
>>     IPv6 support to xt_iprange.
>>         Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> Applied, thanks.

And added the missing Kbuild update. Please verify your other patches
were complete.
