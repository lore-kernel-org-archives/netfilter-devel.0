From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 13/27] xt_helper: Do not bypass RCU
Date: Fri, 4 Jan 2008 16:09:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041608350.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022128550.14900@fbirervta.pbzchgretzou.qr>
 <477E4A56.20601@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50735 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYADPJN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:09:13 -0500
In-Reply-To: <477E4A56.20601@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 16:01, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 6c922317906546b99afe859faa0c15d46d79dd37
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Wed Jan 2 18:00:29 2008 +0100
>> 
>>     [NETFILTER]: xt_helper: Do not bypass RCU
>>     
>>     Use the @helper variable that was just obtained.
>
> Applied for 2.6.24, I hope that doesn't cause clashes with the
> following patches.
>
Correct. The changed lines lie outside the context for the other
patch following this one (xt_helper v1).
