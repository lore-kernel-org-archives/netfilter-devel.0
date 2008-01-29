From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_hashlimit: remove unneeded struct member
Date: Tue, 29 Jan 2008 19:20:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291913310.14907@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801291636390.14907@fbirervta.pbzchgretzou.qr>
 <479F6BEB.8010601@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51383 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933764AbYA2SU2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:20:28 -0500
In-Reply-To: <479F6BEB.8010601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 29 2008 19:09, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 9cd6d44dfc02166640166a44c27c3dc0a98b4ac3
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Tue Jan 29 16:30:58 2008 +0100
>> 
>>     [NETFILTER]: xt_hashlimit: remove unneeded struct member
>>     
>>     By allocating ->hinfo, we already have the needed indirection to cope
>>     with the per-cpu xtables struct match_entry.
>
>
> You already sent this 30 minutes ago. This is not helping me
> getting rid of my backlog ...
>
Oops, was just a glitch in the matrix here I guess :)
