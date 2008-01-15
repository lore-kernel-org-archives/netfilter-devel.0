From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/27] xt_hashlimit: use the new union nf_inet_addr
Date: Tue, 15 Jan 2008 06:53:42 +0100
Message-ID: <478C4A66.3050403@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128240.14900@fbirervta.pbzchgretzou.qr> <477E4967.1040207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbYAOFxt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 00:53:49 -0500
In-Reply-To: <477E4967.1040207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 80d12da7b0d6cce28719db2a4ced58e46f28107f
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Wed Jan 2 17:56:28 2008 +0100
>>
>>     [NETFILTER]: xt_hashlimit: use the new union nf_inet_addr
> 
> Applied, thanks.


I wasn't paying attention I guess, this patch practically
reverts the memory optimization done by Eric Dumazet just
a few weeks ago, so I'm dropping it again.

