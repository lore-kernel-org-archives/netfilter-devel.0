From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 21/27] Convert unfixated types to fixated ones
Date: Tue, 8 Jan 2008 17:14:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801081714010.3032@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022130570.14900@fbirervta.pbzchgretzou.qr>
 <47839C46.5050905@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39471 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759431AbYAHQOk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:14:40 -0500
In-Reply-To: <47839C46.5050905@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 8 2008 16:52, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 69855da1bb8257b215c83a72edd0c67bd7810fa5
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Wed Jan 2 18:30:30 2008 +0100
>> 
>>     [NETFILTER]: Convert unfixated types to fixated ones.
>>     
>>     The use of an unfixated type like "int" is dangerous, its size may
>>     change in future (imagine 128-bit or ILP64 compilation) -- "long"
>>     already has this problem which is differently-sized on x86_32 and
>>     x86_64. Switch "int" to "int32_t" to prepare against future compiler
>>     changes.
>
>
> If that really happens a lot of things would break, so I don't
> really see the point. It also changes types like char whose
> size won't ever change.
>
int8_t would serve as an intent annotation that the member is used
for a numeric value rather than a character. Well, never mind.
